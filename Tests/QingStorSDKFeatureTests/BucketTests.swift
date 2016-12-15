//
//  BucketTests.swift
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

class BucketTests: QingStorTests {
    var bucket: Bucket!

    var putResponse: Response<PutBucketOutput>!
    var listObjectsResponse: Response<ListObjectsOutput>!
    var headResponse: Response<HeadBucketOutput>!
    var deleteResponse: Response<DeleteBucketOutput>!
    var deleteMultipleObjectsResponse: Response<DeleteMultipleObjectsOutput>!
    var getStatisticsResponse: Response<GetBucketStatisticsOutput>!

    override func setup() {
        super.setup()

        bucket = qsService.bucket(bucketName: bucketName)
    }

    override func setupFeature() {
        When("^initialize the bucket$") { (args, userInfo) -> Void in

        }

        Then("^the bucket is initialized$") { (args, userInfo) -> Void in
            XCTAssertNotNil(self.bucket, "Bucket sub service is not initialized")
        }

        When("^put bucket$") { (args, userInfo) -> Void in
            // self.testPutBucket(testCase: userInfo?[kXCTestCaseKey] as! XCTestCase)
        }

        Then("^put bucket status code is (\\d+)$") { (args, userInfo) -> Void in
            // self.assertEqual(value: "\(self.putBucketResponse.response.statusCode)", shouldBe: "\(args![0])")
        }

        When("^put same bucket again$") { (args, userInfo) -> Void in
            self.testPut(testCase: userInfo?[kXCTestCaseKey] as! XCTestCase, isSameObject: true)
        }

        Then("^put same bucket again status code is (\\d+)$$") { (args, userInfo) -> Void in
            self.assertEqual(value: "\(self.putResponse.statusCode)", shouldBe: "\(args![0])")
        }

        Then("^initialize the bucket without zone$") { (args, userInfo) -> Void in

        }

        When("^list objects$") { (args, userInfo) -> Void in
            self.testListObjects(testCase: userInfo?[kXCTestCaseKey] as! XCTestCase)
        }

        Then("^list objects status code is (\\d+)$") { (args, userInfo) -> Void in
            self.assertEqual(value: "\(self.listObjectsResponse.statusCode)", shouldBe: "\(args![0])")
        }

        And("^list objects keys count is (\\d+)$") { (args, userInfo) -> Void in
            self.assertEqual(value: "\(self.listObjectsResponse.output.keys!.count)", shouldBe: "\(args![0])")
        }

        When("^head bucket$") { (args, userInfo) -> Void in
            self.testHead(testCase: userInfo?[kXCTestCaseKey] as! XCTestCase)
        }

        Then("^head bucket status code is (\\d+)$") { (args, userInfo) -> Void in
            self.assertEqual(value: "\(self.headResponse.statusCode)", shouldBe: "\(args![0])")
        }

        When("^delete bucket$") { (args, userInfo) -> Void in
            // self.testDeleteBucket(testCase: userInfo?[kXCTestCaseKey] as! XCTestCase)
        }

        Then("^delete bucket status code is (\\d+)$") { (args, userInfo) -> Void in
            // self.assertEqual(value: "\(self.deleteBucketResponse.response.statusCode)", shouldBe: "\(args![0])")
        }

        When("^delete multiple objects:$") { (args, userInfo) -> Void in
            self.testDeleteMultipleObjects(testCase: userInfo?[kXCTestCaseKey] as! XCTestCase,
                                           json: userInfo?[kDocStringKey] as! String)
        }

        Then("^delete multiple objects code is (\\d+)$") { (args, userInfo) -> Void in
            self.assertEqual(value: "\(self.deleteMultipleObjectsResponse.statusCode)", shouldBe: "\(args![0])")
        }

        When("^get bucket statistics$") { (args, userInfo) -> Void in
            self.testGetStatistics(testCase: userInfo?[kXCTestCaseKey] as! XCTestCase)
        }

        Then("^get bucket statistics status code is (\\d+)$") { (args, userInfo) -> Void in
            self.assertEqual(value: "\(self.getStatisticsResponse.statusCode)", shouldBe: "\(args![0])")
        }

        And("^get bucket statistics status is \"([^\"]*)\"$") { (args, userInfo) -> Void in
            self.assertEqual(value: "\(self.getStatisticsResponse.output.status!)", shouldBe: "\(args![0])")
        }
    }

    func testPut(testCase: XCTestCase, isSameObject: Bool = false) {
        let expectation = testCase.expectation(description: "")

        bucket.put { response, error in
            if let response = response {
                self.putResponse = response

                if response.output.errMessage == nil {
                    print("success: \(response.output.toJSON())")
                }
            }

            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.4) {
                expectation.fulfill()
            }

            if !isSameObject {
                XCTAssertNotNil(response, "error: \(error!)")
                XCTAssertNil(response?.output.errMessage, "statusCode: \(response!.statusCode)    error: \(response!.output.errMessage!)")
            }
        }

        testCase.waitForExpectations(timeout: timeout, handler: nil)
    }

    func testListObjects(testCase: XCTestCase) {
        let expectation = testCase.expectation(description: "")

        let input = ListObjectsInput()
        bucket.listObjects(input: input) { response, error in
            if let response = response {
                self.listObjectsResponse = response

                if response.output.errMessage == nil {
                    print("success: \(response.output.toJSON())")
                }
            }

            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.4) {
                expectation.fulfill()
            }

            XCTAssertNotNil(response, "error: \(error!)")
            XCTAssertNil(response?.output.errMessage, "statusCode: \(response!.statusCode)    error: \(response!.output.errMessage!)")
        }

        testCase.waitForExpectations(timeout: timeout, handler: nil)
    }

    func testHead(testCase: XCTestCase) {
        let expectation = testCase.expectation(description: "")

        bucket.head { response, error in
            if let response = response {
                self.headResponse = response

                if response.output.errMessage == nil {
                    print("success: \(response.output.toJSON())")
                }
            }

            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.4) {
                expectation.fulfill()
            }

            XCTAssertNotNil(response, "error: \(error!)")
            XCTAssertNil(response?.output.errMessage, "statusCode: \(response!.statusCode)    error: \(response!.output.errMessage!)")
        }

        testCase.waitForExpectations(timeout: timeout, handler: nil)
    }

    func testDeleteMultipleObjects(testCase: XCTestCase, json: String) {
        let expectation = testCase.expectation(description: "")

        let input = Mapper<DeleteMultipleObjectsInput>().map(JSONString: json)!
        bucket.deleteMultipleObjects(input: input) { response, error in
            if let response = response {
                self.deleteMultipleObjectsResponse = response

                if response.output.errMessage == nil {
                    print("success: \(response.output.toJSON())")
                }
            }

            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.4) {
                expectation.fulfill()
            }

            XCTAssertNotNil(response, "error: \(error!)")
            XCTAssertNil(response?.output.errMessage, "statusCode: \(response!.statusCode)    error: \(response!.output.errMessage!)")
        }

        testCase.waitForExpectations(timeout: timeout, handler: nil)
    }

    func testGetStatistics(testCase: XCTestCase) {
        let expectation = testCase.expectation(description: "")

        bucket.getStatistics { response, error in
            if let response = response {
                self.getStatisticsResponse = response

                if response.output.errMessage == nil {
                    print("success: \(response.output.toJSON())")
                }
            }

            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.4) {
                expectation.fulfill()
            }

            XCTAssertNotNil(response, "error: \(error!)")
            XCTAssertNil(response?.output.errMessage, "statusCode: \(response!.statusCode)    error: \(response!.output.errMessage!)")
        }

        testCase.waitForExpectations(timeout: timeout, handler: nil)
    }

    func testDelete(testCase: XCTestCase) {
        let expectation = testCase.expectation(description: "")

        bucket.delete { response, error in
            if let response = response {
                self.deleteResponse = response

                if response.output.errMessage == nil {
                    print("success: \(response.output.toJSON())")
                }
            }

            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.4) {
                expectation.fulfill()
            }

            XCTAssertNotNil(response, "error: \(error!)")
            XCTAssertNil(response?.output.errMessage, "statusCode: \(response!.statusCode)    error: \(response!.output.errMessage!)")
        }

        testCase.waitForExpectations(timeout: timeout, handler: nil)
    }

    override class func setup() {
        BucketTests().setup()
    }
}
