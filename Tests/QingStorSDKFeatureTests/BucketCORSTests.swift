//
//  BucketCORSTests.swift
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

class BucketCORSTests: QingStorTests {
    var bucket: Bucket!

    var putCORSResponse: Response<PutBucketCORSOutput>!
    var getCORSResponse: Response<GetBucketCORSOutput>!
    var deleteCORSResponse: Response<DeleteBucketCORSOutput>!

    override func setup() {
        super.setup()

        bucket = qsService.bucket(bucketName: bucketName)
    }

    override func setupFeature() {
        When("^put bucket CORS:$") { (args, userInfo) -> Void in
            self.testPutCORS(testCase: userInfo?[kXCTestCaseKey] as! XCTestCase,
                             json: userInfo?[kDocStringKey] as! String)
        }

        Then("^put bucket CORS status code is (\\d+)$") { (args, userInfo) -> Void in
            self.assertEqual(value: "\(self.putCORSResponse.response.statusCode)", shouldBe: "\(args![0])")
        }

        When("^get bucket CORS$") { (args, userInfo) -> Void in
            self.testGetCORS(testCase: userInfo?[kXCTestCaseKey] as! XCTestCase)
        }

        Then("^get bucket CORS status code is (\\d+)$") { (args, userInfo) -> Void in
            self.assertEqual(value: "\(self.getCORSResponse.response.statusCode)", shouldBe: "\(args![0])")
        }

        And("^get bucket CORS should have allowed origin \"([^\"]*)\"$") { (args, userInfo) -> Void in
            let allowedOrigin = args![0]
            for corsRule in self.getCORSResponse.output.corsRules! {
                if corsRule.allowedOrigin == allowedOrigin {
                    return
                }
            }

            XCTAssert(false, "Allowed origin \"\(allowedOrigin)\" not found in bucket CORS rules")
        }

        When("^delete bucket CORS") { (args, userInfo) -> Void in
            self.testDeleteCORS(testCase: userInfo?[kXCTestCaseKey] as! XCTestCase)
        }

        Then("^delete bucket CORS status code is (\\d+)$") { (args, userInfo) -> Void in
            self.assertEqual(value: "\(self.deleteCORSResponse.response.statusCode)", shouldBe: "\(args![0])")
        }
    }

    func testPutCORS(testCase: XCTestCase, json: String) {
        let expectation = testCase.expectation(description: "")

        let input = Mapper<PutBucketCORSInput>().map(JSONString: json)!
        bucket.putCORS(input: input) { response, error in
            if let response = response {
                self.putCORSResponse = response

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

    func testGetCORS(testCase: XCTestCase) {
        let expectation = testCase.expectation(description: "")

        bucket.getCORS { response, error in
            if let response = response {
                self.getCORSResponse = response

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

    func testDeleteCORS(testCase: XCTestCase) {
        let expectation = testCase.expectation(description: "")

        bucket.deleteCORS { response, error in
            if let response = response {
                self.deleteCORSResponse = response

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
        BucketCORSTests().setup()
    }
}
