//
//  ObjectMultipartTests.swift
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

class ObjectMultipartTests: QingStorTests {
    var bucket: Bucket!
    var objectKey: String!

    var initiateMultipartUploadResponse: Response<InitiateMultipartUploadOutput>!
    var uploadMultipartResponse: Response<UploadMultipartOutput>!
    var listMultipartResponse: Response<ListMultipartOutput>!
    var completeMultipartUploadResponse: Response<CompleteMultipartUploadOutput>!
    var abortMultipartUploadResponse: Response<AbortMultipartUploadOutput>!
    var deleteTheMultipartObjectResponse: Response<DeleteObjectOutput>!

    var objectFileURL: URL!
    let partContentLength = 4 * 1024 * 1024

    override func setup() {
        super.setup()

        timeout = 999999.9
        objectFileURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0].appendingPathComponent("a_large_file")
        bucket = qsService.bucket(bucketName: bucketName, zone: currentZone)
    }

    override func setupFeature() {
        When("initiate multipart upload with key \"(.{1,})\"$") { (args, userInfo) -> Void in
            self.objectKey = args![0]
            self.testInitiateMultipartUpload(testCase: userInfo?[kXCTestCaseKey] as! XCTestCase)
        }

        Then("^initiate multipart upload status code is (\\d+)$") { (args, _) -> Void in
            self.assertEqual(value: "\(self.initiateMultipartUploadResponse.statusCode)", shouldBe: "\(args![0])")
        }

        When("^upload the first part with key \"(.{1,})\"$") { (_, userInfo) -> Void in
            self.testUploadMultipart(testCase: userInfo?[kXCTestCaseKey] as! XCTestCase, partNumber: 0, isLastPart: false)
        }

        Then("^upload the first part status code is (\\d+)$") { (args, _) -> Void in
            self.assertEqual(value: "\(self.uploadMultipartResponse.statusCode)", shouldBe: "\(args![0])")
        }

        When("^upload the second part with key \"(.{1,})\"$") { (_, userInfo) -> Void in
            self.testUploadMultipart(testCase: userInfo?[kXCTestCaseKey] as! XCTestCase, partNumber: 1, isLastPart: false)
        }

        Then("^upload the second part status code is (\\d+)$") { (args, _) -> Void in
            self.assertEqual(value: "\(self.uploadMultipartResponse.statusCode)", shouldBe: "\(args![0])")
        }

        When("^upload the third part with key \"(.{1,})\"$") { (_, userInfo) -> Void in
            self.testUploadMultipart(testCase: userInfo?[kXCTestCaseKey] as! XCTestCase, partNumber: 2, isLastPart: true)
        }

        Then("^upload the third part status code is (\\d+)$") { (args, _) -> Void in
            self.assertEqual(value: "\(self.uploadMultipartResponse.statusCode)", shouldBe: "\(args![0])")
        }

        When("^list multipart with key \"(.{1,})\"$") { (_, userInfo) -> Void in
            self.testListMultipart(testCase: userInfo?[kXCTestCaseKey] as! XCTestCase)
        }

        Then("^list multipart status code is (\\d+)$") { (args, _) -> Void in
            self.assertEqual(value: "\(self.listMultipartResponse.statusCode)", shouldBe: "\(args![0])")
        }

        And("^list multipart object parts count is (\\d+)$") { (args, _) -> Void in
            self.assertEqual(value: "\(self.listMultipartResponse.output.objectParts!.count)", shouldBe: "\(args![0])")
        }

        When("^complete multipart upload with key \"(.{1,})\"$") { (_, userInfo) -> Void in
            self.testCompleteMultipartUpload(testCase: userInfo?[kXCTestCaseKey] as! XCTestCase)
        }

        Then("^complete multipart upload status code is (\\d+)$") { (args, _) -> Void in
            self.assertEqual(value: "\(self.completeMultipartUploadResponse.statusCode)", shouldBe: "\(args![0])")
        }

        When("^abort multipart upload with key \"(.{1,})\"$") { (_, userInfo) -> Void in
            self.testAbortMultipartUpload(testCase: userInfo?[kXCTestCaseKey] as! XCTestCase, isFalse: true)
        }

        Then("^abort multipart upload status code is (\\d+)$") { (args, _) -> Void in
//            self.assertEqual(value: "\(self.abortMultipartUploadResponse.statusCode)", shouldBe: "\(args![0])")
        }

        When("^delete the multipart object with key \"(.{1,})\"$") { (_, userInfo) -> Void in
            self.testDeleteMultipartObject(testCase: userInfo?[kXCTestCaseKey] as! XCTestCase)
        }

        Then("^delete the multipart object status code is (\\d+)$") { (args, _) -> Void in
            self.assertEqual(value: "\(self.deleteTheMultipartObjectResponse.statusCode)", shouldBe: "\(args![0])")
        }
    }

    func testInitiateMultipartUpload(testCase: XCTestCase) {
        let request: (@escaping RequestCompletion<InitiateMultipartUploadOutput>) -> Void = { completion in
            let input = InitiateMultipartUploadInput()
            self.bucket.initiateMultipartUpload(objectKey: self.objectKey, input: input, completion: completion)
        }

        self.assertReqeust(testCase: testCase, request: request) { response, _ in
            self.initiateMultipartUploadResponse = response!
        }
    }

    func testUploadMultipart(testCase: XCTestCase, partNumber: Int, isLastPart: Bool) {
        let request: (@escaping RequestCompletion<UploadMultipartOutput>) -> Void = { completion in
            let contentLength = self.objectFileURL.contentLength
            var seekOffset = partNumber * self.partContentLength
            if seekOffset > contentLength {
                seekOffset = contentLength - self.partContentLength
                if seekOffset < 0 {
                    seekOffset = 0
                }
            }

            let fileHandle = try! FileHandle(forReadingFrom: self.objectFileURL)
            fileHandle.seek(toFileOffset: UInt64(seekOffset))

            var readContentLength = self.partContentLength
            if isLastPart {
                readContentLength = contentLength - seekOffset
            }

            if readContentLength > contentLength {
                readContentLength = contentLength
            }

            let data = fileHandle.readData(ofLength: readContentLength)
            let inputStream = InputStream(data: data)

            let input = UploadMultipartInput(partNumber: partNumber,
                                             uploadID: self.initiateMultipartUploadResponse.output.uploadID!,
                                             contentLength: readContentLength,
                                             bodyInputStream: inputStream)
            self.bucket.uploadMultipart(objectKey: self.objectKey, input: input, progress: {
                print("upload multipart object: \(self.objectKey), progress: \($0)")
            }, completion: completion)

            fileHandle.closeFile()
        }

        self.assertReqeust(testCase: testCase, request: request) { response, _ in
            self.uploadMultipartResponse = response!
        }
    }

    func testListMultipart(testCase: XCTestCase) {
        let request: (@escaping RequestCompletion<ListMultipartOutput>) -> Void = { completion in
            let input = ListMultipartInput(uploadID: self.initiateMultipartUploadResponse.output.uploadID!)
            self.bucket.listMultipart(objectKey: self.objectKey, input: input, completion: completion)
        }

        self.assertReqeust(testCase: testCase, request: request) { response, _ in
            self.listMultipartResponse = response!
        }
    }

    func testCompleteMultipartUpload(testCase: XCTestCase) {
        let request: (@escaping RequestCompletion<CompleteMultipartUploadOutput>) -> Void = { completion in
            let input = CompleteMultipartUploadInput(uploadID: self.initiateMultipartUploadResponse.output.uploadID!,
                                                     objectParts: self.listMultipartResponse.output.objectParts ?? [])
            self.bucket.completeMultipartUpload(objectKey: self.objectKey, input: input, completion: completion)
        }

        self.assertReqeust(testCase: testCase, request: request) { response, _ in
            self.completeMultipartUploadResponse = response!
        }
    }

    func testAbortMultipartUpload(testCase: XCTestCase, isFalse: Bool) {
        let expectation = testCase.expectation(description: "")

        let input = AbortMultipartUploadInput(uploadID: self.initiateMultipartUploadResponse.output.uploadID!)
        bucket.abortMultipartUpload(objectKey: self.objectKey, input: input) { response, error in
            if let response = response {
                self.abortMultipartUploadResponse = response

                if response.output.errMessage == nil {
                    print("success: \(response.output.toJSON())")
                }
            }

            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.4) {
                expectation.fulfill()
            }

            if !isFalse {
                XCTAssertNotNil(response, "error: \(error!)")
                XCTAssertEqual(response?.output.errMessage, nil, "statusCode: \(response!.statusCode)    error: \(response!.output.errMessage!)")
            }
        }

        testCase.waitForExpectations(timeout: timeout, handler: nil)
    }

    func testDeleteMultipartObject(testCase: XCTestCase) {
        let request: (@escaping RequestCompletion<DeleteObjectOutput>) -> Void = { completion in
            self.bucket.deleteObject(objectKey: self.objectKey, completion: completion)
        }

        self.assertReqeust(testCase: testCase, request: request) { response, _ in
            self.deleteTheMultipartObjectResponse = response!
        }
    }

    override class func setup() {
        ObjectMultipartTests().setup()
    }
}
