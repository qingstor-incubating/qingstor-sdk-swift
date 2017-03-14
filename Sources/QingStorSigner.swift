//
//  QingStorSigner.swift
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

public enum QingStorSignatureType: Error {
    case query(timeoutSeconds: Int)
    case header
}

public class QingStorSigner: Signer {
    public var signatureType: QingStorSignatureType = .header

    public func signatureString(from requestBuilder: RequestBuilder) throws -> String {
        switch signatureType {
        case .query(let timeoutSeconds):
            let (signatureString, _) = try querySignatureString(from: requestBuilder, timeoutSeconds: timeoutSeconds)
            return signatureString
        case .header:
            return try headerSignatureString(from: requestBuilder)
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

    func querySignatureString(from requestBuilder: RequestBuilder, timeoutSeconds: Int) throws -> (String, Int) {
        let headers = requestBuilder.headers
        let date = ((headers["Date"] ?? String.RFC822()).toRFC822Date())!
        let expires = Int(date.timeIntervalSince1970) + timeoutSeconds

        var signatureString = "\(requestBuilder.method.rawValue)\n\n\n"
        signatureString += "\(expires)\n"
        signatureString += buildCanonicalizedResource(requestBuilder)
        signatureString = try signatureString.hmacSHA256Data(key: requestBuilder.context.secretAccessKey).base64EncodedString()

        return (signatureString, expires)
    }

    func headerSignatureString(from requestBuilder: RequestBuilder) throws -> String {
        let headers = requestBuilder.headers
        var signatureString = "\(requestBuilder.method.rawValue)\n"
        signatureString += "\(headers["Content-MD5"] ?? "")\n"
        signatureString += "\(headers["Content-Type"] ?? "")\n"
        signatureString += "\(headers["Date"] ?? String.RFC822())\n"
        signatureString += buildCanonicalizedHeaders(requestBuilder)
        signatureString += buildCanonicalizedResource(requestBuilder)
        signatureString = try signatureString.hmacSHA256Data(key: requestBuilder.context.secretAccessKey).base64EncodedString()

        return signatureString
    }

    func writeQuerySignature(to requestBuilder: RequestBuilder, timeoutSeconds: Int) throws {
        let (signatureString, expires) = try querySignatureString(from: requestBuilder, timeoutSeconds: timeoutSeconds)
        let query: [String] = ["access_key_id=\(requestBuilder.context.accessKeyID)", "expires=\(expires)", "signature=\(signatureString.escape())"]
        let percentEncodedQuery = (requestBuilder.context.urlComponents.percentEncodedQuery.map { $0 + "&" } ?? "") + query.joined(separator: "&")
        requestBuilder.context.urlComponents.percentEncodedQuery = percentEncodedQuery
    }

    func writeHeaderSignature(to requestBuilder: RequestBuilder) throws {
        let signatureString = try headerSignatureString(from: requestBuilder)
        requestBuilder.headers["Authorization"] = "QS \(requestBuilder.context.accessKeyID):\(signatureString)"
    }

    func buildCanonicalizedHeaders(_ requestBuilder: RequestBuilder) -> String {
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

    func buildCanonicalizedResource(_ requestBuilder: RequestBuilder) -> String {
        let parametersToSign = ["acl",
                                "cors",
                                "delete",
                                "mirror",
                                "part_number",
                                "policy",
                                "stats",
                                "upload_id",
                                "uploads",
                                "response-expires",
                                "response-cache-control",
                                "response-content-type",
                                "response-content-language",
                                "response-content-encoding",
                                "response-content-disposition"]

        let urlString = requestBuilder.context.url.absoluteString

        var query = ""
        if let index = urlString.range(of: "?", options: .backwards)?.lowerBound {
            query = urlString.substring(from: urlString.index(after: index))
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
