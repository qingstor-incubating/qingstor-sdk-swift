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

/// The objc bridge of to call api sender result.
@objc(QSAPISenderResult)
open class APISenderResult: NSObject {
    /// The api sender
    @objc public let sender: APISender?

    /// The error if call api sender encounters an error.
    @objc public let error: Error?

    /// Initialize `APISenderResult` with the specified `sender` and `error`.
    ///
    /// - parameter sender: The api sender.
    /// - parameter error:  The error if call api sender encounters an error.
    ///
    /// - returns: The new `APISenderResult` instance.
    public init(sender: APISender?, error: Error?) {
        self.sender = sender
        self.error = error
    }
}

extension APIContext {
    /// The objc bridge of the port.
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
    /// Initialize `QingStorAPI` with the specified `context`
    ///
    /// - parameter context: The api context.
    ///
    /// - returns: The new `QingStorAPI` instance.
    @objc public convenience init(context: APIContext) {
        self.init(context: context,
                  signer: QingStorSigner(),
                  credential: nil,
                  buildingQueue: DispatchQueue.global(),
                  callbackQueue: DispatchQueue.main)
    }

    /// Initialize `QingStorAPI` with the specified parameters.
    ///
    /// - parameter context:       The api context.
    /// - parameter credential:    The url credential.
    /// - parameter buildingQueue: The building queue.
    /// - parameter callbackQueue: The callback queue.
    ///
    /// - returns: The new `QingStorAPI` instance.
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

    /// Initialize `QingStorAPI` with the specified `qingStorSigner`.
    ///
    /// - parameter qingStorSigner: The QingStorSigner.
    ///
    /// - returns: The new `QingStorAPI` instance.
    @objc public convenience init(qingStorSigner: QingStorSigner) {
        self.init(signer: qingStorSigner)
    }

    /// Initialize `QingStorAPI` with the specified `context` and `qingStorSigner`.
    ///
    /// - parameter context:        The api context.
    /// - parameter qingStorSigner: The QingStorSigner.
    ///
    /// - returns: The new `QingStorAPI` instance.
    @objc public convenience init(context: APIContext, qingStorSigner: QingStorSigner) {
        self.init(context: context, signer: qingStorSigner)
    }

    /// Initialize `QingStorAPI` with the specified `customizedSigner`.
    ///
    /// - parameter customizedSigner: The CustomizedSigner.
    ///
    /// - returns: The new `QingStorAPI` instance.
    @objc public convenience init(customizedSigner: CustomizedSigner) {
        self.init(signer: customizedSigner)
    }

    /// Initialize `QingStorAPI` with the specified `context` and `customizedSigner`.
    ///
    /// - parameter context:          The api context.
    /// - parameter customizedSigner: The CustomizedSigner.
    ///
    /// - returns: The new `QingStorAPI` instance.
    @objc public convenience init(context: APIContext, customizedSigner: CustomizedSigner) {
        self.init(context: context, signer: customizedSigner)
    }
}

/// The objc bridge of the `HTTPMethod`.
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
    /// The objc bridge of the http method.
    @objc(method)
    public var methodObjcBridge: HTTPMethodObjcBridge {
        get {
            return HTTPMethodObjcBridge(method)
        }
        set {
            method = HTTPMethod(newValue)
        }
    }

    /// The objc bridge of to set `QingStorSigner`
    @objc public func setQingStorSigner(_ signer: QingStorSigner) {
        self.signer = signer
    }

    /// The objc bridge of to set `CustomizedSigner`
    @objc public func setCustomizedSigner(_ signer: CustomizedSigner) {
        self.signer = signer
    }
}

extension APISender {
    /// The objc bridge of the http method.
    @objc(method)
    public var methodObjcBridge: HTTPMethodObjcBridge {
        get {
            return HTTPMethodObjcBridge(method)
        }
        set {
            method = HTTPMethod(newValue)
        }
    }

    /// The objc bridge of to set `QingStorSigner`
    @objc public func setQingStorSigner(_ signer: QingStorSigner) {
        self.signer = signer
    }

    /// The objc bridge of to set `CustomizedSigner`
    @objc public func setCustomizedSigner(_ signer: CustomizedSigner) {
        self.signer = signer
    }
}

public extension NSURL {
    /// The size of file in bytes.
    @objc(qs_contentLength)
    public var contentLength: Int {
        return (self as URL).contentLength
    }

    /// The MIME type to associate with the data in the `Content-Type` HTTP header.
    @objc(qs_mimeType)
    public var mimeType: String {
        return (self as URL).mimeType
    }
}
