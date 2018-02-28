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

@objc(QSQingStorSigner)
final public class QingStorSigner: NSObject, Signer {
    public var signatureType: QingStorSignatureType

    public init(signatureType: QingStorSignatureType = .header) {
        self.signatureType = signatureType
    }

    public func querySignatureString(from requestBuilder: RequestBuilder, timeoutSeconds: Int) throws -> SignatureResult {
        let expires = self.expires(from: requestBuilder, timeoutSeconds: timeoutSeconds)
        let plainString = querySignaturePlainString(from: requestBuilder, timeoutSeconds: timeoutSeconds)
        let signatureString = try plainString.hmacSHA256Data(key: requestBuilder.context.secretAccessKey).base64EncodedString()
        return .query(signature: signatureString, accessKey: requestBuilder.context.accessKeyID, expires: expires)
    }

    public func headerSignatureString(from requestBuilder: RequestBuilder) throws -> SignatureResult {
        let plainString = headerSignaturePlainString(from: requestBuilder)
        let signatureString = try plainString.hmacSHA256Data(key: requestBuilder.context.secretAccessKey).base64EncodedString()
        return .header(signature: signatureString, accessKey: requestBuilder.context.accessKeyID)
    }

    public func rawCopy() -> QingStorSigner {
        return QingStorSigner(signatureType: signatureType)
    }
}
