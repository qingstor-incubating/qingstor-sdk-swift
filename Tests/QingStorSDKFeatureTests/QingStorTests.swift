//
//  QingStorTests.swift
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

typealias Complete = () -> Void

class QingStorTests: NSObject {
    var timeout = 90.0
    var context: APIContext!
    var currentZone: String!
    var bucketName: String!

    var qsService: QingStor!

    var listBucketResponse: Response<ListBucketsOutput>!

    func setup() {
        let bundle = Bundle(for: QingStorTests.self)
        let configPath = bundle.path(forResource: "config", ofType: "plist")!
        let configURL = URL(fileURLWithPath: configPath)
        context = try! APIContext(plist: configURL)

        let testConfigPath = bundle.path(forResource: "test_config", ofType: "plist")!
        let testConfigURL = URL(fileURLWithPath: testConfigPath)
        let testConfig = NSDictionary(contentsOf: testConfigURL) as! Dictionary<String, String>

        currentZone = testConfig["zone"]
        bucketName = testConfig["bucket_name"]

        let qingstorSigner = QingStorSigner()
        let signer = CustomizedSigner {
            switch $0.signatureType {
            case let .query(timeoutSeconds):
                try $3(qingstorSigner.querySignatureString(from: $2, timeoutSeconds: timeoutSeconds))
            case .header:
                try $3(qingstorSigner.headerSignatureString(from: $2))
            }
        }

        qsService = QingStor(context: context, signer: signer)

        setupFeature()
    }

    func setupFeature() {
        When("^initialize QingStor service$") { (_, _) -> Void in

        }

        Then("^the QingStor service is initialized$") { (_, _) -> Void in
            XCTAssertNotNil(self.qsService, "QingStor service is not initialized")
        }

        When("^list buckets$") { (_, userInfo) -> Void in
            self.testListBuckets(testCase: userInfo?[kXCTestCaseKey] as! XCTestCase)
        }

        Then("^list buckets status code is (\\d+)$") { (args, _) -> Void in
            self.assertEqual(value: "\(self.listBucketResponse.statusCode)", shouldBe: "\(args![0])")
        }
    }

    func testListBuckets(testCase: XCTestCase) {
        let request: (@escaping RequestCompletion<ListBucketsOutput>) -> Void = { completion in
            let input = ListBucketsInput()
            self.qsService.listBuckets(input: input, completion: completion)
        }

        self.assertReqeust(testCase: testCase, request: request) { response, _ in
            self.listBucketResponse = response!
        }
    }

    func assertEqual<T: Equatable>(value: T, shouldBe: T) {
        XCTAssertEqual(value, shouldBe, "Value \"\(value)\" should be \"\(shouldBe)\"")
    }

    func assertReqeust<T: QingStorOutput>(testCase: XCTestCase, request: @escaping (@escaping RequestCompletion<T>) -> Void) {
        self.assertReqeust(testCase: testCase, request: request) { _, _ in }
    }

    func assertReqeust<T: QingStorOutput>(testCase: XCTestCase, request: @escaping (@escaping RequestCompletion<T>) -> Void, completion: @escaping RequestCompletion<T>) {
        let expectation = testCase.expectation(description: "")

        request { response, error in
            if let response = response {
                if response.output.errMessage == nil {
                    print("success: \(response.output.toJSON())")
                } else {
                    print("failure: \(response.output.errMessage!), statusCode: \(response.statusCode), code: \(response.output.code!)")
                }

                print("request-id: \(String(describing: response.output.requestId))")
            }

            XCTAssertNotNil(response, "error: \(error!)")
            XCTAssertNil(response?.output.errMessage, "statusCode: \(response!.statusCode)    errorCore: \(response!.output.code!)")

            completion(response, error)

            expectation.fulfill()
        }

        testCase.waitForExpectations(timeout: timeout, handler: nil)
    }

    class func setup() {
        QingStorTests().setup()
    }
}
