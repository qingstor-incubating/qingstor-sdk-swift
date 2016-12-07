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
    let timeout = 30.0
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

        qsService = QingStor(context: context, zone: currentZone)

        setupFeature()
    }

    func setupFeature() {
        When("^initialize QingStor service$") { (args, userInfo) -> Void in

        }

        Then("^the QingStor service is initialized") { (args, userInfo) -> Void in
            XCTAssertNotNil(self.qsService, "QingStor service is not initialized")
        }

        When("^list buckets$") { (args, userInfo) -> Void in
            self.testListBuckets(testCase: userInfo?[kXCTestCaseKey] as! XCTestCase)
        }

        Then("^list buckets status code is (\\d+)$") { (args, userInfo) -> Void in
            self.assertEqual(value: "\(self.listBucketResponse.statusCode)", shouldBe: "\(args![0])")
        }
    }

    func testListBuckets(testCase: XCTestCase) {
        let expectation = testCase.expectation(description: "")

        let input = ListBucketsInput()
        qsService.listBuckets(input: input) { response, error in
            if let response = response {
                self.listBucketResponse = response

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

        testCase.waitForExpectations(timeout: timeout)
    }

    func assertEqual<T: Equatable>(value: T, shouldBe: T) {
        XCTAssertEqual(value, shouldBe, "Value \"\(value)\" should be \"\(shouldBe)\"")
    }

    class func setup() {
        QingStorTests().setup()
    }
}
