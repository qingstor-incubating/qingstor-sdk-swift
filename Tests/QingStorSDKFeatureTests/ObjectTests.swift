//
//  ObjectTests.swift
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

class ObjectTests: QingStorTests {
    var bucket: Bucket!

    var objectKey: String!
    var copyObjectKey: String!
    var moveObjectKey: String!

    var putObjectResponse: Response<PutObjectOutput>!
    var putTheCopyObjectResponse: Response<PutObjectOutput>!
    var putTheMoveObjectResponse: Response<PutObjectOutput>!
    var getObjectResponse: Response<GetObjectOutput>!
    var headObjectResponse: Response<HeadObjectOutput>!
    var optionsObjectResponse: Response<OptionsObjectOutput>!
    var deleteObjectResponse: Response<DeleteObjectOutput>!
    var deleteTheMoveObjectResponse: Response<DeleteObjectOutput>!

    var objectFileURL: URL!
    var saveURL: URL!

    let partContentLength = 4 * 1024 * 1024
    var uploadFileTimeout = 999999.9

    override func setup() {
        super.setup()

        let bundle = Bundle(for: QingStorTests.self)
        objectFileURL = URL(fileURLWithPath: bundle.path(forResource: "config", ofType: "plist")!)
        saveURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0].appendingPathComponent("save-object")

        bucket = qsService.bucket(bucketName: bucketName)
    }

    override func setupFeature() {
        When("^put object with key \"([^\"]*)\"$") { (args, userInfo) -> Void in
            self.objectKey = args![0]
            self.testPutObject(testCase: userInfo?[kXCTestCaseKey] as! XCTestCase)
        }

        Then("^put object status code is (\\d+)$") { (args, userInfo) -> Void in
            self.assertEqual(value: "\(self.putObjectResponse.statusCode)", shouldBe: "\(args![0])")
        }

        When("^copy object with key \"([^\"]*)\"$") { (args, userInfo) -> Void in
            self.copyObjectKey = args![0]
            self.testCopyObject(testCase: userInfo?[kXCTestCaseKey] as! XCTestCase)
        }

        Then("^copy object status code is (\\d+)$") { (args, userInfo) -> Void in
            self.assertEqual(value: "\(self.putTheCopyObjectResponse.statusCode)", shouldBe: "\(args![0])")
        }

        When("^move object with key \"([^\"]*)\"$") { (args, userInfo) -> Void in
            self.moveObjectKey = args![0]
            self.testMoveObject(testCase: userInfo?[kXCTestCaseKey] as! XCTestCase)
        }

        Then("^move object status code is (\\d+)$") { (args, userInfo) -> Void in
            self.assertEqual(value: "\(self.putTheMoveObjectResponse.statusCode)", shouldBe: "\(args![0])")
        }

        When("^get object$") { (args, userInfo) -> Void in
            self.testGetObject(testCase: userInfo?[kXCTestCaseKey] as! XCTestCase)
        }

        Then("^get object status code is (\\d+)$") { (args, userInfo) -> Void in
            self.assertEqual(value: "\(self.getObjectResponse.statusCode)", shouldBe: "\(args![0])")
        }

        And("^get object content length is (\\d+)$") { (args, userInfo) -> Void in

        }

        When("^get object with query signature$") { (args, userInfo) -> Void in
            self.testGetObjectWithQuerySignature(testCase: userInfo?[kXCTestCaseKey] as! XCTestCase)
        }

        Then("^get object with query signature content length is (\\d+)$") { (args, userInfo) -> Void in

        }

        When("^head object$") { (args, userInfo) -> Void in
            self.testHeadObject(testCase: userInfo?[kXCTestCaseKey] as! XCTestCase)
        }

        Then("^head object status code is (\\d+)$") { (args, userInfo) -> Void in
            self.assertEqual(value: "\(self.headObjectResponse.statusCode)", shouldBe: "\(args![0])")
        }

        When("^options object with method \"([^\"]*)\" and origin \"([^\"]*)\"$") { (args, userInfo) -> Void in
            self.testOptionsObject(testCase: userInfo?[kXCTestCaseKey] as! XCTestCase, method: args![0], origin: args![1])
        }

        Then("^options object status code is (\\d+)$") { (args, userInfo) -> Void in
            self.assertEqual(value: "\(self.optionsObjectResponse.statusCode)", shouldBe: "\(args![0])")
        }

        When("^delete object$") { (args, userInfo) -> Void in
            self.testDeleteObject(testCase: userInfo?[kXCTestCaseKey] as! XCTestCase)
        }

        Then("^delete object status code is (\\d+)$") { (args, userInfo) -> Void in
            self.assertEqual(value: "\(self.deleteObjectResponse.statusCode)", shouldBe: "\(args![0])")
        }

        When("^delete the move object$") { (args, userInfo) -> Void in
            self.testDeleteMoveObject(testCase: userInfo?[kXCTestCaseKey] as! XCTestCase)
        }

        Then("^delete the move object status code is (\\d+)$") { (args, userInfo) -> Void in
            self.assertEqual(value: "\(self.deleteTheMoveObjectResponse.statusCode)", shouldBe: "\(args![0])")
        }
    }

    func testPutObject(testCase: XCTestCase) {
        let expectation = testCase.expectation(description: "")

        let input = PutObjectInput(contentLength: self.objectFileURL.contentLength, bodyInputStream: InputStream(url: self.objectFileURL))
        bucket.putObject(objectKey: self.objectKey, input: input) { response, error in
            if let response = response {
                self.putObjectResponse = response

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

        testCase.waitForExpectations(timeout: self.uploadFileTimeout, handler: nil)
    }

    func testCopyObject(testCase: XCTestCase) {
        let expectation = testCase.expectation(description: "")

        let copySource = "/\(self.bucket.bucketName!)/\(self.objectKey!)"
        let input = PutObjectInput(contentLength: 0, xQSCopySource: copySource)
        bucket.putObject(objectKey: self.copyObjectKey, input: input) { response, error in
            if let response = response {
                self.putTheCopyObjectResponse = response

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

        testCase.waitForExpectations(timeout: self.timeout, handler: nil)
    }

    func testMoveObject(testCase: XCTestCase) {
        let expectation = testCase.expectation(description: "")

        let moveSource = "/\(self.bucket.bucketName!)/\(self.copyObjectKey!)"
        let input = PutObjectInput(contentLength: 0, xQSMoveSource: moveSource)
        bucket.putObject(objectKey: self.moveObjectKey, input: input) { response, error in
            if let response = response {
                self.putTheMoveObjectResponse = response

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

        testCase.waitForExpectations(timeout: self.timeout, handler: nil)
    }

    func testGetObject(testCase: XCTestCase) {
        let expectation = testCase.expectation(description: "")

        let input = GetObjectInput()
        input.destinationURL = self.saveURL
        bucket.getObject(objectKey: self.objectKey, input: input) { response, error in
            if let response = response {
                self.getObjectResponse = response

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

    func testGetObjectWithQuerySignature(testCase: XCTestCase) {
        let expectation = testCase.expectation(description: "")

        let input = GetObjectInput()
        input.signatureType = .query(timeoutSeconds: 60)

        let (sender, _) = bucket.getObjectSender(objectKey: self.objectKey, input: input)
        sender?.buildRequest { request, error in
            print("remote url: \(request?.url)")
            URLSession.shared.downloadTask(with: request!) { url, response, error in
                print("url: \(url)")

                DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.4) {
                    expectation.fulfill()
                }

                XCTAssertNil(error, "error: \(error)")
            }.resume()
        }

        testCase.waitForExpectations(timeout: timeout, handler: nil)
    }

    func testHeadObject(testCase: XCTestCase) {
        let expectation = testCase.expectation(description: "")

        let input = HeadObjectInput()
        bucket.headObject(objectKey: self.objectKey, input: input) { response, error in
            if let response = response {
                self.headObjectResponse = response

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

    func testOptionsObject(testCase: XCTestCase, method: String, origin: String) {
        let expectation = testCase.expectation(description: "")

        let input = OptionsObjectInput(accessControlRequestMethod: method, origin: origin)
        bucket.optionsObject(objectKey: self.objectKey, input: input) { response, error in
            if let response = response {
                self.optionsObjectResponse = response

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

    func testDeleteObject(testCase: XCTestCase) {
        let expectation = testCase.expectation(description: "")

        bucket.deleteObject(objectKey: self.objectKey) { response, error in
            if let response = response {
                self.deleteObjectResponse = response

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

    func testDeleteMoveObject(testCase: XCTestCase) {
        let expectation = testCase.expectation(description: "")

        bucket.deleteObject(objectKey: self.moveObjectKey) { response, error in
            if let response = response {
                self.deleteTheMoveObjectResponse = response

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
        ObjectTests().setup()
    }
}
