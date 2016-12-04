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

        bucket = qsService.bucket(bucketName: bucketName)
    }

    override func setupFeature() {
        When("^put bucket policy:$") { (args, userInfo) -> Void in
            self.testPutPolicy(testCase: userInfo?[kXCTestCaseKey] as! XCTestCase,
                               json: userInfo?[kDocStringKey] as! String)
        }

        Then("^put bucket policy status code is (\\d+)$") { (args, userInfo) -> Void in
            self.assertEqual(value: "\(self.putPolicyResponse.response.statusCode)", shouldBe: "\(args![0])")
        }

        When("^get bucket policy$") { (args, userInfo) -> Void in
            self.testGetPolicy(testCase: userInfo?[kXCTestCaseKey] as! XCTestCase)
        }

        Then("^get bucket policy status code is (\\d+)$") { (args, userInfo) -> Void in
            self.assertEqual(value: "\(self.getPolicyResponse.response.statusCode)", shouldBe: "\(args![0])")
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
            self.assertEqual(value: "\(self.deletePolicyResponse.response.statusCode)", shouldBe: "\(args![0])")
        }
    }

    func testPutPolicy(testCase: XCTestCase, json: String) {
        let expectation = testCase.expectation(description: "")

        let input = Mapper<PutBucketPolicyInput>().map(JSONString: json)!
        input.statement[0].resource = ["\(self.bucket.bucketName!)/*"]
        bucket.putPolicy(input: input) { response, error in
            if let response = response {
                self.putPolicyResponse = response

                if response.output.errMessage == nil {
                    print("success: \(response.output.toJSON())")
                }
            }

            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.4) {
                expectation.fulfill()
            }

            XCTAssertNotNil(response, "error: \(error!)")
            XCTAssertNil(response?.output.errMessage, "statusCode: \(response!.response.statusCode)    error: \(response!.output.errMessage!)")
        }

        testCase.waitForExpectations(timeout: timeout, handler: nil)
    }

    func testGetPolicy(testCase: XCTestCase) {
        let expectation = testCase.expectation(description: "")

        bucket.getPolicy { response, error in
            if let response = response {
                self.getPolicyResponse = response

                if response.output.errMessage == nil {
                    print("success: \(response.output.toJSON())")
                }
            }

            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.4) {
                expectation.fulfill()
            }

            XCTAssertNotNil(response, "error: \(error!)")
            XCTAssertNil(response?.output.errMessage, "statusCode: \(response!.response.statusCode)    error: \(response!.output.errMessage!)")
        }

        testCase.waitForExpectations(timeout: timeout, handler: nil)
    }

    func testDeletePolicy(testCase: XCTestCase) {
        let expectation = testCase.expectation(description: "")

        bucket.deletePolicy { response, error in
            if let response = response {
                self.deletePolicyResponse = response

                if response.output.errMessage == nil {
                    print("success: \(response.output.toJSON())")
                }
            }

            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.4) {
                expectation.fulfill()
            }

            XCTAssertNotNil(response, "error: \(error!)")
            XCTAssertNil(response?.output.errMessage, "statusCode: \(response!.response.statusCode)    error: \(response!.output.errMessage!)")
        }

        testCase.waitForExpectations(timeout: timeout, handler: nil)
    }

    override class func setup() {
        BucketPolicyTests().setup()
    }
}
