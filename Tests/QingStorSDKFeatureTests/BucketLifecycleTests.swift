import XCTest
import Cucumberish
import QingStorSDK
import ObjectMapper

class BucketLifecycleTests: QingStorTests {
    var bucket: Bucket!

    var putLifecycleResponse: Response<PutBucketLifecycleOutput>!
    var getLifecycleResponse: Response<GetBucketLifecycleOutput>!
    var deleteLifecycleResponse: Response<DeleteBucketLifecycleOutput>!

    override func setup() {
        super.setup()

        bucket = qsService.bucket(bucketName: bucketName, zone: currentZone)
    }

    override func setupFeature() {
        When("^put bucket lifecycle:$") { (_, userInfo) -> Void in
            self.testPutLifecycle(testCase: userInfo?[kXCTestCaseKey] as! XCTestCase,
                             json: userInfo?[kDocStringKey] as! String)
        }

        Then("^put bucket lifecycle status code is (\\d+)$") { (args, _) -> Void in
            self.assertEqual(value: "\(self.putLifecycleResponse.statusCode)", shouldBe: "\(args![0])")
        }

        When("^get bucket lifecycle$") { (_, userInfo) -> Void in
            self.testGetLifecycle(testCase: userInfo?[kXCTestCaseKey] as! XCTestCase)
        }

        Then("^get bucket lifecycle status code is (\\d+)$") { (args, _) -> Void in
            self.assertEqual(value: "\(self.getLifecycleResponse.statusCode)", shouldBe: "\(args![0])")
        }

        When("^delete bucket lifecycle") { (_, userInfo) -> Void in
            self.testDeleteLifecycle(testCase: userInfo?[kXCTestCaseKey] as! XCTestCase)
        }

        Then("^delete bucket Lifecycle status code is (\\d+)$") { (args, _) -> Void in
            self.assertEqual(value: "\(self.deleteLifecycleResponse.statusCode)", shouldBe: "\(args![0])")
        }
    }

    func testPutLifecycle(testCase: XCTestCase, json: String) {
        let request: (@escaping RequestCompletion<PutBucketLifecycleOutput>) -> Void = { completion in
            let input = Mapper<PutBucketLifecycleInput>().map(JSONString: json)!
            self.bucket.putLifecycle(input: input, completion: completion)
        }

        self.assertReqeust(testCase: testCase, request: request) { response, _ in
            self.putLifecycleResponse = response!
        }
    }

    func testGetLifecycle(testCase: XCTestCase) {
        let request: (@escaping RequestCompletion<GetBucketLifecycleOutput>) -> Void = { completion in
            self.bucket.getLifecycle(completion: completion)
        }

        self.assertReqeust(testCase: testCase, request: request) { response, _ in
            self.getLifecycleResponse = response!
        }
    }

    func testDeleteLifecycle(testCase: XCTestCase) {
        let request: (@escaping RequestCompletion<DeleteBucketLifecycleOutput>) -> Void = { completion in
            self.bucket.deleteLifecycle(completion: completion)
        }

        self.assertReqeust(testCase: testCase, request: request) { response, _ in
            self.deleteLifecycleResponse = response!
        }
    }

    override class func setup() {
        BucketLifecycleTests().setup()
    }
}
