//
// QingStor.swift
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

// QingStor: QingStor provides low-cost and reliable online storage service with unlimited storage space, high read and write performance, high reliability and data safety, fine-grained access control, and easy to use API.
public class QingStor: QingStorAPI {
    // ListBuckets: Retrieve the bucket list.
    // Documentation URL: https://docs.qingcloud.com/qingstor/api/service/get.html
    public func listBuckets(input: ListBucketsInput, completion: @escaping RequestCompletion<ListBucketsOutput>) {
        let (sender, error) = self.listBucketsSender(input: input)

        if let error = error {
            completion(nil, error)
            return
        }

        sender!.sendAPI(completion: completion)
    }

    // listBucketsSender create sender of listBuckets.
    public func listBucketsSender(input: ListBucketsInput) -> (APISender?, Error?) {
        return APISender.qingStor(context: self.context,
                                  input: input,
                                  method: .get,
                                  signer: self.signer,
                                  credential: self.credential,
                                  buildingQueue: self.buildingQueue,
                                  callbackQueue: self.callbackQueue)
    }

}

public class ListBucketsInput: QingStorInput {
    // Limits results to buckets that in the location
    public var location: String?

    override var headerProperties: [String] {
        return ["Location"]
    }

    public required init?(map: Map) {
        super.init(map: map)
    }

    public init(location: String? = nil) {
        super.init()

        self.location = location
    }

    public override func mapping(map: Map) {
        super.mapping(map: map)

        location <- map["Location"]
    }

    public override func validate() -> Error? {
        return nil
    }
}

public class ListBucketsOutput: QingStorOutput {
    // Buckets information
    public var buckets: [BucketModel]?
    // Bucket count
    public var count: Int?

    public override func mapping(map: Map) {
        super.mapping(map: map)

        buckets <- map["buckets"]
        count <- map["count"]
    }
}
