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

private var contextZoneKey: UInt = 0
public extension APIContext {
    public static func qingStor(urlString: String = "https://qingstor.com:443/",
                                accessKeyID: String = Registry.accessKeyID,
                                secretAccessKey: String = Registry.secretAccessKey) -> APIContext {
        return APIContext(urlString: urlString, accessKeyID: accessKeyID, secretAccessKey: secretAccessKey)
    }
}

public extension APISender {
    public class func qingStor(context: APIContext = APIContext.qingStor(),
                               input: QingStorInput,
                               method: HTTPMethod = .get,
                               signer: QingStorSigner = QingStorSigner(),
                               headers: [String:String] = [:],
                               credential: URLCredential? = nil) -> (APISender?, Error?) {
        if let error = input.validate() {
            return (nil, error)
        }

        signer.signatureType = input.signatureType
        let sender = APISender(context: context,
                               input: input,
                               method: method,
                               signer: signer,
                               headers: headers,
                               credential: credential,
                               acceptableStatusCodes: [301, 304, 400, 401, 402, 403, 404, 405, 409, 412, 416, 500, 503])
        sender.headers["Date"] = String.RFC822()

        return (sender, nil)
    }
}

public class QingStorAPI: BaseAPI {
    public var zone: String = defaultZone
    public var bucketName: String?

    public override init (context: APIContext = APIContext.qingStor()) {
        super.init(context: context)
    }

    public convenience init(context: APIContext = APIContext.qingStor(), zone: String) {
        self.init(context: context)

        self.zone = zone
    }

    public convenience init(context: APIContext = APIContext.qingStor(), bucketName: String, zone: String = defaultZone) {
        self.init(context: context, zone: zone)
        self.bucketName = bucketName
    }

    func setupContext(uriFormat: String?, bucketName: String? = nil, objectKey: String? = nil, zone: String? = nil) {
        self.context = self.context.rawCopy()

        if let uriFormat = uriFormat {
            var uri = uriFormat.replacingOccurrences(of: "<bucket-name>", with: bucketName ?? self.bucketName ?? "")
            uri = uri.replacingOccurrences(of: "<object-key>", with: objectKey ?? "")

            if let index = uri.range(of: "?", options: .backwards)?.lowerBound {
                let query = uri.substring(from: uri.index(after: index))
                self.context.query = query

                uri = uri.substring(to: index)
            }

            self.context.uri = uri
        }

        self.context.host = "\(zone ?? self.zone)." + (self.context.host ?? "")
    }
}

public class QingStorInput: APIInput {
    public var signatureType: QingStorSignatureType = .header
}

public class QingStorOutput: APIOutput {
    public var code: String?
    public var errMessage: String?
    public var requestId: String?

    public override func mapping(map: Map) {
        super.mapping(map: map)

        code <- map["code"]
        errMessage <- map["message"]
        requestId <- map["X-QS-Request-ID"]
    }
}

public class QingStorDownloadInput: QingStorInput, APIDownloadInput {
    public var destinationURL: URL?
}

public class QingStorDownloadOutput: QingStorOutput, APIDownloadOutput {
    public var destinationURL: URL?

    public override func mapping(map: Map) {
        super.mapping(map: map)

        destinationURL <- map["destination_url"]
    }
}
