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
    let uploadFileTimeout = 999999.9

    override func setup() {
        super.setup()

        objectFileURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0].appendingPathComponent("a_large_file")
        bucket = qsService.bucket(bucketName: bucketName)
    }

    override func setupFeature() {
        When("initiate multipart upload with key \"([^\"]*)\"$") { (args, userInfo) -> Void in
            self.objectKey = args![0]
            self.testInitiateMultipartUpload(testCase: userInfo?[kXCTestCaseKey] as! XCTestCase)
        }

        Then("^initiate multipart upload status code is (\\d+)$") { (args, userInfo) -> Void in
            self.assertEqual(value: "\(self.initiateMultipartUploadResponse.statusCode)", shouldBe: "\(args![0])")
        }

        When("^upload the first part$") { (args, userInfo) -> Void in
            self.testUploadMultipart(testCase: userInfo?[kXCTestCaseKey] as! XCTestCase, partNumber: 0, isLastPart: false)
        }

        Then("^upload the first part status code is (\\d+)$") { (args, userInfo) -> Void in
            self.assertEqual(value: "\(self.uploadMultipartResponse.statusCode)", shouldBe: "\(args![0])")
        }

        When("^upload the second part$") { (args, userInfo) -> Void in
            self.testUploadMultipart(testCase: userInfo?[kXCTestCaseKey] as! XCTestCase, partNumber: 1, isLastPart: false)
        }

        Then("^upload the second part status code is (\\d+)$") { (args, userInfo) -> Void in
            self.assertEqual(value: "\(self.uploadMultipartResponse.statusCode)", shouldBe: "\(args![0])")
        }

        When("^upload the third part$") { (args, userInfo) -> Void in
            self.testUploadMultipart(testCase: userInfo?[kXCTestCaseKey] as! XCTestCase, partNumber: 2, isLastPart: true)
        }

        Then("^upload the third part status code is (\\d+)$") { (args, userInfo) -> Void in
            self.assertEqual(value: "\(self.uploadMultipartResponse.statusCode)", shouldBe: "\(args![0])")
        }

        When("^list multipart$") { (args, userInfo) -> Void in
            self.testListMultipart(testCase: userInfo?[kXCTestCaseKey] as! XCTestCase)
        }

        Then("^list multipart status code is (\\d+)$") { (args, userInfo) -> Void in
            self.assertEqual(value: "\(self.listMultipartResponse.statusCode)", shouldBe: "\(args![0])")
        }

        And("^list multipart object parts count is (\\d+)$") { (args, userInfo) -> Void in
            self.assertEqual(value: "\(self.listMultipartResponse.output.objectParts!.count)", shouldBe: "\(args![0])")
        }

        When("^complete multipart upload$") { (args, userInfo) -> Void in
            self.testCompleteMultipartUpload(testCase: userInfo?[kXCTestCaseKey] as! XCTestCase)
        }

        Then("^complete multipart upload status code is (\\d+)$") { (args, userInfo) -> Void in
            self.assertEqual(value: "\(self.completeMultipartUploadResponse.statusCode)", shouldBe: "\(args![0])")
        }

        When("^abort multipart upload$") { (args, userInfo) -> Void in
            self.testAbortMultipartUpload(testCase: userInfo?[kXCTestCaseKey] as! XCTestCase, isFalse: true)
        }

        Then("^abort multipart upload status code is (\\d+)$") { (args, userInfo) -> Void in
            self.assertEqual(value: "\(self.abortMultipartUploadResponse.statusCode)", shouldBe: "\(args![0])")
        }

        When("^delete the multipart object$") { (args, userInfo) -> Void in
            self.testDeleteMultipartObject(testCase: userInfo?[kXCTestCaseKey] as! XCTestCase)
        }

        Then("^delete the multipart object status code is (\\d+)$") { (args, userInfo) -> Void in
            self.assertEqual(value: "\(self.deleteTheMultipartObjectResponse.statusCode)", shouldBe: "\(args![0])")
        }
    }

    func testInitiateMultipartUpload(testCase: XCTestCase) {
        let expectation = testCase.expectation(description: "")

        let input = InitiateMultipartUploadInput()
        bucket.initiateMultipartUpload(objectKey: self.objectKey, input: input) { response, error in
            if let response = response {
                self.initiateMultipartUploadResponse = response

                if response.output.errMessage == nil {
                    print("success: \(response.output.toJSON())")
                }
            }

            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.4) {
                expectation.fulfill()
            }

            XCTAssertNotNil(response, "error: \(error!)")
            XCTAssertEqual(response?.output.errMessage, nil, "statusCode: \(response!.statusCode)    error: \(response!.output.errMessage!)")
        }

        testCase.waitForExpectations(timeout: timeout, handler: nil)
    }

    func testUploadMultipart(testCase: XCTestCase, partNumber: Int, isLastPart: Bool) {
        let expectation = testCase.expectation(description: "")

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
        bucket.uploadMultipart(objectKey: self.objectKey, input: input) { response, error in
            if let response = response {
                self.uploadMultipartResponse = response

                if response.output.errMessage == nil {
                    print("success: \(response.output.toJSON())")
                }
            }

            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.4) {
                expectation.fulfill()
            }

            XCTAssertNotNil(response, "error: \(error!)")
            XCTAssertEqual(response?.output.errMessage, nil, "statusCode: \(response!.statusCode)    error: \(response!.output.errMessage!)")
        }

        fileHandle.closeFile()
        testCase.waitForExpectations(timeout: self.uploadFileTimeout, handler: nil)
    }

    func testListMultipart(testCase: XCTestCase) {
        let expectation = testCase.expectation(description: "")

        let input = ListMultipartInput(uploadID: self.initiateMultipartUploadResponse.output.uploadID!)
        bucket.listMultipart(objectKey: self.objectKey, input: input) { response, error in
            if let response = response {
                self.listMultipartResponse = response

                if response.output.errMessage == nil {
                    print("success: \(response.output.toJSON())")
                }
            }

            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.4) {
                expectation.fulfill()
            }

            XCTAssertNotNil(response, "error: \(error!)")
            XCTAssertEqual(response?.output.errMessage, nil, "statusCode: \(response!.statusCode)    error: \(response!.output.errMessage!)")
        }

        testCase.waitForExpectations(timeout: timeout, handler: nil)
    }

    func testCompleteMultipartUpload(testCase: XCTestCase) {
        let expectation = testCase.expectation(description: "")

        let input = CompleteMultipartUploadInput(uploadID: self.initiateMultipartUploadResponse.output.uploadID!,
                                                 objectParts: self.listMultipartResponse.output.objectParts)
        bucket.completeMultipartUpload(objectKey: self.objectKey, input: input) { response, error in
            if let response = response {
                self.completeMultipartUploadResponse = response

                if response.output.errMessage == nil {
                    print("success: \(response.output.toJSON())")
                }
            }

            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.4) {
                expectation.fulfill()
            }

            XCTAssertNotNil(response, "error: \(error!)")
            XCTAssertEqual(response?.output.errMessage, nil, "statusCode: \(response!.statusCode)    error: \(response!.output.errMessage!)")
        }

        testCase.waitForExpectations(timeout: timeout, handler: nil)
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
        let expectation = testCase.expectation(description: "")

        bucket.deleteObject(objectKey: self.objectKey) { response, error in
            if let response = response {
                self.deleteTheMultipartObjectResponse = response

                if response.output.errMessage == nil {
                    print("success: \(response.output.toJSON())")
                }
            }

            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.4) {
                expectation.fulfill()
            }

            XCTAssertNotNil(response, "error: \(error!)")
            XCTAssertEqual(response?.output.errMessage, nil, "statusCode: \(response!.statusCode)    error: \(response!.output.errMessage!)")
        }

        testCase.waitForExpectations(timeout: timeout, handler: nil)
    }

    override class func setup() {
        ObjectMultipartTests().setup()
    }
}
