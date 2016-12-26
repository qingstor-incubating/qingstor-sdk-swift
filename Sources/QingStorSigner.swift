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

    public func writeSignature(to requestBuild: RequestBuilder) throws {
        switch signatureType {
        case .query(let timeoutSeconds):
            try writeQuerySignature(to: requestBuild, timeoutSeconds: timeoutSeconds)
        case .header:
            try writeHeaderSignature(to: requestBuild)
        }
    }

    func writeQuerySignature(to requestBuild: RequestBuilder, timeoutSeconds: Int) throws {
        let headers = requestBuild.headers
        let date = ((headers["Date"] ?? String.RFC822()).toRFC822Date())!
        let expires = Int(date.timeIntervalSince1970) + timeoutSeconds

        var signatureString = "\(requestBuild.method.rawValue)\n"
        signatureString += "\(headers["Content-MD5"] ?? "")\n"
        signatureString += "\(headers["Content-Type"] ?? "")\n"
        signatureString += "\(expires)\n"
        signatureString += buildCanonicalizedHeaders(requestBuild)
        signatureString += buildCanonicalizedResource(requestBuild)
        signatureString = try signatureString.hmacSHA256Data(key: requestBuild.context.secretAccessKey).base64EncodedString()

        let query: [String] = ["access_key_id=\(requestBuild.context.accessKeyID)", "expires=\(expires)", "signature=\(signatureString.escape())"]
        let percentEncodedQuery = (requestBuild.context.urlComponents.percentEncodedQuery.map { $0 + "&" } ?? "") + query.joined(separator: "&")
        requestBuild.context.urlComponents.percentEncodedQuery = percentEncodedQuery
    }

    func writeHeaderSignature(to requestBuild: RequestBuilder) throws {
        let headers = requestBuild.headers
        var signatureString = "\(requestBuild.method.rawValue)\n"
        signatureString += "\(headers["Content-MD5"] ?? "")\n"
        signatureString += "\(headers["Content-Type"] ?? "")\n"
        signatureString += "\(headers["Date"] ?? String.RFC822())\n"
        signatureString += buildCanonicalizedHeaders(requestBuild)
        signatureString += buildCanonicalizedResource(requestBuild)
        signatureString = try signatureString.hmacSHA256Data(key: requestBuild.context.secretAccessKey).base64EncodedString()

        requestBuild.headers["Authorization"] = "QS \(requestBuild.context.accessKeyID):\(signatureString)"
    }

    func buildCanonicalizedHeaders(_ requestBuild: RequestBuilder) -> String {
        let headers = requestBuild.headers
        var canonicalizedHeaders = ""
        for key in headers.keys.sorted(by: <) {
            let lowercasedKey = key.lowercased()
            if lowercasedKey.hasPrefix("x-qs-") {
                canonicalizedHeaders += "\(lowercasedKey):\(headers[key]!.trimmingCharacters(in: CharacterSet.whitespaces))\n"
            }
        }
        return canonicalizedHeaders
    }

    func buildCanonicalizedResource(_ requestBuild: RequestBuilder) -> String {
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

        let urlString = requestBuild.context.url.absoluteString

        var query = ""
        if let index = urlString.range(of: "?", options: .backwards)?.lowerBound {
            query = urlString.substring(from: urlString.index(after: index))
        }

        if requestBuild.encoding == .query {
            let parametersQuery = APIHelper.buildQueryString(parameters: &requestBuild.parameters, escaped: false)

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

        let uri = requestBuild.context.uri
        if !query.isEmpty {
            return "\(uri)?\(query)"
        }

        return uri
    }
}
