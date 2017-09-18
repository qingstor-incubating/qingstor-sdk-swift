//
//  ImageTests.swift
//
// +-------------------------------------------------------------------------
// | Copyright (C) 2017 Yunify, Inc.
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

class ImageTests: QingStorTests {

    let testImageObjectKey = "test-image-process.jpg"
    var uploadedTestImage = false

    var bucket: Bucket!

    var imageProcessAction: String = ""
    var imageProcessResponse: Response<ImageProcessOutput>!
    
    var processedImageURL: URL!

    lazy var testImagePath: String = {
        return Bundle(for: ImageTests.self).path(forResource: "Features/fixtures/test.jpg", ofType: nil)!
    }()

    lazy var testImageURL: URL = {
        return URL(fileURLWithPath: self.testImagePath)
    }()

    override func setup() {
        super.setup()

        timeout = 999999.9
        processedImageURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0].appendingPathComponent("processed-image")
        bucket = qsService.bucket(bucketName: bucketName, zone: currentZone)
    }

    override func setupFeature() {
        When("^image process with key \"(.{1,})\" and query \"(.{1,})\"$") { (args, userInfo) -> Void in
            self.testImageProcess(testCase: userInfo?[kXCTestCaseKey] as! XCTestCase, key: args![0], query: args![1])
        }

        Then("^image process status code is (\\d+)$") { (args, userInfo) -> Void in
            self.assertEqual(value: "\(self.imageProcessResponse.statusCode)", shouldBe: "\(args![0])")

            let processedImageObjectKey = "test-image-process_\(self.imageProcessAction).jpg"
            self.putImage(testCase: userInfo?[kXCTestCaseKey] as! XCTestCase, objectKey: processedImageObjectKey, url: self.processedImageURL)
        }
    }

    func testImageProcess(testCase: XCTestCase, key: String, query: String) {
        if !uploadedTestImage {
            putImage(testCase: testCase, objectKey: testImageObjectKey, url: testImageURL)
            uploadedTestImage = true
        }

        imageProcessAction = query
        let request: (@escaping RequestCompletion<ImageProcessOutput>) -> Void = { completion in
            let input = ImageProcessInput(action: query)
            input.destinationURL = self.processedImageURL
            self.bucket.imageProcess(objectKey: self.testImageObjectKey, input: input, completion: completion)
        }

        self.assertReqeust(testCase: testCase, request: request) { response, _ in
            self.imageProcessResponse = response!
        }
    }

    func putImage(testCase: XCTestCase, objectKey: String, url: URL) {
        let request: (@escaping RequestCompletion<PutObjectOutput>) -> Void = { completion in
            let input = PutObjectInput(contentLength: url.contentLength, contentType: self.testImageURL.mimeType, bodyInputStream: InputStream(url: url))
            self.bucket.putObject(objectKey: objectKey, input: input, completion: completion)
        }

        self.assertReqeust(testCase: testCase, request: request) { _, _ in }
    }

    override class func setup() {
        ImageTests().setup()
    }
}
