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

/// The request progress callback.
public typealias RequestProgress = (Progress) -> Void

/// The request completion callback.
public typealias RequestCompletion<T: BaseMappable> = (Response<T>?, Error?) -> Void

/// The request build completion callback.
public typealias BuildCompletion = (URLRequest?, Error?) -> Void

private typealias _BuildCompletion = (Request?, Error?) -> Void

/// HTTP method definitions.
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

/// Parameter encoding type definitions.
@objc(QSParameterEncodingType)
public enum ParameterEncodingType: Int {
    /// The query encoding, will using url encode to handle parameters to the url query.
    case query

    // The json encoding, will using json encode to hanlde parameters to the request body.
    case json

    // The binary encoding, will put binary data to the request body.
    case binary
}

/// Request builder factory protocol.
public protocol RequestBuilderFactory {
    /// Returned the builder type.
    func getBuilder() -> RequestBuilder.Type
}

/// Default request builder factory.
open class DefaultRequestBuilderFactory: RequestBuilderFactory {
    /// Returned default request builder type.
    public func getBuilder() -> RequestBuilder.Type {
        return DefaultRequestBuilder.self
    }
}

/// Store http response data, and map to api output.
open class Response<T: BaseMappable> {
    /// The api output.
    public let output: T

    /// The server response.
    public let rawResponse: HTTPURLResponse

    /// The response status code.
    open var statusCode: Int { return rawResponse.statusCode }

    /// Initialize `Response` with the specified `rawResponse` and `output`.
    ///
    /// - parameter rawResponse: The server response.
    /// - parameter output:      The api output.
    public init(rawResponse: HTTPURLResponse, output: T) {
        self.rawResponse = rawResponse
        self.output = output
    }
}

/// Build and send api request base class.
@objc(QSRequestBuilder)
open class RequestBuilder: NSObject {
    /// The api context.
    @objc public var context: APIContext

    /// The HTTP method.
    public var method: HTTPMethod

    /// The api request parameters.
    @objc public var parameters: [String:Any]

    /// The signer.
    public var signer: Signer

    /// The HTTP headers.
    @objc public var headers: [String:String] = [:]

    /// The url credential.
    @objc public var credential: URLCredential?

    /// The parameter encoding type.
    @objc public var encoding: ParameterEncodingType

    /// Whether the download file request.
    @objc public var isDownload: Bool

    /// The url where the file should be saved.
    @objc public var downloadDestination: URL?

    /// The acceptable status codes.
    @objc public var acceptableStatusCodes: [Int]?

    /// Whether write headers to output data.
    @objc public var writeHeadersToOutput: Bool

    /// The building queue.
    @objc public var buildingQueue: DispatchQueue

    /// The callback queue.
    @objc public var callbackQueue: DispatchQueue

    /// Initialize `RequestBuilder` with specified parameters.
    ///
    /// - parameter context:                The api context.
    /// - parameter method:                 The HTTP method.
    /// - parameter parameters:             The api request parameters.
    /// - parameter signer:                 The signer.
    /// - parameter headers:                The HTTP headers.
    /// - parameter credential:             The url credential.
    /// - parameter encoding:               The parameter encoding type.
    /// - parameter isDownload:             Whether the download file request.
    /// - parameter downloadDestination:    The url where the file should be saved.
    /// - parameter acceptableStatusCodes:  The acceptable status codes.
    /// - parameter writeHeadersToOutput:   Whether write headers to output data.
    /// - parameter buildingQueue:          The building queue.
    /// - parameter callbackQueue:          The callback queue.
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

    /// Build the request, default is do nothing, should implement it in child class.
    ///
    /// - parameter completion: Build completion callback.
    @objc public func buildRequest(completion: @escaping BuildCompletion) { }

    /// Send request, default is do nothing, should implement it in child class.
    ///
    /// - parameter progress: Request progress callback.
    /// - parameter completion: Request completion callback.
    public func send<T>(progress: RequestProgress? = nil, completion: @escaping RequestCompletion<T>) { }

    /// Add HTTP headers.
    ///
    /// - parameter headers: The HTTP headers.
    @objc public func addHeaders(_ headers: [String:String]) {
        for (key, value) in headers {
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

/// Default request builder.
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

    /// Implement `RequestAdapter` protocol.
    public func adapt(_ urlRequest: URLRequest) throws -> URLRequest {
        var request = urlRequest

        if let headers = urlRequest.allHTTPHeaderFields {
            self.addHeaders(headers)
        }

        if self.signer.precheck(from: self) {
            do {
                try self.signer.writeSignature(to: self)
            } catch {
                buildingRequestError = error
            }
        }

        request.url = self.context.url
        request.allHTTPHeaderFields = self.headers
        return request
    }

    /// Build request.
    ///
    /// - parameter completion: Build completion callback.
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

    /// Send request.
    ///
    /// - parameter progress: Request progress callback.
    /// - parameter completion: Request completion callback.
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
