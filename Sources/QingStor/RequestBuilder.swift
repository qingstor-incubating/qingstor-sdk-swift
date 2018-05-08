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

public typealias RequestProgress = (Progress) -> Void
public typealias RequestCompletion<T: BaseMappable> = (Response<T>?, Error?) -> Void
public typealias BuildCompletion = (URLRequest?, Error?) -> Void

private typealias _BuildCompletion = (Request?, Error?) -> Void

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

@objc(QSParameterEncodingType)
public enum ParameterEncodingType: Int {
    case query, json, binary
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
    public let output: T
    public let rawResponse: HTTPURLResponse

    open var statusCode: Int { return rawResponse.statusCode }

    public init(rawResponse: HTTPURLResponse, output: T) {
        self.rawResponse = rawResponse
        self.output = output
    }
}

@objc(QSRequestBuilder)
open class RequestBuilder: NSObject {
    @objc public var context: APIContext
    public var method: HTTPMethod
    @objc public var parameters: [String:Any]
    public var signer: Signer
    @objc public var headers: [String:String] = [:]
    @objc public var credential: URLCredential?
    @objc public var encoding: ParameterEncodingType
    @objc public var isDownload: Bool
    @objc public var downloadDestination: URL?
    @objc public var acceptableStatusCodes: [Int]?
    @objc public var writeHeadersToOutput: Bool
    @objc public var buildingQueue: DispatchQueue
    @objc public var callbackQueue: DispatchQueue

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
                         writeHeadersToOutput: Bool = false,
                         buildingQueue: DispatchQueue = DispatchQueue.global(),
                         callbackQueue: DispatchQueue = DispatchQueue.main) {
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
        self.buildingQueue = buildingQueue
        self.callbackQueue = callbackQueue

        super.init()

        self.buildDefaultHeader()
    }

    @objc public func buildRequest(completion: @escaping BuildCompletion) { }

    public func send<T>(progress: RequestProgress? = nil, completion: @escaping RequestCompletion<T>) { }

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
                    var result = "\(QingStorSDKVersion) (\(osNameVersion))"

                    if let executable = executable, let appVersion = appVersion {
                        result += " \(executable)/\(appVersion)"
                    }

                    if let bundle = bundle, let appBuild = appBuild {
                        result += " (\(bundle); build:\(appBuild);)"
                    }

                    return result.trimmingCharacters(in: CharacterSet.whitespaces)
                }()
            }

            return "qingstor-sdk-swift"
        }()
    }
}

@objc(QSDefaultRequestBuilder)
open class DefaultRequestBuilder: RequestBuilder, RequestAdapter {
    fileprivate var buildingRequestError: Error?

    static let sessionManager: Alamofire.SessionManager = {
        let configuration = URLSessionConfiguration.default
        configuration.httpAdditionalHeaders = SessionManager.defaultHTTPHeaders

        let sessionManager = Alamofire.SessionManager(configuration: configuration)
        sessionManager.startRequestsImmediately = false

        return sessionManager
    }()

    public func adapt(_ urlRequest: URLRequest) throws -> URLRequest {
        var request = urlRequest

        if let headers = urlRequest.allHTTPHeaderFields {
            self.addHeaders(headers)
        }

        do {
            try self.signer.writeSignature(to: self)
        } catch {
            buildingRequestError = error
        }

        request.url = self.context.url
        request.allHTTPHeaderFields = self.headers
        return request
    }

    @objc public override func buildRequest(completion: @escaping BuildCompletion) {
        self._buildRequest { request, error in
            self.callbackQueue.async {
                completion(request?.request, error)
            }
        }
    }

    fileprivate func _buildRequest(completion: @escaping _BuildCompletion) {
        buildingQueue.async {
            let sessionManager = DefaultRequestBuilder.sessionManager
            sessionManager.adapter = self

            let httpMethod = Alamofire.HTTPMethod(rawValue: self.method.rawValue)
            var encoding: Alamofire.ParameterEncoding

            switch self.encoding {
            case .json:
                encoding = Alamofire.JSONEncoding.default
            default:
                encoding = Alamofire.URLEncoding.default
            }

            if self.isDownload {
                var destination: DownloadRequest.DownloadFileDestination? = nil
                if let url = self.downloadDestination {
                    destination = { _, _ in (url, [.removePreviousFile, .createIntermediateDirectories]) }
                }

                let request = sessionManager.download(self.context.url, method: httpMethod!, parameters: self.parameters, encoding: encoding, headers: self.headers, to: destination)
                completion(request, nil)
            } else {
                if self.encoding == .binary, let inputStream = self.parameters["body"] as? InputStream {
                    let request = sessionManager.upload(inputStream,
                                                        to: self.context.url,
                                                        method: httpMethod!,
                                                        headers: self.headers)
                    if let error = self.buildingRequestError {
                        completion(nil, error)
                        self.buildingRequestError = nil
                    } else {
                        completion(request, nil)
                    }
                } else {
                    let request = sessionManager.request(self.context.url,
                                                         method: httpMethod!,
                                                         parameters: self.parameters,
                                                         encoding: encoding,
                                                         headers: self.headers)
                    if let error = self.buildingRequestError {
                        completion(nil, error)
                        self.buildingRequestError = nil
                    } else {
                        completion(request, nil)
                    }
                }
            }
        }
    }

    public override func send<T>(progress: RequestProgress? = nil, completion: @escaping RequestCompletion<T>) {
        self._buildRequest { request, error in
            if let request = request {
                self.processRequest(request: request, progress: progress, completion: completion)
            } else {
                self.callbackQueue.async {
                    completion(nil, error ?? APIError.buildingRequestError(info: "build request request"))
                }
            }
        }
    }

    fileprivate func processRequest<T>(request: Request, progress: RequestProgress? = nil, completion: @escaping RequestCompletion<T>) {
        if let credential = self.credential {
            request.authenticate(usingCredential: credential)
        }

        var statusCode = Array(200..<300)
        if self.acceptableStatusCodes != nil {
            statusCode.append(contentsOf: self.acceptableStatusCodes!)
        }

        if let progress = progress {
            switch request {
            case let downloadRequest as DownloadRequest:
                downloadRequest.downloadProgress(closure: progress)

            case let uploadRequest as UploadRequest:
                uploadRequest.uploadProgress(closure: progress)

            case let dataRequest as DataRequest:
                dataRequest.downloadProgress(closure: progress)

            default: break
            }
        }

        if let dataRequest = request as? DataRequest {
            dataRequest
                .validate(statusCode: statusCode)
                .responseOutput(queue: self.callbackQueue, writeHeaders: self.writeHeadersToOutput) { (response: DataResponse<T>) in
                    if response.result.isFailure {
                        completion(nil, response.result.error)
                        return
                    }

                    if let output = response.result.value {
                        completion(Response(rawResponse: response.response!, output: output), nil)
                    } else {
                        completion(nil, NSError(domain: "localhost", code: 500, userInfo: ["reason": "unreacheable code"]))
                    }
                }.resume()
        } else if let downloadRequest = request as? DownloadRequest {
            downloadRequest
                .validate(statusCode: statusCode)
                .responseOutput(queue: self.callbackQueue, writeHeaders: self.writeHeadersToOutput) { (response: DownloadResponse<T>) in
                    if response.result.isFailure {
                        completion(nil, response.result.error)
                        return
                    }

                    if let output = response.result.value {
                        completion(Response(rawResponse: response.response!, output: output), nil)
                    } else {
                        completion(nil, NSError(domain: "localhost", code: 500, userInfo: ["reason": "unreacheable code"]))
                    }
                }.resume()
        }
    }
}
