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

@objc(QSSignatureType)
public enum SignatureTypeObjcBridge: Int {
    case query = 0
    case header
}

@objc(QSSignatureTypeModel)
public class SignatureTypeModelObjcBridge: NSObject {
    @objc public let type: SignatureTypeObjcBridge
    @objc public let timeoutSeconds: Int

    @objc public init(type: SignatureTypeObjcBridge, timeoutSeconds: Int) {
        self.type = type
        self.timeoutSeconds = timeoutSeconds
    }

    @objc public static func query(timeoutSeconds: Int) -> SignatureTypeModelObjcBridge {
        return SignatureTypeModelObjcBridge(type: .query, timeoutSeconds: timeoutSeconds)
    }

    @objc public static func header() -> SignatureTypeModelObjcBridge {
        return SignatureTypeModelObjcBridge(type: .header, timeoutSeconds: 0)
    }
}

@objc(QSSignatureResultType)
public enum SignatureResultTypeObjcBridge: Int {
    case query = 0
    case header
    case authorization
}

@objc(QSSignatureResultModel)
public class SignatureResultModelObjcBridge: NSObject {
    @objc public let type: SignatureResultTypeObjcBridge
    @objc public let signature: String

    @objc public let accessKey: String?
    @objc public let expires: NSNumber? // Int value

    @objc public init(type: SignatureResultTypeObjcBridge, signature: String, accessKey: String?, expires: NSNumber?) {
        self.type = type
        self.signature = signature
        self.accessKey = accessKey
        self.expires = expires
    }

    @objc public static func query(signature: String, accessKey: String, expires: NSNumber?) -> SignatureResultModelObjcBridge {
        return SignatureResultModelObjcBridge(type: .query, signature: signature, accessKey: accessKey, expires: expires)
    }

    @objc public static func header(signature: String, accessKey: String) -> SignatureResultModelObjcBridge {
        return SignatureResultModelObjcBridge(type: .header, signature: signature, accessKey: accessKey, expires: nil)
    }

    @objc public static func authorization(signature: String) -> SignatureResultModelObjcBridge {
        return SignatureResultModelObjcBridge(type: .authorization, signature: signature, accessKey: nil, expires: nil)
    }
}

extension QingStorSigner {
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
    public typealias SignatureHandlerCompletionObjcBridge = (SignatureResultModelObjcBridge) -> Void
    public typealias SignatureHandlerObjcBridge = (CustomizedSigner, String, RequestBuilder, @escaping SignatureHandlerCompletionObjcBridge) -> Void

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
