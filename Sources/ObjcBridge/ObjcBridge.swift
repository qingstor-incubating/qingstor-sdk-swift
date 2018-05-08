//
// ObjcBridge.swift
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

import Foundation

@objc(QSAPISenderResult)
open class APISenderResult: NSObject {
    @objc public let sender: APISender?
    @objc public let error: Error?

    public init(sender: APISender?, error: Error?) {
        self.sender = sender
        self.error = error
    }
}

extension APIContext {
    @objc public var portNumber: NSNumber? {
        get {
            return port as NSNumber?
        }
        set {
            port = newValue?.intValue
        }
    }
}

extension QingStorAPI {
    @objc public convenience init(context: APIContext) {
        self.init(context: context,
                  signer: QingStorSigner(),
                  credential: nil,
                  buildingQueue: DispatchQueue.global(),
                  callbackQueue: DispatchQueue.main)
    }

    @objc public convenience init(context: APIContext,
                credential: URLCredential?,
                buildingQueue: DispatchQueue,
                callbackQueue: DispatchQueue) {
        self.init(context: context,
                  signer: QingStorSigner(),
                  credential: credential,
                  buildingQueue: buildingQueue,
                  callbackQueue: callbackQueue)
    }

    @objc public convenience init(qingStorSigner: QingStorSigner) {
        self.init(signer: qingStorSigner)
    }

    @objc public convenience init(context: APIContext, qingStorSigner: QingStorSigner) {
        self.init(context: context, signer: qingStorSigner)
    }

    @objc public convenience init(customizedSigner: CustomizedSigner) {
        self.init(signer: customizedSigner)
    }

    @objc public convenience init(context: APIContext, customizedSigner: CustomizedSigner) {
        self.init(context: context, signer: customizedSigner)
    }
}

@objc(QSHTTPMethod)
public enum HTTPMethodObjcBridge: Int {
    case options
    case get
    case head
    case post
    case put
    case patch
    case delete
    case trace
    case connect

    init(_ method: HTTPMethod) {
        switch method {
        case .options:
            self = .options
        case .get:
            self = .get
        case .head:
            self = .head
        case .post:
            self = .post
        case .put:
            self = .put
        case .patch:
            self = .patch
        case .delete:
            self = .delete
        case .trace:
            self = .trace
        case .connect:
            self = .connect
        }
    }
}

extension HTTPMethod {
    init(_ method: HTTPMethodObjcBridge) {
        switch method {
        case .options:
            self = .options
        case .get:
            self = .get
        case .head:
            self = .head
        case .post:
            self = .post
        case .put:
            self = .put
        case .patch:
            self = .patch
        case .delete:
            self = .delete
        case .trace:
            self = .trace
        case .connect:
            self = .connect
        }
    }
}

extension RequestBuilder {
    @objc(method)
    public var methodObjcBridge: HTTPMethodObjcBridge {
        get {
            return HTTPMethodObjcBridge(method)
        }
        set {
            method = HTTPMethod(newValue)
        }
    }

    @objc public func setQingStorSigner(_ signer: QingStorSigner) {
        self.signer = signer
    }

    @objc public func setCustomizedSigner(_ signer: CustomizedSigner) {
        self.signer = signer
    }
}

extension APISender {
    @objc(method)
    public var methodObjcBridge: HTTPMethodObjcBridge {
        get {
            return HTTPMethodObjcBridge(method)
        }
        set {
            method = HTTPMethod(newValue)
        }
    }

    @objc public func setQingStorSigner(_ signer: QingStorSigner) {
        self.signer = signer
    }

    @objc public func setCustomizedSigner(_ signer: CustomizedSigner) {
        self.signer = signer
    }
}

public extension NSURL {
    @objc(qs_contentLength)
    public var contentLength: Int {
        return (self as URL).contentLength
    }

    @objc(qs_mimeType)
    public var mimeType: String {
        return (self as URL).mimeType
    }
}
