//
//  BucketACLTests.swift
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

import XCTest
import Cucumberish
import QingStorSDK
import ObjectMapper

class BucketACLTests: QingStorTests {
    var bucket: Bucket!

    var putACLResponse: Response<PutBucketACLOutput>!
    var getACLResponse: Response<GetBucketACLOutput>!

    override func setup() {
        super.setup()

        bucket = qsService.bucket(bucketName: bucketName, zone: currentZone)
    }

    override func setupFeature() {
        When("^put bucket ACL:$") { (_, userInfo) -> Void in
            self.testputACL(testCase: userInfo?[kXCTestCaseKey] as! XCTestCase,
                            json: userInfo?[kDocStringKey] as! String)
        }

        Then("^put bucket ACL status code is (\\d+)$") { (args, _) -> Void in
            self.assertEqual(value: "\(self.putACLResponse.statusCode)", shouldBe: "\(args![0])")
        }

        When("^get bucket ACL$") { (_, userInfo) -> Void in
            self.testGetACL(testCase: userInfo?[kXCTestCaseKey] as! XCTestCase)
        }

        Then("^get bucket ACL status code is (\\d+)$") { (args, _) -> Void in
            self.assertEqual(value: "\(self.putACLResponse.statusCode)", shouldBe: "\(args![0])")
        }

        And("^get bucket ACL should have grantee name \"([^\"]*)\"$") { (args, _) -> Void in
            let granteeName = args![0]
            for acl in self.getACLResponse.output.acl! {
                if acl.grantee.name == granteeName {
                    return
                }
            }

            XCTAssert(false, "Grantee name \"\(granteeName)\" not found in bucket ACLs")
        }
    }

    func testputACL(testCase: XCTestCase, json: String) {
        let request: (@escaping RequestCompletion<PutBucketACLOutput>) -> Void = { completion in
            let input = Mapper<PutBucketACLInput>().map(JSONString: json)!
            self.bucket.putACL(input: input, completion: completion)
        }

        self.assertReqeust(testCase: testCase, request: request) { response, _ in
            self.putACLResponse = response!
        }
    }

    func testGetACL(testCase: XCTestCase) {
        let request: (@escaping RequestCompletion<GetBucketACLOutput>) -> Void = { completion in
            self.bucket.getACL(completion: completion)
        }

        self.assertReqeust(testCase: testCase, request: request) { response, _ in
            self.getACLResponse = response!
        }
    }

    override class func setup() {
        BucketACLTests().setup()
    }
}
