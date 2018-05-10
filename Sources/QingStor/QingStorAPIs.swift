//
//  QingStorAPIs.swift
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
import ObjectMapper

let defaultIgnoreIntValue = Int.min

private let qingstorBaseURL = "https://qingstor.com:443/"

public extension APIContext {
    /// Create `APIContext` instance of using QingStor server.
    @objc public static func qingstor() -> APIContext {
        return APIContext(baseURL: qingstorBaseURL)
    }

    /// Create `APIContext` instance of using QingStor server.
    ///
    /// - parameter accessKeyID:      The QingCloud API access key.
    /// - parameter secretAccessKey:  The QingCloud API secret access key.
    @objc public static func qingstor(accessKeyID: String, secretAccessKey: String) -> APIContext {
        return APIContext(baseURL: qingstorBaseURL, accessKeyID: accessKeyID, secretAccessKey: secretAccessKey)
    }
}

public extension APISender {
    /// Create `APISender` instance of using QingStor server.
    public class func qingstor(context: APIContext = APIContext.qingstor(),
                               input: QingStorInput,
                               method: HTTPMethod = .get,
                               signer: Signer = QingStorSigner(),
                               headers: [String:String] = [:],
                               credential: URLCredential? = nil,
                               buildingQueue: DispatchQueue = DispatchQueue.global(),
                               callbackQueue: DispatchQueue = DispatchQueue.main) -> (APISender?, Error?) {
        if let error = input.validate() {
            return (nil, error)
        }

        let actualSigner = signer.rawCopy()
        if let signatureType = input.signatureType {
            actualSigner.signatureType = signatureType
        }

        let sender = APISender(context: context,
                               input: input,
                               method: method,
                               signer: actualSigner,
                               headers: headers,
                               credential: credential,
                               acceptableStatusCodes: [301, 304, 400, 401, 402, 403, 404, 405, 409, 412, 416, 500, 503],
                               buildingQueue: buildingQueue,
                               callbackQueue: callbackQueue)
        sender.headers["Date"] = String.RFC822()

        return (sender, nil)
    }
}

/// QingStor API base class.
@objc(QSQingStorAPI)
public class QingStorAPI: NSObject, BaseAPI {
    /// The api context.
    @objc public var context: APIContext

    /// The signer.
    public var signer: Signer

    /// The url credential.
    @objc public var credential: URLCredential?

    /// The building queue.
    @objc public var buildingQueue: DispatchQueue

    /// The callback queue.
    @objc public var callbackQueue: DispatchQueue

    /// Initialize `QingStorAPI` with specified parameters.
    ///
    /// - parameter context:        The api context.
    /// - parameter signer:         The signer.
    /// - parameter credential:     The url credential.
    /// - parameter buildingQueue:  The building queue.
    /// - parameter callbackQueue:  The callback queue.
    ///
    /// - returns: The new `QingStorAPI` instance.
    public init(context: APIContext = APIContext.qingstor(),
                signer: Signer = QingStorSigner(),
                credential: URLCredential? = nil,
                buildingQueue: DispatchQueue = DispatchQueue.global(),
                callbackQueue: DispatchQueue = DispatchQueue.main) {
        self.context = context
        self.signer = signer
        self.credential = credential
        self.buildingQueue = buildingQueue
        self.callbackQueue = callbackQueue
    }

    /// Initialize `QingStorAPI` with using default datas.
    ///
    /// - returns: The new `QingStorAPI` instance.
    @objc public override convenience init() {
        self.init(context: APIContext.qingstor(),
                  signer: QingStorSigner(),
                  credential: nil,
                  buildingQueue: DispatchQueue.global(),
                  callbackQueue: DispatchQueue.main)
    }
}

/// QingStor input base class
@objc(QSQingStorInput)
public class QingStorInput: APIInput {
    /// The signature type
    public var signatureType: QingStorSignatureType?
}

/// QingStor output base class
@objc(QSQingStorOutput)
public class QingStorOutput: APIOutput {
    /// The error code
    @objc public var code: String?

    /// The error message
    @objc public var errMessage: String?

    /// The request id
    @objc public var requestId: String?

    /// Mapping response data
    public override func mapping(map: Map) {
        super.mapping(map: map)

        code <- map["code"]
        errMessage <- map["message"]
        requestId <- map["X-QS-Request-ID"]
    }
}

/// QingStor download input base class
@objc(QSQingStorDownloadInput)
public class QingStorDownloadInput: QingStorInput, APIDownloadInput {
    /// The url where the file should be saved.
    @objc public var destinationURL: URL?
}

/// QingStor download output base class
@objc(QSQingStorDownloadOutput)
public class QingStorDownloadOutput: QingStorOutput, APIDownloadOutput {
    /// The url where the file is saved.
    @objc public var destinationURL: URL?

    /// Mapping response data
    public override func mapping(map: Map) {
        super.mapping(map: map)

        destinationURL <- map["destination_url"]
    }
}
