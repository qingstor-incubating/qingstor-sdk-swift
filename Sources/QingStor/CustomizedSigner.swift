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

/// The customized signer.
@objc(QSCustomizedSigner)
final public class CustomizedSigner: NSObject, Signer {
    /// Handle signature completion callback
    public typealias SignatureHandlerCompletion = (SignatureResult) -> Void

    /// A closure used to Calculate signature string.
    public typealias SignatureHandler = (CustomizedSigner, String, RequestBuilder, @escaping SignatureHandlerCompletion) throws -> Void

    /// The signature type.
    public var signatureType: QingStorSignatureType

    /// The signature handler
    public var handler: SignatureHandler

    /// Initialize `CustomizedSigner` with the specified `signatureType` and `handler`
    ///
    /// - parameter signatureType: The signature type.
    /// - parameter handler:       The signature handler.
    ///
    /// - returns: The new `CustomizedSigner` instance.
    public init(signatureType: QingStorSignatureType = .header, handler: @escaping SignatureHandler) {
        self.signatureType = signatureType
        self.handler = handler
    }

    /// Calculate query signature string from request builder, will execute signature handler to Calculate signature result.
    ///
    /// - parameter requestBuilder: The request builder.
    /// - parameter timeoutSeconds: The timeout of the generated URL.
    ///
    /// - throws: An `APIError.signatureError` if calculate query signature encounters an error.
    ///
    /// - returns: Signature result.
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

    /// Calculate header signature string from request builder, will execute signature handler to Calculate signature result.
    ///
    /// - parameter requestBuilder: The request builder.
    ///
    /// - throws: An `APIError.signatureError` if calculate header signature encounters an error.
    ///
    /// - returns: Signature result.
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

    /// Using raw data to copy singer.
    ///
    /// - returns: New signer instance.
    public func rawCopy() -> CustomizedSigner {
        return CustomizedSigner(signatureType: signatureType, handler: handler)
    }
}
