//
//  RequestBuilder.swift
//
// +-------------------------------------------------------------------------
// | Copyright (C) 2016 Yunify, Inc.
// +-------------------------------------------------------------------------
// | Licensed under the Apache License, Version 2.0 (the "License");
// | you may not use this work except in compliance with the License.
// | You may obtain a copy of the License in the LICENSE file, or at:
// |
// | http://www.apache.org/licenses/LICENSE-2.0
// |
// | Unless required by applicable law or agreed to in writing, software
// | distributed under the License is distributed on an "AS IS" BASIS,
// | WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// | See the License for the specific language governing permissions and
// | limitations under the License.
// +-------------------------------------------------------------------------
//

import Foundation
import Alamofire
import ObjectMapper

public typealias RequestCompletion<T: BaseMappable> = (_ response: Response<T>?, _ error: Error?) -> Void
public typealias BuildCompletion = (_ request: URLRequest?, _ error: Error?) -> Void

fileprivate typealias _BuildCompletion = (_ request: Request?, _ error: Error?) -> Void

public enum HTTPMethod: String {
    case options = "OPTIONS"
    case get     = "GET"
    case head    = "HEAD"
    case post    = "POST"
    case put     = "PUT"
    case patch   = "PATCH"
    case delete  = "DELETE"
    case trace   = "TRACE"
    case connect = "CONNECT"
}

public enum ParameterEncodingType {
    case query, multipart, json, binary
}

public protocol RequestBuilderFactory {
    func getBuilder() -> RequestBuilder.Type
}

open class DefaultRequestBuilderFactory: RequestBuilderFactory {
    public func getBuilder() -> RequestBuilder.Type {
        return DefaultRequestBuilder.self
    }
}

open class Response<T: BaseMappable> {
    public let response: HTTPURLResponse
    public let output: T

    public init(response: HTTPURLResponse, output: T) {
        self.response = response
        self.output = output
    }
}

open class RequestBuilder {
    public var context: APIContext
    public var method: HTTPMethod
    public var parameters: [String:Any]
    public var signer: Signer
    public var headers: [String:String] = [:]
    public var credential: URLCredential?
    public var encoding: ParameterEncodingType
    public var isDownload: Bool
    public var downloadDestination: URL?
    public var acceptableStatusCodes: [Int]?
    public var writeHeadersToOutput: Bool

    public required init(context: APIContext,
                         method: HTTPMethod = .get,
                         parameters: [String:Any] = [:],
                         signer: Signer,
                         headers: [String:String] = [:],
                         credential: URLCredential? = nil,
                         encoding: ParameterEncodingType = .query,
                         isDownload: Bool = false,
                         downloadDestination: URL? = nil,
                         acceptableStatusCodes: [Int]? = nil,
                         writeHeadersToOutput: Bool = false) {
        self.context = context
        self.method = method
        self.parameters = parameters
        self.signer = signer
        self.headers = headers
        self.credential = credential
        self.encoding = encoding
        self.isDownload = isDownload
        self.downloadDestination = downloadDestination
        self.acceptableStatusCodes = acceptableStatusCodes
        self.writeHeadersToOutput = writeHeadersToOutput

        self.buildDefaultHeader()
    }

    public func buildRequest(completion: @escaping BuildCompletion) { }

    public func send<T: BaseMappable>(completion: @escaping RequestCompletion<T>) { }

    func addHeaders(_ aHeaders: [String:String]) {
        for (key, value) in aHeaders {
            self.headers[key] = value
        }
    }

    func buildDefaultHeader() {
        self.headers["User-Agent"] = {
            if let info = Bundle.main.infoDictionary {
                let executable = info[kCFBundleExecutableKey as String] as? String
                let appVersion = info["CFBundleShortVersionString"] as? String

                let bundle = info[kCFBundleIdentifierKey as String] as? String
                let appBuild = info[kCFBundleVersionKey as String] as? String

                let osNameVersion: String = {
                    let version = ProcessInfo.processInfo.operatingSystemVersion
                    let versionString = "\(version.majorVersion).\(version.minorVersion).\(version.patchVersion)"

                    let osName: String = {
                        #if os(iOS)
                            return "iOS"
                        #elseif os(watchOS)
                            return "watchOS"
                        #elseif os(tvOS)
                            return "tvOS"
                        #elseif os(macOS)
                            return "OS X"
                        #elseif os(Linux)
                            return "Linux"
                        #else
                            return "Unknown"
                        #endif
                    }()

                    return "\(osName)/\(versionString)"
                }()

                let QingStorSDKVersion: String = {
                    guard
                        let afInfo = Bundle(for: RequestBuilder.self).infoDictionary,
                        let build = afInfo["CFBundleShortVersionString"]
                        else { return "qingstor-sdk-swift" }

                    return "qingstor-sdk-swift/\(build)"
                }()

                return {
                    var result = "\(QingStorSDKVersion) \(osNameVersion) "

                    if let executable = executable, let appVersion = appVersion {
                        result += "\(executable)/\(appVersion) "
                    }

                    if let bundle = bundle, let appBuild = appBuild {
                        result += "(\(bundle); build:\(appBuild);) "
                    }

                    return result.trimmingCharacters(in: CharacterSet.whitespaces)
                }()
            }

            return "qingstor-sdk-swift"
        }()
    }
}

open class DefaultRequestBuilder: RequestBuilder {

    var request: Request?

    public override func buildRequest(completion: @escaping BuildCompletion) {
        self._buildRequest { request, error in
            completion(request?.request, error)
        }
    }

    fileprivate func _buildRequest(completion: @escaping _BuildCompletion) {
        if let request = request {
            completion(request, nil)
        } else {
            self._buildRequest(isFake: true) { request, error in
                if let request = request {
                    if let headers = request.request?.allHTTPHeaderFields {
                        self.addHeaders(headers)
                    }

                    do {
                        try self.signer.writeSignature(to: self)
                    } catch {
                        completion(nil, APIError.buildingRequestError(info: "write signature error"))
                        return
                    }

                    self._buildRequest(isFake: false) { request, error in
                        if let request = request {
                            completion(request, nil)
                        } else {
                            completion(nil, error)
                        }
                    }
                } else {
                    completion(nil, error)
                }
            }
        }
    }

    fileprivate func _buildRequest(isFake: Bool, completion: @escaping _BuildCompletion) {
        let sessionManager = Alamofire.SessionManager.default
        let httpMethod = Alamofire.HTTPMethod(rawValue: method.rawValue)
        var encoding: Alamofire.ParameterEncoding
        var parameters = self.parameters

        if isFake {
            let inputStreamKeys = parameters.filter { $1 is InputStream }.map { $0.0 }
            for key in inputStreamKeys {
                parameters.removeValue(forKey: key)
            }
        }

        switch self.encoding {
        case .json:
            encoding = Alamofire.JSONEncoding.default
        case .binary:
            encoding = BinaryEncoding.default
        default:
            encoding = Alamofire.URLEncoding.default
        }

        if self.isDownload {
            var destination: DownloadRequest.DownloadFileDestination? = nil
            if let url = self.downloadDestination {
                destination = { _, _ in (url, [.removePreviousFile, .createIntermediateDirectories]) }
            }

            let request = sessionManager.download(self.context.url, method: httpMethod!, parameters: parameters, encoding: encoding, headers: self.headers, to: destination)
            completion(request, nil)
        } else {
            if self.encoding == .multipart {
                sessionManager.upload(
                    multipartFormData: { formData in
                        for (k, v) in parameters {
                            switch v {
                            case let data as Data:
                                formData.append(data, withName: k)
                            case let fileURL as URL:
                                formData.append(fileURL, withName: k)
                            case let string as String:
                                formData.append(string.data(using: String.Encoding.utf8)!, withName: k)
                            case let number as NSNumber:
                                formData.append(number.stringValue.data(using: String.Encoding.utf8)!, withName: k)
                            default:
                                fatalError("Unprocessable value \(v) with key \(k)")
                            }
                        }
                    },
                    usingThreshold: SessionManager.multipartFormDataEncodingMemoryThreshold,
                    to: self.context.url,
                    method: httpMethod!,
                    headers: self.headers,
                    encodingCompletion: { encodingResult in
                        switch encodingResult {
                        case .success(let uploadRequest, _, _):
                            completion(uploadRequest, nil)
                        case .failure(_):
                            completion(nil, APIError.encodingError(info: "parameters encoding error"))
                        }
                    }
                )
            } else {
                let request = sessionManager.request(self.context.url,
                                                     method: httpMethod!,
                                                     parameters: parameters,
                                                     encoding: encoding,
                                                     headers: self.headers)
                completion(request, nil)
            }
        }
    }

    public override func send<T: BaseMappable>(completion: @escaping RequestCompletion<T>) {
        self._buildRequest { request, error in
            if let request = request {
                self.processRequest(request: request, completion: completion)
            } else {
                completion(nil, error ?? APIError.buildingRequestError(info: "build request request"))
            }
        }
    }

    fileprivate func processRequest<T: BaseMappable>(request: Request, completion: @escaping RequestCompletion<T>) {
        if let credential = self.credential {
            request.authenticate(usingCredential: credential)
        }

        var statusCode = Array(200..<300)
        if self.acceptableStatusCodes != nil {
            statusCode.append(contentsOf: self.acceptableStatusCodes!)
        }

        if let dataRequest = request as? DataRequest {
            dataRequest.validate(statusCode: statusCode).responseOutput(writeHeaders: self.writeHeadersToOutput) { (response: DataResponse<T>) in
                if response.result.isFailure {
                    completion(nil, response.result.error)
                    return
                }

                if let output = response.result.value {
                    completion(Response(response: response.response!, output: output), nil)
                } else {
                    completion(nil, NSError(domain: "localhost", code: 500, userInfo: ["reason": "unreacheable code"]))
                }
            }
        } else if let downloadRequest = request as? DownloadRequest {
            downloadRequest.validate(statusCode: statusCode).responseOutput(writeHeaders: self.writeHeadersToOutput) { (response: DownloadResponse<T>) in
                if response.result.isFailure {
                    completion(nil, response.result.error)
                    return
                }

                if let output = response.result.value {
                    completion(Response(response: response.response!, output: output), nil)
                } else {
                    completion(nil, NSError(domain: "localhost", code: 500, userInfo: ["reason": "unreacheable code"]))
                }
            }
        }
    }
}
