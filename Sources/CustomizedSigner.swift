//
//  CustomizedSigner.swift
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

@objc(QSCustomizedSigner)
final public class CustomizedSigner: NSObject, Signer {
    public typealias SignatureHandlerCompletion = (SignatureResult) -> Void
    public typealias SignatureHandler = (CustomizedSigner, String, RequestBuilder, @escaping SignatureHandlerCompletion) throws -> Void

    public var signatureType: QingStorSignatureType
    public var handler: SignatureHandler

    public init(signatureType: QingStorSignatureType = .header, handler: @escaping SignatureHandler) {
        self.signatureType = signatureType
        self.handler = handler
    }

    public func querySignatureString(from requestBuilder: RequestBuilder, timeoutSeconds: Int) throws -> SignatureResult {
        let semaphoreSignal = DispatchSemaphore(value: 0)
        let plainString = querySignaturePlainString(from: requestBuilder, timeoutSeconds: timeoutSeconds)

        var result: SignatureResult!
        try handler(self, plainString, requestBuilder) {
            result = $0
            semaphoreSignal.signal()
        }

        semaphoreSignal.wait()
        return result
    }

    public func headerSignatureString(from requestBuilder: RequestBuilder) throws -> SignatureResult {
        let semaphoreSignal = DispatchSemaphore(value: 0)
        let plainString = headerSignaturePlainString(from: requestBuilder)

        var result: SignatureResult!
        try handler(self, plainString, requestBuilder) {
            result = $0
            semaphoreSignal.signal()
        }

        semaphoreSignal.wait()
        return result
    }

    public func rawCopy() -> CustomizedSigner {
        return CustomizedSigner(signatureType: signatureType, handler: handler)
    }
}
