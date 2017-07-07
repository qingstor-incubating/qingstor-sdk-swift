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
    var initiateMultipartUploadResponse: Response<InitiateMultipartUploadOutput>!
    var listMultipartUploadsResponse: Response<ListMultipartUploadsOutput>!
    var listMultipartUploadsPrefixResponse: Response<ListMultipartUploadsOutput>!

    let listMultipartUploadsOutputObjectKey = "list_multipart_uploads_object_key"

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

        Given("^an object created by initiate multipart upload$") { (args, userInfo) -> Void in
            self.testAnObjectCreatedByInitiateMultipartUpload(testCase: userInfo?[kXCTestCaseKey] as! XCTestCase)
        }

        When("^list multipart uploads$") { (args, userInfo) -> Void in
            self.testListMultipartUploads(testCase: userInfo?[kXCTestCaseKey] as! XCTestCase)
        }

        Then("^list multipart uploads count is (\\d+)$") { (args, userInfo) -> Void in
            self.assertEqual(value: (self.listMultipartUploadsResponse.output.uploads?.count)!, shouldBe: Int(args![0])!)
        }

        When("^list multipart uploads with prefix$") { (args, userInfo) -> Void in
            self.testListMultipartUploadsPrefix(testCase: userInfo?[kXCTestCaseKey] as! XCTestCase)
        }

        Then("^list multipart uploads with prefix count is (\\d+)$") { (args, userInfo) -> Void in
            self.testListMultipartUploadsPrefixCountIs(testCase: userInfo?[kXCTestCaseKey] as! XCTestCase, count: Int(args![0])!)
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
        let request: (@escaping RequestCompletion<ListObjectsOutput>) -> Void = { completion in
            let input = ListObjectsInput()
            self.bucket.listObjects(input: input, completion: completion)
        }

        self.assertReqeust(testCase: testCase, request: request) { response, error in
            self.listObjectsResponse = response!
        }
    }

    func testHead(testCase: XCTestCase) {
        let request: (@escaping RequestCompletion<HeadBucketOutput>) -> Void = { completion in
            self.bucket.head(completion: completion)
        }

        self.assertReqeust(testCase: testCase, request: request) { response, error in
            self.headResponse = response!
        }
    }

    func testDeleteMultipleObjects(testCase: XCTestCase, json: String) {
        let request: (@escaping RequestCompletion<DeleteMultipleObjectsOutput>) -> Void = { completion in
            let input = Mapper<DeleteMultipleObjectsInput>().map(JSONString: json)!
            self.bucket.deleteMultipleObjects(input: input, completion: completion)
        }

        self.assertReqeust(testCase: testCase, request: request) { response, error in
            self.deleteMultipleObjectsResponse = response!
        }
    }

    func testGetStatistics(testCase: XCTestCase) {
        let request: (@escaping RequestCompletion<GetBucketStatisticsOutput>) -> Void = { completion in
            self.bucket.getStatistics(completion: completion)
        }

        self.assertReqeust(testCase: testCase, request: request) { response, error in
            self.getStatisticsResponse = response!
        }
    }

    func testDelete(testCase: XCTestCase) {
        let request: (@escaping RequestCompletion<DeleteBucketOutput>) -> Void = { completion in
            self.bucket.delete(completion: completion)
        }

        self.assertReqeust(testCase: testCase, request: request) { response, error in
            self.deleteResponse = response!
        }
    }

    func testAnObjectCreatedByInitiateMultipartUpload(testCase: XCTestCase) {
        let request: (@escaping RequestCompletion<InitiateMultipartUploadOutput>) -> Void = { completion in
            let input = InitiateMultipartUploadInput()
            self.bucket.initiateMultipartUpload(objectKey: self.listMultipartUploadsOutputObjectKey, input: input, completion: completion)
        }

        self.assertReqeust(testCase: testCase, request: request) { response, error in
            self.initiateMultipartUploadResponse = response!
        }
    }

    func testListMultipartUploads(testCase: XCTestCase) {
        let request: (@escaping RequestCompletion<ListMultipartUploadsOutput>) -> Void = { completion in
            let input = ListMultipartUploadsInput()
            self.bucket.listMultipartUploads(input: input, completion: completion)
        }

        self.assertReqeust(testCase: testCase, request: request) { response, error in
            self.listMultipartUploadsResponse = response!
        }
    }

    func testListMultipartUploadsPrefix(testCase: XCTestCase) {
        let request: (@escaping RequestCompletion<ListMultipartUploadsOutput>) -> Void = { completion in
            let input = ListMultipartUploadsInput(prefix: self.listMultipartUploadsOutputObjectKey)
            self.bucket.listMultipartUploads(input: input, completion: completion)
        }

        self.assertReqeust(testCase: testCase, request: request) { response, error in
            self.listMultipartUploadsPrefixResponse = response!
        }
    }

    func testListMultipartUploadsPrefixCountIs(testCase: XCTestCase, count: Int) {
        let request: (@escaping RequestCompletion<AbortMultipartUploadOutput>) -> Void = { completion in
            let input = AbortMultipartUploadInput(uploadID: (self.listMultipartUploadsPrefixResponse.output.uploads?[0].uploadID)!)
            self.bucket.abortMultipartUpload(objectKey: self.listMultipartUploadsOutputObjectKey, input: input, completion: completion)
        }

        self.assertReqeust(testCase: testCase, request: request) { response, error in
            self.assertEqual(value: (self.listMultipartUploadsPrefixResponse.output.uploads?.count)!, shouldBe: count)
        }
    }

    override class func setup() {
        BucketTests().setup()
    }
}
