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
    @objc public static func qingstor() -> APIContext {
        return APIContext(baseURL: qingstorBaseURL)
    }

    @objc public static func qingstor(accessKeyID: String, secretAccessKey: String) -> APIContext {
        return APIContext(baseURL: qingstorBaseURL, accessKeyID: accessKeyID, secretAccessKey: secretAccessKey)
    }
}

public extension APISender {
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

@objc(QSQingStorAPI)
public class QingStorAPI: NSObject, BaseAPI {
    @objc public var context: APIContext
    public var signer: Signer
    @objc public var credential: URLCredential?
    @objc public var buildingQueue: DispatchQueue
    @objc public var callbackQueue: DispatchQueue

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

    @objc public override convenience init() {
        self.init(context: APIContext.qingstor(),
                  signer: QingStorSigner(),
                  credential: nil,
                  buildingQueue: DispatchQueue.global(),
                  callbackQueue: DispatchQueue.main)
    }
}

@objc(QSQingStorInput)
public class QingStorInput: APIInput {
    public var signatureType: QingStorSignatureType?
}

@objc(QSQingStorOutput)
public class QingStorOutput: APIOutput {
    @objc public var code: String?
    @objc public var errMessage: String?
    @objc public var requestId: String?

    public override func mapping(map: Map) {
        super.mapping(map: map)

        code <- map["code"]
        errMessage <- map["message"]
        requestId <- map["X-QS-Request-ID"]
    }
}

@objc(QSQingStorDownloadInput)
public class QingStorDownloadInput: QingStorInput, APIDownloadInput {
    @objc public var destinationURL: URL?
}

@objc(QSQingStorDownloadOutput)
public class QingStorDownloadOutput: QingStorOutput, APIDownloadOutput {
    @objc public var destinationURL: URL?

    public override func mapping(map: Map) {
        super.mapping(map: map)

        destinationURL <- map["destination_url"]
    }
}
