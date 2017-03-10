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
            self.assertEqual(value: "\(self.putCORSResponse.statusCode)", shouldBe: "\(args![0])")
        }

        When("^get bucket CORS$") { (args, userInfo) -> Void in
            self.testGetCORS(testCase: userInfo?[kXCTestCaseKey] as! XCTestCase)
        }

        Then("^get bucket CORS status code is (\\d+)$") { (args, userInfo) -> Void in
            self.assertEqual(value: "\(self.getCORSResponse.statusCode)", shouldBe: "\(args![0])")
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
            self.assertEqual(value: "\(self.deleteCORSResponse.statusCode)", shouldBe: "\(args![0])")
        }
    }

    func testPutCORS(testCase: XCTestCase, json: String) {
        let request: (@escaping RequestCompletion<PutBucketCORSOutput>) -> Void = { completion in
            let input = Mapper<PutBucketCORSInput>().map(JSONString: json)!
            self.bucket.putCORS(input: input, completion: completion)
        }

        self.assertReqeust(testCase: testCase, request: request) { response, error in
            self.putCORSResponse = response!
        }
    }

    func testGetCORS(testCase: XCTestCase) {
        let request: (@escaping RequestCompletion<GetBucketCORSOutput>) -> Void = { completion in
            self.bucket.getCORS(completion: completion)
        }

        self.assertReqeust(testCase: testCase, request: request) { response, error in
            self.getCORSResponse = response!
        }
    }

    func testDeleteCORS(testCase: XCTestCase) {
        let request: (@escaping RequestCompletion<DeleteBucketCORSOutput>) -> Void = { completion in
            self.bucket.deleteCORS(completion: completion)
        }

        self.assertReqeust(testCase: testCase, request: request) { response, error in
            self.deleteCORSResponse = response!
        }
    }

    override class func setup() {
        BucketCORSTests().setup()
    }
}
