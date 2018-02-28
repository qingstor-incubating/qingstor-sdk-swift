//
// QingStor.swift
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

extension QingStor {
    // ListBuckets: Retrieve the bucket list.
    // Documentation URL: https://docs.qingcloud.com/qingstor/api/service/get.html
    @objc public func listBuckets(input: ListBucketsInput, completion: @escaping (ListBucketsOutput?, HTTPURLResponse?, Error?) -> Void) {
    	self.listBuckets(input: input) { response, error in
            completion(response?.output, response?.rawResponse, error)
        }
    }

    // listBucketsSender create sender of listBuckets.
    @objc public func listBucketsSender(input: ListBucketsInput) -> APISenderResult {
        let (sender, error) = self.listBucketsSender(input: input)
        return APISenderResult(sender: sender, error: error)
    }
}

extension APISender {
    @objc public func sendListBucketsAPI(completion: @escaping (ListBucketsOutput?, HTTPURLResponse?, Error?) -> Void) {
        sendAPI { (response: Response<ListBucketsOutput>?, error: Error?) in
            completion(response?.output, response?.rawResponse, error)
        }
    }
}

extension ListBucketsInput {
    @objc public static func empty() -> ListBucketsInput {
        return ListBucketsInput(location: nil)
    }
}
