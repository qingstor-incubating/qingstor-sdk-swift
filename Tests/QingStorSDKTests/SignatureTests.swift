//
//  SignatureTests.swift
//  QingStorSDK
//
//  Created by Chris on 16/12/4.
//  Copyright © 2016年 Yunify. All rights reserved.
//

import XCTest
@testable import QingStorSDK

class SignatureTests: XCTestCase {

    override func setUp() {
        super.setUp()

        Registry.register(accessKeyID: "ACCESS_KEY_ID_EXAMPLE", secretAccessKey: "SECRET_ACCESS_KEY_EXAMPLE")
    }

    override func tearDown() {
        super.tearDown()
    }

    func testWriteHeaderSignature() throws {
        let expectation = self.expectation(description: "")

        let context = APIContext.qingStor()
        context.query = "acl&upload_id=fde133b5f6d932cd9c79bac3c7318da1&part_number=0&other=abc"

        let requestBuild = DefaultRequestBuilder(context: context, signer: QingStorSigner())
        requestBuild.addHeaders(["Date": String.RFC822(date: Date(timeIntervalSince1970: 0))])
        requestBuild.addHeaders(["X-QS-Test-1": "Test1", "X-QS-Test-2": "Test2"])
        requestBuild.buildRequest { request, error in
            XCTAssertNil(error)
            print("request: \(String(describing: request))")

            let signatureHeader = "QS ACCESS_KEY_ID_EXAMPLE:w62wOSlVbX1haMWiNBpfMM9J8pqn7XCPoUAgTVmgVsc="
            XCTAssertEqual(signatureHeader, requestBuild.headers["Authorization"])

            expectation.fulfill()
        }

        let signer = QingStorSigner()
        let signatureString = try signer.signatureString(from: requestBuild)
        XCTAssertEqual(signatureString, "w62wOSlVbX1haMWiNBpfMM9J8pqn7XCPoUAgTVmgVsc=")

        waitForExpectations(timeout: 99, handler: nil)
    }

    func testWriteQuerySignature() throws {
        let expectation = self.expectation(description: "")

        let context = APIContext.qingStor()
        context.query = "acl&upload_id=fde133b5f6d932cd9c79bac3c7318da1&part_number=0&other=abc"

        let signer = QingStorSigner()
        signer.signatureType = .query(timeoutSeconds: 500)
        let requestBuild = DefaultRequestBuilder(context: context, signer: signer)
        requestBuild.addHeaders(["Date": String.RFC822(date: Date(timeIntervalSince1970: 0))])
        requestBuild.addHeaders(["X-QS-Test-1": "Test1", "X-QS-Test-2": "Test2"])
        requestBuild.buildRequest { request, error in
            XCTAssertNil(error)
            print("request: \(String(describing: request))")

            let targetURL = "https://qingstor.com:443/?acl&upload_id=fde133b5f6d932cd9c79bac3c7318da1&part_number=0&other=abc&access_key_id=ACCESS_KEY_ID_EXAMPLE&expires=500&signature=GUiulUdgubQqvCaz/2olIJWIGVo2KC4fDfoARj0u6v4%3D"
            XCTAssertEqual(targetURL, (request?.url?.absoluteString)!)

            expectation.fulfill()
        }

        let signatureString = try signer.signatureString(from: requestBuild)
        XCTAssertEqual(signatureString, "GUiulUdgubQqvCaz/2olIJWIGVo2KC4fDfoARj0u6v4=")

        waitForExpectations(timeout: 99, handler: nil)
    }

    func testWriteNonASCIIHeaderSignature() throws {
        let expectation = self.expectation(description: "")

        let context = APIContext.qingStor()
        context.query = "acl&upload_id=fde133b5f6d932cd9c79bac3c7318da1&part_number=0&other=abc&response-content-disposition=测试中文"

        let requestBuild = DefaultRequestBuilder(context: context, signer: QingStorSigner())
        requestBuild.addHeaders(["Date": String.RFC822(date: Date(timeIntervalSince1970: 0))])
        requestBuild.addHeaders(["X-QS-Test-1": "Test1", "X-QS-Test-2": "Test2", "X-QS-Test-Chinese": "中文测试"])
        requestBuild.buildRequest { request, error in
            XCTAssertNil(error)
            print("request: \(String(describing: request))")

            let signatureHeader = "QS ACCESS_KEY_ID_EXAMPLE:yIcBDU7d0ybYLoaD63jd/SBubZj+FouRXxp1h98A7gM="
            XCTAssertEqual(signatureHeader, requestBuild.headers["Authorization"])

            expectation.fulfill()
        }

        let signer = QingStorSigner()
        let signatureString = try signer.signatureString(from: requestBuild)
        XCTAssertEqual(signatureString, "yIcBDU7d0ybYLoaD63jd/SBubZj+FouRXxp1h98A7gM=")

        waitForExpectations(timeout: 99, handler: nil)
    }

    func testWriteNonASCIIQuerySignature() throws {
        let expectation = self.expectation(description: "")

        let context = APIContext.qingStor()
        context.query = "acl&upload_id=fde133b5f6d932cd9c79bac3c7318da1&part_number=0&other=abc&response-content-disposition=测试中文"

        let signer = QingStorSigner()
        signer.signatureType = .query(timeoutSeconds: 500)
        let requestBuild = DefaultRequestBuilder(context: context, signer: signer)
        requestBuild.addHeaders(["Date": String.RFC822(date: Date(timeIntervalSince1970: 0))])
        requestBuild.addHeaders(["X-QS-Test-1": "Test1", "X-QS-Test-2": "Test2", "X-QS-Test-Chinese": "中文测试"])
        requestBuild.buildRequest { request, error in
            XCTAssertNil(error)
            print("request: \(String(describing: request))")

            let targetURL = "https://qingstor.com:443/?acl&upload_id=fde133b5f6d932cd9c79bac3c7318da1&part_number=0&other=abc&response-content-disposition=%E6%B5%8B%E8%AF%95%E4%B8%AD%E6%96%87&access_key_id=ACCESS_KEY_ID_EXAMPLE&expires=500&signature=E%2BI8HCqScZWWeNWwS%2BzEVRlTFZ8DO92OTN69dAdaFF4%3D"
            XCTAssertEqual(targetURL, (request?.url?.absoluteString)!)

            expectation.fulfill()
        }

        let signatureString = try signer.signatureString(from: requestBuild)
        XCTAssertEqual(signatureString, "E+I8HCqScZWWeNWwS+zEVRlTFZ8DO92OTN69dAdaFF4=")

        waitForExpectations(timeout: 99, handler: nil)
    }

    func testWriteQueryCustomizedSigner() throws {
        let expectation = self.expectation(description: "")

        let signer = CustomizedSigner { _, _, _, completion in
            DispatchQueue.global(qos: .background).asyncAfter(deadline: DispatchTime.now() + 1) {
                completion(self.fakeQuerySignatureResult())
            }
        }
        signer.signatureType = .query(timeoutSeconds: 500)

        let requestBuild = DefaultRequestBuilder(context: APIContext.qingStor(), signer: signer)
        requestBuild.addHeaders(["Date": String.RFC822(date: Date(timeIntervalSince1970: 0))])
        requestBuild.buildRequest { request, error in
            XCTAssertNil(error)
            print("request: \(String(describing: request))")

            let targetURL = "https://qingstor.com:443/?access_key_id=fake-query-access-key&expires=500&signature=fake-query-signature-string"
            XCTAssertEqual(targetURL, (request?.url?.absoluteString)!)

            expectation.fulfill()
        }

        waitForExpectations(timeout: 99, handler: nil)
    }

    func testWriteExpiresQueryCustomizedSigner() throws {
        let expectation = self.expectation(description: "")

        let signer = CustomizedSigner { _, _, _, completion in
            DispatchQueue.global(qos: .background).asyncAfter(deadline: DispatchTime.now() + 1) {
                completion(self.fakeQuerySignatureResult(expires: 999999))
            }
        }
        signer.signatureType = .query(timeoutSeconds: 500)

        let requestBuild = DefaultRequestBuilder(context: APIContext.qingStor(), signer: signer)
        requestBuild.addHeaders(["Date": String.RFC822(date: Date(timeIntervalSince1970: 0))])
        requestBuild.buildRequest { request, error in
            XCTAssertNil(error)
            print("request: \(String(describing: request))")

            let targetURL = "https://qingstor.com:443/?access_key_id=fake-query-access-key&expires=999999&signature=fake-query-signature-string"
            XCTAssertEqual(targetURL, (request?.url?.absoluteString)!)

            expectation.fulfill()
        }

        waitForExpectations(timeout: 99, handler: nil)
    }

    func testWriteHeaderCustomizedSigner() throws {
        let expectation = self.expectation(description: "")

        let signer = CustomizedSigner { _, _, _, completion in
            DispatchQueue.global(qos: .background).asyncAfter(deadline: DispatchTime.now() + 1) {
                completion(self.fakeHeaderSignatureResult())
            }
        }
        signer.signatureType = .header

        let requestBuild = DefaultRequestBuilder(context: APIContext.qingStor(), signer: signer)
        requestBuild.buildRequest { request, error in
            XCTAssertNil(error)
            print("request: \(String(describing: request))")

            let signatureHeader = "QS fake-header-access-key:fake-header-signature-string"
            XCTAssertEqual(signatureHeader, requestBuild.headers["Authorization"])

            expectation.fulfill()
        }

        waitForExpectations(timeout: 99, handler: nil)
    }

    func testWriteAuthorizationCustomizedSigner() throws {
        let expectation = self.expectation(description: "")

        let signer = CustomizedSigner { _, _, _, completion in
            DispatchQueue.global(qos: .background).asyncAfter(deadline: DispatchTime.now() + 1) {
                completion(self.fakeAuthorizationSignatureResult())
            }
        }
        signer.signatureType = .header

        let requestBuild = DefaultRequestBuilder(context: APIContext.qingStor(), signer: signer)
        requestBuild.buildRequest { request, error in
            XCTAssertNil(error)
            print("request: \(String(describing: request))")

            let signatureHeader = "fake-authorization-signature-string"
            XCTAssertEqual(signatureHeader, requestBuild.headers["Authorization"])

            expectation.fulfill()
        }

        waitForExpectations(timeout: 99, handler: nil)
    }
}

extension SignatureTests {
    func fakeQuerySignatureResult() -> SignatureResult {
        return .query(signature: "fake-query-signature-string", accessKey: "fake-query-access-key", expires: nil)
    }

    func fakeQuerySignatureResult(expires: Int) -> SignatureResult {
        return .query(signature: "fake-query-signature-string", accessKey: "fake-query-access-key", expires: expires)
    }

    func fakeHeaderSignatureResult() -> SignatureResult {
        return .header(signature: "fake-header-signature-string", accessKey: "fake-header-access-key")
    }

    func fakeAuthorizationSignatureResult() -> SignatureResult {
        return .authorization("fake-authorization-signature-string")
    }
}
