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

public class Registry {
    public static var accessKeyID: String!
    public static var secretAccessKey: String!

    static var config: [String:String]!

    public static func register(accessKeyID: String, secretAccessKey: String) {
        self.accessKeyID = accessKeyID
        self.secretAccessKey = secretAccessKey
    }

    public static func registerFrom(plist: URL) throws {
        guard let config = NSDictionary(contentsOf: plist) as? Dictionary<String, String> else {
            throw APIError.registerError(info: "plist not found")
        }

        guard let accessKeyID = config["access_key_id"] else {
            throw APIError.registerError(info: "access_key_id not defined")
        }

        guard let secretAccessKey = config["secret_access_key"] else {
            throw APIError.registerError(info: "secret_access_key not defined")
        }

        register(accessKeyID: accessKeyID, secretAccessKey: secretAccessKey)
        self.config = config
    }
}

public protocol BaseAPI {
    var context: APIContext { get set }
}

public enum APIError: Error {
    case registerError(info: String)
    case contextError(info: String)
    case buildingRequestError(info: String)
    case encodingError(info: String)
    case signatureError(info: String)
    case parameterRequiredError(name: String, parentName: String)
    case parameterValueNotAllowedError(name: String, value: String?, allowedValues: [String])
}

public struct APIContext {
    public var url: URL {
        return urlComponents.url!
    }

    public var `protocol`: String? {
        get {
            return urlComponents.scheme
        }
        set {
            urlComponents.scheme = newValue
        }
    }

    public var host: String? {
        get {
            return urlComponents.host
        }
        set {
            urlComponents.host = newValue
        }
    }

    public var port: Int? {
        get {
            return urlComponents.port
        }
        set {
            urlComponents.port = newValue
        }
    }

    public var uri: String {
        get {
            return urlComponents.path
        }
        set {
            urlComponents.path = newValue
        }
    }

    public var query: String? {
        get {
            return urlComponents.query
        }
        set {
            urlComponents.query = newValue
        }
    }

    public private(set) var accessKeyID: String
    public private(set) var secretAccessKey: String

    public let urlString: String
    public var urlComponents: URLComponents

    public init(urlString: String,
                accessKeyID: String = Registry.accessKeyID,
                secretAccessKey: String = Registry.secretAccessKey) {
        self.urlString = urlString
        self.urlComponents = URLComponents(string: urlString)!
        self.accessKeyID = accessKeyID
        self.secretAccessKey = secretAccessKey

        if let config = Registry.config {
            self.readFrom(config: config)
        }
    }

    public init(plist: URL) throws {
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

        var urlString = "\(`protocol`)://\(host)"

        if let port = config["port"] {
            urlString += ":\(port)/"
        } else {
            urlString += "/"
        }

        self.urlString = urlString
        self.urlComponents = URLComponents(string: urlString)!
    }

    public mutating func readFrom(config: [String:String]) {
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
        return APIContext(urlString: self.urlString, accessKeyID: self.accessKeyID, secretAccessKey: self.secretAccessKey)
    }
}

public class BaseModel: Mappable {
    public init() {}
    public required init?(map: Map) { }

    public func mapping(map: Map) { }

    public func toParameters() -> [String:Any] { return toJSON() }
    public func validate() -> Error? { return nil }
}

public class APIInput: BaseModel {
    var headerProperties: [String] {
        return []
    }

    var queryProperties: [String] {
        return []
    }

    var bodyProperties: [String] {
        return []
    }
}

public class APIOutput: BaseModel {

}

public protocol APIDownloadInput {
    var destinationURL: URL? { get set }
}

public protocol APIDownloadOutput {
    var destinationURL: URL? { get set }
}

public class APISender {
    public let context: APIContext
    public var parameters: [String:Any]
    public var method: HTTPMethod
    public var signer: Signer
    public var headers: [String:String]
    public var credential: URLCredential?
    public var encoding: ParameterEncodingType
    public var isDownload: Bool
    public var downloadDestination: URL?
    public var acceptableStatusCodes: [Int]?
    public var writeHeadersToOutput: Bool
    public var buildingQueue: DispatchQueue
    public var callbackQueue: DispatchQueue
    public var requestBuilderFactory: RequestBuilderFactory = DefaultRequestBuilderFactory()

    public var requestBuilder: RequestBuilder {
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
        var realContext = context
        var realHeaders = headers
        var isDownload = false
        var downloadDestination: URL? = nil

        if let input = input {
            parameters = input.toParameters()

            // Handle header properties
            if input.headerProperties.count > 0 {
                for key in input.headerProperties {
                    if let value = parameters[key] {
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
                    if let value = parameters[key] {
                        queryParameters[key] = value
                    }

                    parameters.removeValue(forKey: key)
                }

                let queryString = APIHelper.buildQueryString(parameters: &queryParameters)
                let percentEncodedQuery = (realContext.urlComponents.percentEncodedQuery.map { $0 + "&" } ?? "") + queryString
                realContext.urlComponents.percentEncodedQuery = percentEncodedQuery
            }

            if let downloadInput = input as? APIDownloadInput {
                isDownload = true
                if let destination = downloadInput.destinationURL {
                    downloadDestination = destination
                }
            }
        }

        self.init(context: realContext,
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

    public func buildRequest(completion: @escaping BuildCompletion) {
        requestBuilder.buildRequest(completion: completion)
    }

    public func sendAPI<T>(completion: @escaping RequestCompletion<T>) {
        requestBuilder.send(completion: completion)
    }
}
