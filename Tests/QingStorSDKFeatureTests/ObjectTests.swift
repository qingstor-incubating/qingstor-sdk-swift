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
    var getObjectWithContentTypeResponse: Response<GetObjectOutput>!
    var headObjectResponse: Response<HeadObjectOutput>!
    var optionsObjectResponse: Response<OptionsObjectOutput>!
    var deleteObjectResponse: Response<DeleteObjectOutput>!
    var deleteTheMoveObjectResponse: Response<DeleteObjectOutput>!

    var saveURL: URL!
    var downloadedURL: URL!

    let contentLength = 200

    override func setup() {
        super.setup()

        timeout = 999999.9
        saveURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0].appendingPathComponent("save-object")

        bucket = qsService.bucket(bucketName: bucketName)
    }

    override func setupFeature() {
        When("^put object with key \"(.{1,})\"$") { (args, userInfo) -> Void in
            self.objectKey = args![0]
            self.testPutObject(testCase: userInfo?[kXCTestCaseKey] as! XCTestCase)
        }

        Then("^put object status code is (\\d+)$") { (args, userInfo) -> Void in
            self.assertEqual(value: "\(self.putObjectResponse.statusCode)", shouldBe: "\(args![0])")
        }

        When("^copy object with key \"(.{1,})\"$") { (args, userInfo) -> Void in
            self.copyObjectKey = "\(args![0])_copy"
            self.testCopyObject(testCase: userInfo?[kXCTestCaseKey] as! XCTestCase)
        }

        Then("^copy object status code is (\\d+)$") { (args, userInfo) -> Void in
            self.assertEqual(value: "\(self.putTheCopyObjectResponse.statusCode)", shouldBe: "\(args![0])")
        }

        When("^move object with key \"(.{1,})\"$") { (args, userInfo) -> Void in
            self.moveObjectKey = "\(args![0])_move"
            self.testMoveObject(testCase: userInfo?[kXCTestCaseKey] as! XCTestCase)
        }

        Then("^move object status code is (\\d+)$") { (args, userInfo) -> Void in
            self.assertEqual(value: "\(self.putTheMoveObjectResponse.statusCode)", shouldBe: "\(args![0])")
        }

        When("^get object with key \"(.{1,})\"$") { (args, userInfo) -> Void in
            self.objectKey = args![0]
            self.testGetObject(testCase: userInfo?[kXCTestCaseKey] as! XCTestCase)
        }

        Then("^get object status code is (\\d+)$") { (args, userInfo) -> Void in
            self.assertEqual(value: "\(self.getObjectResponse.statusCode)", shouldBe: "\(args![0])")
        }

        And("^get object content length is (\\d+)$") { (args, userInfo) -> Void in
            self.assertEqual(value: "\(self.contentLength)", shouldBe: "\(self.saveURL.contentLength)")
        }

        When("^get object \"(.{1,})\" with content type \"(.{1,})\"$") { (args, userInfo) -> Void in
            self.objectKey = args![0]
            self.testGetObjectWithContentType(testCase: userInfo?[kXCTestCaseKey] as! XCTestCase, contentType: args![1])
        }

        Then("^get object content type is \"(.{1,})\"$") { (args, userInfo) -> Void in
            self.assertEqual(value: "\(self.getObjectWithContentTypeResponse.rawResponse.allHeaderFields["Content-Type"]!)", shouldBe: "\(args![0])")
        }

        When("^get object \"(.{1,})\" with query signature$") { (args, userInfo) -> Void in
            self.objectKey = args![0]
            self.testGetObjectWithQuerySignature(testCase: userInfo?[kXCTestCaseKey] as! XCTestCase)
        }

        Then("^get object with query signature content length is (\\d+)$") { (args, userInfo) -> Void in
            self.assertEqual(value: "\(self.contentLength)", shouldBe: "\(self.downloadedURL.contentLength)")
        }

        When("^head object with key \"(.{1,})\"$") { (args, userInfo) -> Void in
            self.objectKey = args![0]
            self.testHeadObject(testCase: userInfo?[kXCTestCaseKey] as! XCTestCase)
        }

        Then("^head object status code is (\\d+)$") { (args, userInfo) -> Void in
            self.assertEqual(value: "\(self.headObjectResponse.statusCode)", shouldBe: "\(args![0])")
        }

        When("^options object \"(.{1,})\" with method \"([^\"]*)\" and origin \"([^\"]*)\"") { (args, userInfo) -> Void in
            self.objectKey = args![0]
            self.testOptionsObject(testCase: userInfo?[kXCTestCaseKey] as! XCTestCase, method: args![0], origin: args![1])
        }

        Then("^options object status code is (\\d+)$") { (args, userInfo) -> Void in
            self.assertEqual(value: "\(self.optionsObjectResponse.statusCode)", shouldBe: "\(args![0])")
        }

        When("^delete object with key \"(.{1,})\"$") { (args, userInfo) -> Void in
            self.objectKey = args![0]
            self.testDeleteObject(testCase: userInfo?[kXCTestCaseKey] as! XCTestCase)
        }

        Then("^delete object status code is (\\d+)$") { (args, userInfo) -> Void in
            self.assertEqual(value: "\(self.deleteObjectResponse.statusCode)", shouldBe: "\(args![0])")
        }

        When("^delete the move object with key \"(.{1,})\"$") { (args, userInfo) -> Void in
            self.moveObjectKey = "\(args![0])_move"
            self.testDeleteMoveObject(testCase: userInfo?[kXCTestCaseKey] as! XCTestCase)
        }

        Then("^delete the move object status code is (\\d+)$") { (args, userInfo) -> Void in
            self.assertEqual(value: "\(self.deleteTheMoveObjectResponse.statusCode)", shouldBe: "\(args![0])")
        }
    }

    func testPutObject(testCase: XCTestCase) {
        let request: (@escaping RequestCompletion<PutObjectOutput>) -> Void = { completion in
            let input = PutObjectInput(contentLength: self.contentLength, bodyInputStream: self.generateObjectContent())
            self.bucket.putObject(objectKey: self.objectKey, input: input, completion: completion)
        }

        self.assertReqeust(testCase: testCase, request: request) { response, error in
            self.putObjectResponse = response!
        }
    }

    func testCopyObject(testCase: XCTestCase) {
        let request: (@escaping RequestCompletion<PutObjectOutput>) -> Void = { completion in
            let copySource = "/\(self.bucket.bucketName!)/\(self.objectKey!)"
            let input = PutObjectInput(contentLength: self.contentLength, xQSCopySource: copySource)
            print("copy input: \(input.toJSON())")
            self.bucket.putObject(objectKey: self.copyObjectKey, input: input, completion: completion)
        }

        self.assertReqeust(testCase: testCase, request: request) { response, error in
            self.putTheCopyObjectResponse = response!
        }
    }

    func testMoveObject(testCase: XCTestCase) {
        let request: (@escaping RequestCompletion<PutObjectOutput>) -> Void = { completion in
            let moveSource = "/\(self.bucket.bucketName!)/\(self.copyObjectKey!)"
            let input = PutObjectInput(contentLength: self.contentLength, xQSMoveSource: moveSource)
            self.bucket.putObject(objectKey: self.moveObjectKey, input: input, completion: completion)
        }

        self.assertReqeust(testCase: testCase, request: request) { response, error in
            self.putTheMoveObjectResponse = response!
        }
    }

    func testGetObject(testCase: XCTestCase) {
        let request: (@escaping RequestCompletion<GetObjectOutput>) -> Void = { completion in
            let input = GetObjectInput()
            input.destinationURL = self.saveURL
            self.bucket.getObject(objectKey: self.objectKey, input: input, completion: completion)
        }

        self.assertReqeust(testCase: testCase, request: request) { response, error in
            self.getObjectResponse = response!
        }
    }

    func testGetObjectWithQuerySignature(testCase: XCTestCase) {
        let expectation = testCase.expectation(description: "")

        let input = GetObjectInput()
        input.signatureType = .query(timeoutSeconds: 60)

        let (sender, _) = bucket.getObjectSender(objectKey: self.objectKey, input: input)
        sender?.buildRequest { request, error in
            URLSession.shared.downloadTask(with: request!) { url, response, error in
                self.downloadedURL = url

                DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.4) {
                    expectation.fulfill()
                }

                XCTAssertNil(error, "error: \(error!)")
            }.resume()
        }

        testCase.waitForExpectations(timeout: timeout, handler: nil)
    }

    func testGetObjectWithContentType(testCase: XCTestCase, contentType: String) {
        let request: (@escaping RequestCompletion<GetObjectOutput>) -> Void = { completion in
            let input = GetObjectInput()
            input.responseContentType = contentType
            self.bucket.getObject(objectKey: self.objectKey, input: input, completion: completion)
        }

        self.assertReqeust(testCase: testCase, request: request) { response, error in
            self.getObjectWithContentTypeResponse = response!
        }
    }

    func testHeadObject(testCase: XCTestCase) {
        let request: (@escaping RequestCompletion<HeadObjectOutput>) -> Void = { completion in
            let input = HeadObjectInput()
            self.bucket.headObject(objectKey: self.objectKey, input: input, completion: completion)
        }

        self.assertReqeust(testCase: testCase, request: request) { response, error in
            self.headObjectResponse = response!
            print("object content length: \(String(describing: self.headObjectResponse.output.contentLength))")
        }
    }

    func testOptionsObject(testCase: XCTestCase, method: String, origin: String) {
        let request: (@escaping RequestCompletion<OptionsObjectOutput>) -> Void = { completion in
            let input = OptionsObjectInput(accessControlRequestMethod: method, origin: origin)
            self.bucket.optionsObject(objectKey: self.objectKey, input: input, completion: completion)
        }

        self.assertReqeust(testCase: testCase, request: request) { response, error in
            self.optionsObjectResponse = response!
        }
    }

    func testDeleteObject(testCase: XCTestCase) {
        let request: (@escaping RequestCompletion<DeleteObjectOutput>) -> Void = { completion in
            self.bucket.deleteObject(objectKey: self.objectKey, completion: completion)
        }

        self.assertReqeust(testCase: testCase, request: request) { response, error in
            self.deleteObjectResponse = response!
        }
    }

    func testDeleteMoveObject(testCase: XCTestCase) {
        let request: (@escaping RequestCompletion<DeleteObjectOutput>) -> Void = { completion in
            self.bucket.deleteObject(objectKey: self.moveObjectKey, completion: completion)
        }

        self.assertReqeust(testCase: testCase, request: request) { response, error in
            self.deleteTheMoveObjectResponse = response!
        }
    }

    func generateRandomString(length: Int) -> String {
        var content = ""
        for _ in 0..<length {
            let randomNumber = arc4random() % 26 + 97
            let randomChar = Character(UnicodeScalar(randomNumber)!)
            content.append(randomChar)
        }

        return content
    }

    func generateObjectContent() -> InputStream {
        let contentData = self.generateRandomString(length: contentLength).data(using: String.Encoding.utf8)
        return InputStream(data: contentData!)
    }

    override class func setup() {
        ObjectTests().setup()
    }
}
