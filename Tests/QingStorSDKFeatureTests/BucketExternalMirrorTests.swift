//
//  BucketExternalMirrorTests.swift
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

class BucketExternalMirrorTests: QingStorTests {
    var bucket: Bucket!

    var putExternalMirrorResponse: Response<PutBucketExternalMirrorOutput>!
    var getExternalMirrorResponse: Response<GetBucketExternalMirrorOutput>!
    var deleteExternalMirrorResponse: Response<DeleteBucketExternalMirrorOutput>!

    override func setup() {
        super.setup()

        bucket = qsService.bucket(bucketName: bucketName)
    }

    override func setupFeature() {
        When("^put bucket external mirror:$") { (args, userInfo) -> Void in
            self.testPutExternalMirror(testCase: userInfo?[kXCTestCaseKey] as! XCTestCase,
                                       json: userInfo?[kDocStringKey] as! String)
        }

        Then("^put bucket external mirror status code is (\\d+)$") { (args, userInfo) -> Void in
            self.assertEqual(value: "\(self.putExternalMirrorResponse.statusCode)", shouldBe: "\(args![0])")
        }

        When("^get bucket external mirror$") { (args, userInfo) -> Void in
            self.testGetExternalMirror(testCase: userInfo?[kXCTestCaseKey] as! XCTestCase)
        }

        Then("^get bucket external mirror status code is (\\d+)$") { (args, userInfo) -> Void in
            self.assertEqual(value: "\(self.getExternalMirrorResponse.statusCode)", shouldBe: "\(args![0])")
        }

        And("^get bucket external mirror should have source_site \"([^\"]*)\"$") { (args, userInfo) -> Void in
            self.assertEqual(value: self.getExternalMirrorResponse.output.sourceSite!, shouldBe: args![0])
        }

        When("^delete bucket external mirror$") { (args, userInfo) -> Void in
            self.testDeleteExternalMirror(testCase: userInfo?[kXCTestCaseKey] as! XCTestCase)
        }

        Then("^delete bucket external mirror status code is (\\d+)$") { (args, userInfo) -> Void in
            self.assertEqual(value: "\(self.deleteExternalMirrorResponse.statusCode)", shouldBe: "\(args![0])")
        }
    }

    func testPutExternalMirror(testCase: XCTestCase, json: String) {
        let request: (@escaping RequestCompletion<PutBucketExternalMirrorOutput>) -> Void = { completion in
            let input = Mapper<PutBucketExternalMirrorInput>().map(JSONString: json)!
            self.bucket.putExternalMirror(input: input, completion: completion)
        }

        self.assertReqeust(testCase: testCase, request: request) { response, error in
            self.putExternalMirrorResponse = response!
        }
    }

    func testGetExternalMirror(testCase: XCTestCase) {
        let request: (@escaping RequestCompletion<GetBucketExternalMirrorOutput>) -> Void = { completion in
            self.bucket.getExternalMirror(completion: completion)
        }

        self.assertReqeust(testCase: testCase, request: request) { response, error in
            self.getExternalMirrorResponse = response!
        }
    }

    func testDeleteExternalMirror(testCase: XCTestCase) {
        let request: (@escaping RequestCompletion<DeleteBucketExternalMirrorOutput>) -> Void = { completion in
            self.bucket.deleteExternalMirror(completion: completion)
        }

        self.assertReqeust(testCase: testCase, request: request) { response, error in
            self.deleteExternalMirrorResponse = response!
        }
    }

    override class func setup() {
        BucketExternalMirrorTests().setup()
    }
}
