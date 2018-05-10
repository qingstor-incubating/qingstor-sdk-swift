//
// SignerObjcBridge.swift
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

/// The objc bridge of the `QingStorSignatureType`.
@objc(QSSignatureType)
public enum SignatureTypeObjcBridge: Int {
    case query = 0
    case header
}

/// The objc bridge of the signature type model, contains the variable in the enumeration.
@objc(QSSignatureTypeModel)
public class SignatureTypeModelObjcBridge: NSObject {
    /// The sinature type.
    @objc public let type: SignatureTypeObjcBridge

    /// The timeout of the generated URL.
    @objc public let timeoutSeconds: Int

    /// Initialize `SignatureTypeModelObjcBridge` with the specified `type` and `timeoutSeconds`.
    ///
    /// - parameter type:           The sinature type.
    /// - parameter timeoutSeconds: The timeout of the generated URL.
    ///
    /// - returns: The new `SignatureTypeModelObjcBridge` instance.
    @objc public init(type: SignatureTypeObjcBridge, timeoutSeconds: Int) {
        self.type = type
        self.timeoutSeconds = timeoutSeconds
    }

    /// Create `SignatureTypeModelObjcBridge` instance with query signature type and the specified `timeoutSeconds`.
    ///
    /// - parameter timeoutSeconds: The timeout of the generated URL.
    ///
    /// - returns: The new `SignatureTypeModelObjcBridge` instance.
    @objc public static func query(timeoutSeconds: Int) -> SignatureTypeModelObjcBridge {
        return SignatureTypeModelObjcBridge(type: .query, timeoutSeconds: timeoutSeconds)
    }

    /// Create `SignatureTypeModelObjcBridge` instance with header signature type.
    ///
    /// - returns: The new `SignatureTypeModelObjcBridge` instance.
    @objc public static func header() -> SignatureTypeModelObjcBridge {
        return SignatureTypeModelObjcBridge(type: .header, timeoutSeconds: 0)
    }
}

/// The objc bridge of the `SignatureResult`.
@objc(QSSignatureResultType)
public enum SignatureResultTypeObjcBridge: Int {
    case query = 0
    case header
    case authorization
}

/// The objc bridge of the signature result model, contains the variable in the enumeration.
@objc(QSSignatureResultModel)
public class SignatureResultModelObjcBridge: NSObject {
    /// The signature result type.
    @objc public let type: SignatureResultTypeObjcBridge

    /// The signature string.
    @objc public let signature: String

    /// The QingCloud API access key.
    @objc public let accessKey: String?

    /// The expiry time, is the int value.
    @objc public let expires: NSNumber?

    /// Initialize `SignatureResultModelObjcBridge` instance with the specified parameters.
    ///
    /// - parameter type:       The signature result type.
    /// - parameter signature:  The signature string.
    /// - parameter accessKey:  The QingCloud API access key.
    /// - parameter expires:    The expiry time, is the int value.
    ///
    /// - returns: The new `SignatureResultModelObjcBridge` instance.
    @objc public init(type: SignatureResultTypeObjcBridge, signature: String, accessKey: String?, expires: NSNumber?) {
        self.type = type
        self.signature = signature
        self.accessKey = accessKey
        self.expires = expires
    }

    /// Create `SignatureResultModelObjcBridge` instance with query signature type and the specified parameters.
    ///
    /// - parameter signature:  The signature string.
    /// - parameter accessKey:  The QingCloud API access key.
    /// - parameter expires:    The expiry time, is the int value.
    ///
    /// - returns: The new `SignatureResultModelObjcBridge` instance.
    @objc public static func query(signature: String, accessKey: String, expires: NSNumber?) -> SignatureResultModelObjcBridge {
        return SignatureResultModelObjcBridge(type: .query, signature: signature, accessKey: accessKey, expires: expires)
    }

    /// Create `SignatureResultModelObjcBridge` instance with header signature type and the specified parameters.
    ///
    /// - parameter signature:  The signature string.
    /// - parameter accessKey:  The QingCloud API access key.
    ///
    /// - returns: The new `SignatureResultModelObjcBridge` instance.
    @objc public static func header(signature: String, accessKey: String) -> SignatureResultModelObjcBridge {
        return SignatureResultModelObjcBridge(type: .header, signature: signature, accessKey: accessKey, expires: nil)
    }

    /// Create `SignatureResultModelObjcBridge` instance with header signature type and the specified `signature`.
    ///
    /// - parameter signature:  The signature string.
    ///
    /// - returns: The new `SignatureResultModelObjcBridge` instance.
    @objc public static func authorization(signature: String) -> SignatureResultModelObjcBridge {
        return SignatureResultModelObjcBridge(type: .authorization, signature: signature, accessKey: nil, expires: nil)
    }
}

extension QingStorSigner {
    /// The signature type model.
    @objc public var signatureTypeModel: SignatureTypeModelObjcBridge {
        get {
            switch signatureType {
            case let .query(timeoutSeconds):
                return SignatureTypeModelObjcBridge.query(timeoutSeconds: timeoutSeconds)
            case .header:
                return SignatureTypeModelObjcBridge.header()
            }
        }
        set {
            switch newValue.type {
            case .header:
                signatureType = .header
            case .query:
                signatureType = .query(timeoutSeconds: newValue.timeoutSeconds)
            }
        }
    }

    /// Initialize `QingStorSigner` instance with the specified `signatureType`.
    ///
    /// - parameter signatureType: The signature type model.
    ///
    /// - returns: The new `QingStorSigner` instance.
    @objc public convenience init(signatureType: SignatureTypeModelObjcBridge) {
        var actualSignatureType: QingStorSignatureType!
        switch signatureType.type {
        case .header:
            actualSignatureType = .header
        case .query:
            actualSignatureType = .query(timeoutSeconds: signatureType.timeoutSeconds)
        }

        self.init(signatureType: actualSignatureType)
    }

    /// Calculate query signature string from request builder.
    ///
    /// - parameter requestBuilder: The request builder.
    /// - parameter timeoutSeconds: The timeout of the generated URL.
    ///
    /// - returns: The signature result model.
    @objc public func querySignatureString(from requestBuilder: RequestBuilder, timeoutSeconds: Int) -> SignatureResultModelObjcBridge? {
        do {
            let result: SignatureResult = try querySignatureString(from: requestBuilder, timeoutSeconds: timeoutSeconds)

            switch result {
            case let .query(signature, accessKey, expires):
                return SignatureResultModelObjcBridge.query(signature: signature, accessKey: accessKey, expires: expires as NSNumber?)
            default:
                return nil
            }
        } catch {
            return nil
        }
    }

    /// Calculate header signature string from request builder.
    ///
    /// - parameter requestBuilder: The request builder.
    ///
    /// - returns: The signature result model.
    @objc public func headerSignatureString(from requestBuilder: RequestBuilder) -> SignatureResultModelObjcBridge? {
        do {
            let result: SignatureResult = try headerSignatureString(from: requestBuilder)

            switch result {
            case let .header(signature, accessKey):
                return SignatureResultModelObjcBridge.header(signature: signature, accessKey: accessKey)
            default:
                return nil
            }
        } catch {
            return nil
        }
    }
}

extension CustomizedSigner {
    /// The object bridge of the `SignatureHandlerCompletion`
    public typealias SignatureHandlerCompletionObjcBridge = (SignatureResultModelObjcBridge) -> Void

    /// The object bridge of the `SignatureHandler`
    public typealias SignatureHandlerObjcBridge = (CustomizedSigner, String, RequestBuilder, @escaping SignatureHandlerCompletionObjcBridge) -> Void

    /// The object bridge of the `QingStorSignatureType`
    @objc public var signatureTypeModel: SignatureTypeModelObjcBridge {
        get {
            switch signatureType {
            case let .query(timeoutSeconds):
                return SignatureTypeModelObjcBridge.query(timeoutSeconds: timeoutSeconds)
            case .header:
                return SignatureTypeModelObjcBridge.header()
            }
        }
        set {
            switch newValue.type {
            case .header:
                signatureType = .header
            case .query:
                signatureType = .query(timeoutSeconds: newValue.timeoutSeconds)
            }
        }
    }

    /// Initialize `CustomizedSigner` with the specified `signatureType` and `handler`
    ///
    /// - parameter signatureType: The signature type model.
    /// - parameter handler:       The signature handler.
    ///
    /// - returns: The new `CustomizedSigner` instance.
    @objc public convenience init(signatureType: SignatureTypeModelObjcBridge, handler: @escaping SignatureHandlerObjcBridge) {
        var actualSignatureType: QingStorSignatureType!
        switch signatureType.type {
        case .header:
            actualSignatureType = .header
        case .query:
            actualSignatureType = .query(timeoutSeconds: signatureType.timeoutSeconds)
        }

        let actualHandler: SignatureHandler = { signer, plainString, builder, completion in
            handler(signer, plainString, builder) { result in
                var actualResult: SignatureResult!
                switch result.type {
                case .query:
                    guard let accessKey = result.accessKey else {
                        fatalError("The access key must not be null for query signature")
                    }
                    actualResult = .query(signature: result.signature, accessKey: accessKey, expires: result.expires?.intValue)

                case .header:
                    guard let accessKey = result.accessKey else {
                        fatalError("The access key must not be null for header signature")
                    }
                    actualResult = .header(signature: result.signature, accessKey: accessKey)

                case .authorization:
                    actualResult = .authorization(result.signature)
                }

                completion(actualResult)
            }
        }

        self.init(signatureType: actualSignatureType, handler: actualHandler)
    }

    /// Calculate query signature string from request builder, will execute signature handler to Calculate signature result.
    ///
    /// - parameter requestBuilder: The request builder.
    /// - parameter timeoutSeconds: The timeout of the generated URL.
    ///
    /// - returns: The signature result model.
    @objc public func querySignatureString(from requestBuilder: RequestBuilder, timeoutSeconds: Int) -> SignatureResultModelObjcBridge? {
        do {
            let result: SignatureResult = try querySignatureString(from: requestBuilder, timeoutSeconds: timeoutSeconds)

            switch result {
            case let .query(signature, accessKey, expires):
                return SignatureResultModelObjcBridge.query(signature: signature, accessKey: accessKey, expires: expires as NSNumber?)
            default:
                return nil
            }
        } catch {
            return nil
        }
    }

    /// Calculate header signature string from request builder, will execute signature handler to Calculate signature result.
    ///
    /// - parameter requestBuilder: The request builder.
    ///
    /// - returns: The signature result model.
    @objc public func headerSignatureString(from requestBuilder: RequestBuilder) -> SignatureResultModelObjcBridge? {
        do {
            let result: SignatureResult = try headerSignatureString(from: requestBuilder)

            switch result {
            case let .header(signature, accessKey):
                return SignatureResultModelObjcBridge.header(signature: signature, accessKey: accessKey)
            default:
                return nil
            }
        } catch {
            return nil
        }
    }
}
