import XCTest
import Cucumberish
import QingStorSDK
import ObjectMapper

class BucketNotificationTests: QingStorTests {
    var bucket: Bucket!

    var putNotificationResponse: Response<PutBucketNotificationOutput>!
    var getNotificationResponse: Response<GetBucketNotificationOutput>!
    var deleteNotificationResponse: Response<DeleteBucketNotificationOutput>!

    override func setup() {
        super.setup()

        bucket = qsService.bucket(bucketName: bucketName, zone: currentZone)
    }

    override func setupFeature() {
        When("^put bucket notification:$") { (_, userInfo) -> Void in
            self.testPutNotification(testCase: userInfo?[kXCTestCaseKey] as! XCTestCase,
                             json: userInfo?[kDocStringKey] as! String)
        }

        Then("^put bucket notification status code is (\\d+)$") { (args, _) -> Void in
            self.assertEqual(value: "\(self.putNotificationResponse.statusCode)", shouldBe: "\(args![0])")
        }

        When("^get bucket notification$") { (_, userInfo) -> Void in
            self.testGetNotification(testCase: userInfo?[kXCTestCaseKey] as! XCTestCase)
        }

        Then("^get bucket notification status code is (\\d+)$") { (args, _) -> Void in
            self.assertEqual(value: "\(self.getNotificationResponse.statusCode)", shouldBe: "\(args![0])")
        }

        When("^delete bucket notification") { (_, userInfo) -> Void in
            self.testDeleteNotification(testCase: userInfo?[kXCTestCaseKey] as! XCTestCase)
        }

        Then("^delete bucket notification status code is (\\d+)$") { (args, _) -> Void in
            self.assertEqual(value: "\(self.deleteNotificationResponse.statusCode)", shouldBe: "\(args![0])")
        }
    }

    func testPutNotification(testCase: XCTestCase, json: String) {
        let request: (@escaping RequestCompletion<PutBucketNotificationOutput>) -> Void = { completion in
            let input = Mapper<PutBucketNotificationInput>().map(JSONString: json)!
            self.bucket.putNotification(input: input, completion: completion)
        }

        self.assertReqeust(testCase: testCase, request: request) { response, _ in
            self.putNotificationResponse = response!
        }
    }

    func testGetNotification(testCase: XCTestCase) {
        let request: (@escaping RequestCompletion<GetBucketNotificationOutput>) -> Void = { completion in
            self.bucket.getNotification(completion: completion)
        }

        self.assertReqeust(testCase: testCase, request: request) { response, _ in
            self.getNotificationResponse = response!
        }
    }

    func testDeleteNotification(testCase: XCTestCase) {
        let request: (@escaping RequestCompletion<DeleteBucketNotificationOutput>) -> Void = { completion in
            self.bucket.deleteNotification(completion: completion)
        }

        self.assertReqeust(testCase: testCase, request: request) { response, _ in
            self.deleteNotificationResponse = response!
        }
    }

    override class func setup() {
        BucketNotificationTests().setup()
    }
