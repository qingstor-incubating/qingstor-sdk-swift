//
//  BucketPolicyTests.swift
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

class BucketPolicyTests: QingStorTests {
    var bucket: Bucket!

    var putPolicyResponse: Response<PutBucketPolicyOutput>!
    var getPolicyResponse: Response<GetBucketPolicyOutput>!
    var deletePolicyResponse: Response<DeleteBucketPolicyOutput>!

    override func setup() {
        super.setup()

        bucket = qsService.bucket(bucketName: bucketName, zone: currentZone)
    }

    override func setupFeature() {
        When("^put bucket policy:$") { (args, userInfo) -> Void in
            self.testPutPolicy(testCase: userInfo?[kXCTestCaseKey] as! XCTestCase,
                               json: userInfo?[kDocStringKey] as! String)
        }

        Then("^put bucket policy status code is (\\d+)$") { (args, userInfo) -> Void in
            self.assertEqual(value: "\(self.putPolicyResponse.statusCode)", shouldBe: "\(args![0])")
        }

        When("^get bucket policy$") { (args, userInfo) -> Void in
            self.testGetPolicy(testCase: userInfo?[kXCTestCaseKey] as! XCTestCase)
        }

        Then("^get bucket policy status code is (\\d+)$") { (args, userInfo) -> Void in
            self.assertEqual(value: "\(self.getPolicyResponse.statusCode)", shouldBe: "\(args![0])")
        }

        And("^get bucket policy should have Referer \"([^\"]*)\"$") { (args, userInfo) -> Void in
            let referer = args![0]
            for statement in self.getPolicyResponse.output.statement! {
                if let condition = statement.condition {
                    if let stringLike = condition.stringLike {
                        if let referers = stringLike.referer {
                            if referers.contains(referer) {
                                return
                            }
                        }
                    }
                }
            }

            XCTAssert(false, "Referer \"\(referer)\" not found in bucket policy statement")
        }

        When("^delete bucket policy$") { (args, userInfo) -> Void in
            self.testDeletePolicy(testCase: userInfo?[kXCTestCaseKey] as! XCTestCase)
        }

        Then("^delete bucket policy status code is (\\d+)$") { (args, userInfo) -> Void in
            self.assertEqual(value: "\(self.deletePolicyResponse.statusCode)", shouldBe: "\(args![0])")
        }
    }

    func testPutPolicy(testCase: XCTestCase, json: String) {
        let request: (@escaping RequestCompletion<PutBucketPolicyOutput>) -> Void = { completion in
            let input = Mapper<PutBucketPolicyInput>().map(JSONString: json)!
            input.statement[0].resource = ["\(self.bucket.bucketName)/*"]
            self.bucket.putPolicy(input: input, completion: completion)
        }

        self.assertReqeust(testCase: testCase, request: request) { response, error in
            self.putPolicyResponse = response!
        }
    }

    func testGetPolicy(testCase: XCTestCase) {
        let request: (@escaping RequestCompletion<GetBucketPolicyOutput>) -> Void = { completion in
            self.bucket.getPolicy(completion: completion)
        }

        self.assertReqeust(testCase: testCase, request: request) { response, error in
            self.getPolicyResponse = response!
        }
    }

    func testDeletePolicy(testCase: XCTestCase) {
        let request: (@escaping RequestCompletion<DeleteBucketPolicyOutput>) -> Void = { completion in
            self.bucket.deletePolicy(completion: completion)
        }

        self.assertReqeust(testCase: testCase, request: request) { response, error in
            self.deletePolicyResponse = response!
        }
    }

    override class func setup() {
        BucketPolicyTests().setup()
    }
}
