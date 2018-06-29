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

/// The QingStor signer.
@objc(QSQingStorSigner)
final public class QingStorSigner: NSObject, Signer {
    /// The signature type.
    public var signatureType: QingStorSignatureType

    /// Initialize `QingStorSigner` with the specified `signatureType`
    ///
    /// - parameter signatureType: The signature type.
    ///
    /// - returns: The new `QingStorSigner` instance.
    public init(signatureType: QingStorSignatureType = .header) {
        self.signatureType = signatureType
    }

    /// Calculate query signature string from request builder.
    ///
    /// - parameter requestBuilder: The request builder.
    /// - parameter timeoutSeconds: The timeout of the generated URL.
    ///
    /// - throws: An `APIError.signatureError` if calculate query signature encounters an error.
    ///
    /// - returns: Signature result.
    public func querySignatureString(from requestBuilder: RequestBuilder, timeoutSeconds: Int) throws -> SignatureResult {
        guard let accessKey = requestBuilder.context.accessKeyID else {
            throw APIError.signatureError(info: "The access key should not be null")
        }
        
        guard let secretAccessKey = requestBuilder.context.secretAccessKey else {
            throw APIError.signatureError(info: "The secret access key should not be null")
        }
        
        let expires = self.expires(from: requestBuilder, timeoutSeconds: timeoutSeconds)
        let plainString = querySignaturePlainString(from: requestBuilder, timeoutSeconds: timeoutSeconds)
        let signatureString = try plainString.hmacSHA256Data(key: secretAccessKey).base64EncodedString()
        return .query(signature: signatureString, accessKey: accessKey, expires: expires)
    }

    /// Calculate header signature string from request builder.
    ///
    /// - parameter requestBuilder: The request builder.
    ///
    /// - throws: An `APIError.signatureError` if calculate header signature encounters an error.
    ///
    /// - returns: Signature result.
    public func headerSignatureString(from requestBuilder: RequestBuilder) throws -> SignatureResult {
        guard let accessKey = requestBuilder.context.accessKeyID else {
            throw APIError.signatureError(info: "The access key should not be null")
        }
        
        guard let secretAccessKey = requestBuilder.context.secretAccessKey else {
            throw APIError.signatureError(info: "The secret access key should not be null")
        }
        
        let plainString = headerSignaturePlainString(from: requestBuilder)
        let signatureString = try plainString.hmacSHA256Data(key: secretAccessKey).base64EncodedString()
        return .header(signature: signatureString, accessKey: accessKey)
    }

    /// Using raw data to copy singer.
    ///
    /// - returns: New signer instance.
    public func rawCopy() -> QingStorSigner {
        return QingStorSigner(signatureType: signatureType)
    }
}
