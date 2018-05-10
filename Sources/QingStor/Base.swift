//
//  Base.swift
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
import ObjectMapper

/// The `Registry` class allows you to register QingStor service first.
/// Later use of APIContext will use registered data by default.
@objc(QSRegistry)
public class Registry: NSObject {
    /// The server base url string, like `https://qingstor.com:443/`
    @objc public static var baseURL: String?

    /// The QingCloud API AccessKey.
    @objc public static var accessKeyID: String?

    /// The QingCloud API SecretAccessKey.
    @objc public static var secretAccessKey: String?

    /// Register QingStor service.
    ///
    /// - parameter baseURL:         The base url.
    /// - parameter accessKeyID:     The AccessKey.
    /// - parameter secretAccessKey: The SecretAccessKey.
    @objc public static func register(baseURL: String?, accessKeyID: String, secretAccessKey: String) {
        self.baseURL = baseURL
        self.accessKeyID = accessKeyID
        self.secretAccessKey = secretAccessKey
    }

    /// Register QingStor service.
    ///
    /// - parameter accessKeyID:     The AccessKey.
    /// - parameter secretAccessKey: The SecretAccessKey.
    @objc public static func register(accessKeyID: String, secretAccessKey: String) {
        self.register(baseURL: nil, accessKeyID: accessKeyID, secretAccessKey: secretAccessKey)
    }

    /// Register QingStor service from plist file.
    ///
    /// The plist data structure is as follows:
    ///
    /// ```
    /// Root:
    ///   access_key_id: your access key
    ///   secret_access_key: your secret access key
    ///   protocol: https
    ///   host: qingstor.com
    ///   port: 433
    /// ```
    ///
    /// The `access_key_id` and `secret_access_key` are required.
    ///
    /// - throws: An `APIError.registerError` if reading plist data encounters an error.
    ///
    /// - parameter plist: The plist file url.
    @objc public static func registerFrom(plist: URL) throws {
        guard let config = NSDictionary(contentsOf: plist) as? Dictionary<String, String> else {
            throw APIError.registerError(info: "plist not found")
        }

        guard let accessKeyID = config["access_key_id"] else {
            throw APIError.registerError(info: "access_key_id not defined")
        }

        guard let secretAccessKey = config["secret_access_key"] else {
            throw APIError.registerError(info: "secret_access_key not defined")
        }

        if let `protocol` = config["protocol"], let host = config["host"] {
            var baseURL = "\(`protocol`)://\(host)"
            if let port = config["port"] {
                baseURL += ":\(port)/"
            } else {
                baseURL += "/"
            }
            register(baseURL: baseURL, accessKeyID: accessKeyID, secretAccessKey: secretAccessKey)
        } else {
            register(accessKeyID: accessKeyID, secretAccessKey: secretAccessKey)
        }
    }
}

/// QingStor API protocol
public protocol BaseAPI {
    var context: APIContext { get set }
}

/// `APIError` is the error type returned by QingStorSDK. It encompasses a few different types of errors,
/// each with their own associated reasons.
public enum APIError: Error {
    /// Returned when use a wrong plist content to register QingStor server.
    case registerError(info: String)

    /// Returned when use a wrong plist content to initialize APIContext.
    case contextError(info: String)

    /// Returned when RequestBuilder throws an error during the building request.
    case buildingRequestError(info: String)

    /// Returned when a parameter encoding object throws an error during the encoding process.
    case encodingError(info: String)

    /// Returned when a signer throws an error during the signature process.
    case signatureError(info: String)

    /// Returned when missing input required parameter.
    case parameterRequiredError(name: String, parentName: String)

    /// Returned when a input parameter value not allowed.
    case parameterValueNotAllowedError(name: String, value: String?, allowedValues: [String])
}

extension APIError: LocalizedError {
    public var errorDescription: String? {
        switch self {
        case let .registerError(info):
            return "register error: \(info)"
        case let .contextError(info):
            return "initialize APIContext error: \(info)"
        case let .buildingRequestError(info):
            return "building request error: \(info)"
        case let .encodingError(info):
            return "encoding parameters error: \(info)"
        case let .signatureError(info):
            return "signature error: \(info)"
        case let .parameterRequiredError(name, parentName):
            return "\(parentName) parameter \(name) is required."
        case let .parameterValueNotAllowedError(name, value, allowedValues):
            return "Invalid input parameter \(name) = \(value ?? ""), allowed values: \(allowedValues)"
        }
    }
}

/// Provides `QingStor` server base url and access key for the api request and signature
@objc(QSAPIContext)
public class APIContext: NSObject {
    /// The api request url.
    @objc public var url: URL {
        return urlComponents.url!
    }

    /// The api request protocol.
    @objc public var `protocol`: String? {
        get {
            return urlComponents.scheme
        }
        set {
            urlComponents.scheme = newValue
        }
    }

    /// The api request host.
    @objc public var host: String? {
        get {
            return urlComponents.host
        }
        set {
            urlComponents.host = newValue
        }
    }

    /// The api request port.
    public var port: Int? {
        get {
            return urlComponents.port
        }
        set {
            urlComponents.port = newValue
        }
    }

    /// The api request uri.
    @objc public var uri: String {
        get {
            return urlComponents.path
        }
        set {
            urlComponents.path = newValue
        }
    }

    /// The api request query.
    @objc public var query: String? {
        get {
            return urlComponents.query
        }
        set {
            urlComponents.query = newValue
        }
    }

    /// The `QingCloud` API access key.
    @objc public private(set) var accessKeyID: String

    /// The `QingCloud` API secret access key.
    @objc public private(set) var secretAccessKey: String

    /// The `QingStor` server base url.
    @objc public let baseURL: String

    /// The api request url components.
    @objc public var urlComponents: URLComponents

    /// Initialize `APIContext` with the specified `baseURL`, `accessKeyID` and `secretAccessKey`.
    ///
    /// - parameter baseURL:          The QingStor server base url.
    /// - parameter accessKeyID:      The QingCloud API access key.
    /// - parameter secretAccessKey:  The QingCloud API secret access key.
    ///
    /// - returns: The new `APIContext` instance.
    @objc public init(baseURL: String,
                      accessKeyID: String,
                      secretAccessKey: String) {
        self.baseURL = baseURL
        self.urlComponents = URLComponents(string: baseURL)!
        self.accessKeyID = accessKeyID
        self.secretAccessKey = secretAccessKey

        super.init()
    }

    /// Initialize `APIContext` with the specified `baseURL`, and will using `Registry` AccessKey data.
    ///
    /// - parameter baseURL: The `QingStor` server base url.
    ///
    /// - returns: The new `APIContext` instance.
    @objc public convenience init(baseURL: String) {
        guard let accessKeyID = Registry.accessKeyID else {
            fatalError("The access key should not be null")
        }

        guard let secretAccessKey = Registry.secretAccessKey else {
            fatalError("The secret access key should not be null")
        }

        self.init(baseURL: baseURL, accessKeyID: accessKeyID, secretAccessKey: secretAccessKey)
    }

    /// Initialize APIContext, will using `Registry` baseURL and AccessKey data.
    ///
    /// - returns: The new `APIContext` instance.
    @objc public convenience override init() {
        guard let baseURL = Registry.baseURL else {
            fatalError("The base url should not be null")
        }

        self.init(baseURL: baseURL)
    }

    /// Initialize `APIContext` from plist file.
    ///
    /// The plist data structure is as follows:
    ///
    /// ```
    /// Root:
    ///   access_key_id: your access key
    ///   secret_access_key: your secret access key
    ///   protocol: https
    ///   host: qingstor.com
    ///   port: 433
    /// ```
    ///
    /// - parameter plist: The plist file url.
    ///
    /// - throws: An `APIError.contextError` if reading plist data encounters an error.
    ///
    /// - returns: The new `APIContext` instance.
    @objc public init(plist: URL) throws {
        guard let config = NSDictionary(contentsOf: plist) as? Dictionary<String, String> else {
            throw APIError.contextError(info: "plist not found")
        }

        guard let accessKeyID = config["access_key_id"] ?? Registry.accessKeyID else {
            throw APIError.contextError(info: "access_key_id not defined")
        }

        guard let secretAccessKey = config["secret_access_key"] ?? Registry.secretAccessKey else {
            throw APIError.contextError(info: "secret_access_key not defined")
        }

        self.accessKeyID = accessKeyID
        self.secretAccessKey = secretAccessKey

        guard let `protocol` = config["protocol"] else {
            throw APIError.contextError(info: "protocol not defined")
        }

        guard let host = config["host"] else {
            throw APIError.contextError(info: "host not defined")
        }

        var baseURL = "\(`protocol`)://\(host)"

        if let port = config["port"] {
            baseURL += ":\(port)/"
        } else {
            baseURL += "/"
        }

        self.baseURL = baseURL
        self.urlComponents = URLComponents(string: baseURL)!
    }

    /// Update `APIContext` baseURL from dictionary.
    ///
    /// The dictionary data structure is as follows:
    ///
    /// ```
    /// Root:
    ///   protocol: https
    ///   host: qingstor.com
    ///   port: 433
    /// ```
    ///
    /// - parameter config: The config dictionary.
    @objc public func readFrom(config: [String:String]) {
        if let `protocol` = config["protocol"] {
            self.`protocol` = `protocol`
        }

        if let host = config["host"] {
            self.host = host
        }

        if let port = config["port"] {
            self.port = Int(port)
        } else {
            self.port = nil
        }
    }

    func rawCopy() -> APIContext {
        return APIContext(baseURL: self.baseURL, accessKeyID: self.accessKeyID, secretAccessKey: self.secretAccessKey)
    }
}

/// The `APIInput`, `APIOutput` and models base class.
@objc(QSBaseModel)
public class BaseModel: NSObject, Mappable {
    /// Initialize function, default is do nothing, should implement it in child class.
    @objc public override init() {}

    /// Initialize function, implement `Mappable` protocol, default is do nothing, should implement it in child class.
    public required init?(map: Map) { }

    /// Implement `Mappable` protocol, default is do nothing, should implement it in child class.
    public func mapping(map: Map) { }

    /// Convert model data to dictionary, default is to json data.
    @objc public func toParameters() -> [String:Any] { return toJSON() }

    /// Verify model data is valid, should implement it in child class.
    @objc public func validate() -> Error? { return nil }
}

/// The base class of api request input data.
@objc(QSAPIInput)
public class APIInput: BaseModel {
    /// The request header properties.
    @objc var headerProperties: [String] {
        return []
    }

    /// The request query properties.
    @objc var queryProperties: [String] {
        return []
    }

    /// The request body properties.
    @objc var bodyProperties: [String] {
        return []
    }
}

/// The base class of api response output data.
@objc(QSAPIOutput)
public class APIOutput: BaseModel {

}

/// The download file api request input data protocol.
public protocol APIDownloadInput {
    /// The url where the file should be saved.
    var destinationURL: URL? { get set }
}

/// The download file api response output data protocol.
public protocol APIDownloadOutput {
    /// The url where the file is saved.
    var destinationURL: URL? { get set }
}

/// Handle api request data and send to QingStor server.
@objc(QSAPISender)
public class APISender: NSObject {
    /// The api context.
    @objc public let context: APIContext

    /// The api request parameters.
    @objc public var parameters: [String:Any]

    /// The HTTP method.
    public var method: HTTPMethod

    /// The signer.
    public var signer: Signer

    /// The HTTP headers.
    @objc public var headers: [String:String]

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

    /// The request builder factory.
    public var requestBuilderFactory: RequestBuilderFactory = DefaultRequestBuilderFactory()

    /// Returned the request builder instance.
    @objc public var requestBuilder: RequestBuilder {
        let builder: RequestBuilder.Type = self.requestBuilderFactory.getBuilder()
        return builder.init(context: self.context,
                            method: self.method,
                            parameters: self.parameters,
                            signer: self.signer,
                            headers: self.headers,
                            credential: self.credential,
                            encoding: self.encoding,
                            isDownload: self.isDownload,
                            downloadDestination: self.downloadDestination,
                            acceptableStatusCodes: self.acceptableStatusCodes,
                            writeHeadersToOutput: self.writeHeadersToOutput,
                            buildingQueue: self.buildingQueue,
                            callbackQueue: self.callbackQueue)
    }

    /// Initialize `APISender` with specified parameters.
    ///
    /// - parameter context:                The api context.
    /// - parameter parameters:             The api request parameters.
    /// - parameter method:                 The HTTP method.
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
    public init(context: APIContext,
                parameters: [String:Any],
                method: HTTPMethod = .get,
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
        self.parameters = parameters
        self.method = method
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
    }

    /// Initialize `APISender` with specified parameters, and process input data to request parameters.
    ///
    /// - parameter context:                The api context.
    /// - parameter input:                  The api request input.
    /// - parameter method:                 The HTTP method.
    /// - parameter signer:                 The signer.
    /// - parameter headers:                The HTTP headers.
    /// - parameter credential:             The url credential.
    /// - parameter acceptableStatusCodes:  The acceptable status codes.
    /// - parameter buildingQueue:          The building queue.
    /// - parameter callbackQueue:          The callback queue.
    ///
    /// - returns: The new `APISender` instance.
    public convenience init(context: APIContext,
                            input: APIInput? = nil,
                            method: HTTPMethod = .get,
                            signer: Signer,
                            headers: [String:String] = [:],
                            credential: URLCredential? = nil,
                            acceptableStatusCodes: [Int]? = nil,
                            buildingQueue: DispatchQueue = DispatchQueue.global(),
                            callbackQueue: DispatchQueue = DispatchQueue.main) {
        var parameters: [String:Any] = [:]
        var encoding = ParameterEncodingType.query
        var realHeaders = headers
        var isDownload = false
        var downloadDestination: URL? = nil

        if let input = input {
            parameters = input.toParameters()

            // Handle header properties
            if input.headerProperties.count > 0 {
                for key in input.headerProperties {
                    if let value = parameters[key], (value as? Int) != defaultIgnoreIntValue {
                        realHeaders[key] = "\(value)"
                    }

                    parameters.removeValue(forKey: key)
                }
            }

            // Handle body properties, encoding
            if input.bodyProperties.count > 0 {
                if (parameters.filter { $1 is InputStream }.count) > 0 {
                    encoding = .binary
                } else if (input.bodyProperties.filter { $0 != "body"}.count) > 0 {
                    encoding = .json
                }
            }

            // Handle query properties
            if input.queryProperties.count > 0 {
                var queryParameters: [String:Any] = [:]
                for key in input.queryProperties {
                    if let value = parameters[key], (value as? Int) != defaultIgnoreIntValue {
                        queryParameters[key] = value
                    }

                    parameters.removeValue(forKey: key)
                }

                let queryString = APIHelper.buildQueryString(parameters: &queryParameters)
                let percentEncodedQuery = (context.urlComponents.percentEncodedQuery.map { $0 + "&" } ?? "") + queryString
                context.urlComponents.percentEncodedQuery = percentEncodedQuery
            }

            if let downloadInput = input as? APIDownloadInput {
                isDownload = true
                if let destination = downloadInput.destinationURL {
                    downloadDestination = destination
                }
            }
        }

        self.init(context: context,
                  parameters: parameters,
                  method: method,
                  signer: signer,
                  headers: realHeaders,
                  credential: credential,
                  encoding: encoding,
                  isDownload: isDownload,
                  downloadDestination: downloadDestination,
                  acceptableStatusCodes: acceptableStatusCodes,
                  writeHeadersToOutput: true,
                  buildingQueue: buildingQueue,
                  callbackQueue: callbackQueue)
    }

    /// Add HTTP headers.
    ///
    /// - parameter headers: The HTTP headers.
    @objc public func addHeaders(_ headers: [String:String]) {
        for (key, value) in headers {
            self.headers[key] = value
        }
    }

    /// Build api request.
    ///
    /// - parameter completion: Build completion callback.
    @objc public func buildRequest(completion: @escaping BuildCompletion) {
        requestBuilder.buildRequest(completion: completion)
    }

    /// Send api request.
    ///
    /// - parameter progress: API request progress callback.
    /// - parameter completion: API request completion callback.
    public func sendAPI<T>(progress: RequestProgress? = nil, completion: @escaping RequestCompletion<T>) {
        requestBuilder.send(progress: progress, completion: completion)
    }
}
