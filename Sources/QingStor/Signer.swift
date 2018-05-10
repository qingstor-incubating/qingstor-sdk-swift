//
//  Signer.swift
//
// +-------------------------------------------------------------------------
// | Copyright (C) 2018 Yunify, Inc.
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

/// The api signer protocol.
public protocol Signer: class {
    /// The signature type.
    var signatureType: QingStorSignatureType { get set }

    /// Calculate signature string from request builder.
    ///
    /// - parameter requestBuilder: The request builder.
    ///
    /// - throws: An `APIError.signatureError` if Calculate signature encounters an error.
    ///
    /// - returns: Signature string.
    func signatureString(from requestBuilder: RequestBuilder) throws -> String

    /// Wtite signature string to request builder.
    ///
    /// - parameter requestBuilder: The request builder.
    ///
    /// - throws: An `APIError.signatureError` if write signature encounters an error.
    func writeSignature(to requestBuilder: RequestBuilder) throws

    /// Calculate header signature string from request builder.
    ///
    /// - parameter requestBuilder: The request builder.
    ///
    /// - throws: An `APIError.signatureError` if calculate header signature encounters an error.
    ///
    /// - returns: Signature result.
    func headerSignatureString(from requestBuilder: RequestBuilder) throws -> SignatureResult

    /// Calculate query signature string from request builder.
    ///
    /// - parameter requestBuilder: The request builder.
    /// - parameter timeoutSeconds: The timeout of the generated URL.
    ///
    /// - throws: An `APIError.signatureError` if calculate query signature encounters an error.
    ///
    /// - returns: Signature result.
    func querySignatureString(from requestBuilder: RequestBuilder, timeoutSeconds: Int) throws -> SignatureResult

    /// Using raw data to copy singer.
    ///
    /// - returns: New signer instance.
    func rawCopy() -> Self
}

/// QingStor signature type.
public enum QingStorSignatureType {
    /// The query signature type, will write the signature to url query.
    ///
    /// - parameter timeoutSeconds: The timeout of the generated URL.
    case query(timeoutSeconds: Int)

    /// The header signature type, will write the signature to http header.
    case header
}

/// Signature result.
public enum SignatureResult {
    /// Using query signature type to process data, and will write the signature to url query.
    ///
    /// - parameter signature: The signature string.
    /// - parameter accessKey: The QingCloud api access key.
    /// - parameter expires:   The expiry time.
    case query(signature: String, accessKey: String, expires: Int?)

    /// Using header signature type to process data, and will write the signature to http header.
    ///
    /// - parameter signature: The signature string.
    /// - parameter accessKey: The QingCloud api access key.
    case header(signature: String, accessKey: String)

    /// Using customized signer to process data, and will write the signature to http header.
    case authorization(String)

    var signature: String {
        switch self {
        case let .query(signature, _, _):
            return signature
        case let .header(signature, _):
            return signature
        case let .authorization(authorization):
            return authorization
        }
    }
}

public extension Signer {
    public func signatureString(from requestBuilder: RequestBuilder) throws -> String {
        switch signatureType {
        case .query(let timeoutSeconds):
            return try querySignatureString(from: requestBuilder, timeoutSeconds: timeoutSeconds).signature
        case .header:
            return try headerSignatureString(from: requestBuilder).signature
        }
    }

    public func writeSignature(to requestBuilder: RequestBuilder) throws {
        switch signatureType {
        case .query(let timeoutSeconds):
            try writeQuerySignature(to: requestBuilder, timeoutSeconds: timeoutSeconds)
        case .header:
            try writeHeaderSignature(to: requestBuilder)
        }
    }

    /// Wtite query signature string to request builder.
    ///
    /// - parameter requestBuilder: The request builder.
    /// - parameter timeoutSeconds: The timeout of the generated URL.
    ///
    /// - throws: An `APIError.signatureError` if write signature encounters an error.
    public func writeQuerySignature(to requestBuilder: RequestBuilder, timeoutSeconds: Int) throws {
        let result = try querySignatureString(from: requestBuilder, timeoutSeconds: timeoutSeconds)
        switch result {
        case let .query(signature, accessKey, expires):
            let actualExpires = expires ?? self.expires(from: requestBuilder, timeoutSeconds: timeoutSeconds)
            let query: [String] =
                ["access_key_id=\(accessKey)", "expires=\(actualExpires)", "signature=\(signature.escape())"]
            let percentEncodedQuery =
                (requestBuilder.context.urlComponents.percentEncodedQuery.map { $0 + "&" } ?? "") + query.joined(separator: "&")
            requestBuilder.context.urlComponents.percentEncodedQuery = percentEncodedQuery
        default:
            throw APIError.signatureError(info: "The signature result expected to be .query, but it's actually \(result)")
        }
    }

    /// Wtite header signature string to request builder.
    ///
    /// - parameter requestBuilder: The request builder.
    ///
    /// - throws: An `APIError.signatureError` if write signature encounters an error.
    public func writeHeaderSignature(to requestBuilder: RequestBuilder) throws {
        let result = try headerSignatureString(from: requestBuilder)
        switch result {
        case let .header(signature, accessKey):
            requestBuilder.headers["Authorization"] = "QS \(accessKey):\(signature)"
        case let .authorization(authorization):
            requestBuilder.headers["Authorization"] = authorization
        default:
            throw APIError.signatureError(info: "The signature result expected to be .header or .authorization, but it's actually \(result)")
        }
    }
}

public extension Signer {
    /// Calculate expiry time.
    ///
    /// - parameter requestBuilder: The request builder.
    /// - parameter timeoutSeconds: The timeout of the generated URL.
    ///
    /// - returns: expiry time.
    public func expires(from requestBuilder: RequestBuilder, timeoutSeconds: Int) -> Int {
        let date = ((requestBuilder.headers["Date"] ?? String.RFC822()).toRFC822Date())!
        return Int(date.timeIntervalSince1970) + timeoutSeconds
    }

    /// Calculate query signature plain string from request builder.
    ///
    /// - parameter requestBuilder: The request builder.
    /// - parameter timeoutSeconds: The timeout of the generated URL.
    ///
    /// - returns: Query signature plain string.
    public func querySignaturePlainString(from requestBuilder: RequestBuilder, timeoutSeconds: Int) -> String {
        let expires = self.expires(from: requestBuilder, timeoutSeconds: timeoutSeconds)
        var plainString = "\(requestBuilder.method.rawValue)\n\n\n"
        plainString += "\(expires)\n"
        plainString += buildCanonicalizedResource(requestBuilder)

        return plainString
    }

    /// Calculate header signature plain string from request builder.
    ///
    /// - parameter requestBuilder: The request builder.
    ///
    /// - returns: Header signature plain string.
    public func headerSignaturePlainString(from requestBuilder: RequestBuilder) -> String {
        let headers = requestBuilder.headers
        var plainString = "\(requestBuilder.method.rawValue)\n"
        plainString += "\(headers["Content-MD5"] ?? "")\n"
        plainString += "\(headers["Content-Type"] ?? "")\n"
        plainString += "\(headers["Date"] ?? String.RFC822())\n"
        plainString += buildCanonicalizedHeaders(requestBuilder)
        plainString += buildCanonicalizedResource(requestBuilder)

        return plainString
    }

    /// Build canonicalized headers string to signing from request builder.
    ///
    /// - parameter requestBuilder: The request builder.
    ///
    /// - returns: Canonicalized headers signing string.
    public func buildCanonicalizedHeaders(_ requestBuilder: RequestBuilder) -> String {
        var canonicalizedHeaders = ""
        for key in requestBuilder.headers.keys.sorted(by: <) {
            let encodeValue = requestBuilder.headers[key]?.escapeNonASCIIOnly()
            requestBuilder.headers[key] = encodeValue

            let lowercasedKey = key.lowercased()
            if lowercasedKey.hasPrefix("x-qs-") {
                canonicalizedHeaders += "\(lowercasedKey):\(encodeValue!.trimmingCharacters(in: CharacterSet.whitespaces))\n"
            }
        }
        return canonicalizedHeaders
    }

    /// Build canonicalized resource string to signing from request builder.
    ///
    /// - parameter requestBuilder: The request builder.
    ///
    /// - returns: Canonicalized resource signing string.
    public func buildCanonicalizedResource(_ requestBuilder: RequestBuilder) -> String {
        let parametersToSign = ["acl",
                                "cors",
                                "delete",
                                "mirror",
                                "part_number",
                                "policy",
                                "stats",
                                "upload_id",
                                "uploads",
                                "logging",
                                "notification",
                                "image",
                                "response-expires",
                                "response-cache-control",
                                "response-content-type",
                                "response-content-language",
                                "response-content-encoding",
                                "response-content-disposition"]

        let urlString = requestBuilder.context.url.absoluteString

        var query = ""
        if let index = urlString.range(of: "?", options: .backwards)?.lowerBound {
            query = String(urlString[urlString.index(after: index)...])
        }

        if requestBuilder.encoding == .query {
            let parametersQuery = APIHelper.buildQueryString(parameters: &requestBuilder.parameters, escaped: false)
            if !parametersQuery.isEmpty {
                if !query.isEmpty {
                    query += "&"
                }
                query += parametersQuery
            }
        }

        query = query.components(separatedBy: "&")
            .filter { parametersToSign.contains($0.components(separatedBy: "=")[0]) }
            .joined(separator: "&")
            .unescape()

        let uri = requestBuilder.context.uri.urlPathEscape()
        if !query.isEmpty {
            return "\(uri)?\(query)"
        }

        return uri
    }
}

public extension SignatureResult {
    /// Is it a query signature result.
    public var isQuery: Bool {
        if case .query = self {
            return true
        } else {
            return false
        }
    }

    /// Is it a header signature result.
    public var isHeader: Bool {
        if case .header = self {
            return true
        } else {
            return false
        }
    }

    /// Is it an authorization signature result.
    public var isAuthorization: Bool {
        if case .authorization = self {
            return true
        } else {
            return false
        }
    }
}
