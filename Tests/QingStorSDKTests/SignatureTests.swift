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
        var context = APIContext.qingStor()
        context.query = "acl&upload_id=fde133b5f6d932cd9c79bac3c7318da1&part_number=0&other=abc"

        let requestBuild = DefaultRequestBuilder(context: context, signer: QingStorSigner())
        requestBuild.addHeaders(["Date": String.RFC822(date: Date(timeIntervalSince1970: 0))])
        requestBuild.addHeaders(["X-QS-Test-1": "Test1", "X-QS-Test-2": "Test2"])
        requestBuild.buildRequest { request, error in
            XCTAssertNil(error)
            print("request: \(request)")

            let signatureHeader = "QS ACCESS_KEY_ID_EXAMPLE:w62wOSlVbX1haMWiNBpfMM9J8pqn7XCPoUAgTVmgVsc="
            XCTAssertEqual(signatureHeader, requestBuild.headers["Authorization"])
        }

        let signer = QingStorSigner()
        let signatureString = try signer.signatureString(from: requestBuild)
        XCTAssertEqual(signatureString, "w62wOSlVbX1haMWiNBpfMM9J8pqn7XCPoUAgTVmgVsc=")
    }

    func testWriteQuerySignature() throws {
        var context = APIContext.qingStor()
        context.query = "acl&upload_id=fde133b5f6d932cd9c79bac3c7318da1&part_number=0&other=abc"

        let signer = QingStorSigner()
        signer.signatureType = .query(timeoutSeconds: 500)
        let requestBuild = DefaultRequestBuilder(context: context, signer: signer)
        requestBuild.addHeaders(["Date": String.RFC822(date: Date(timeIntervalSince1970: 0))])
        requestBuild.addHeaders(["X-QS-Test-1": "Test1", "X-QS-Test-2": "Test2"])
        requestBuild.buildRequest { request, error in
            XCTAssertNil(error)
            print("request: \(request)")

            let targetURL = "https://qingstor.com:443/?acl&upload_id=fde133b5f6d932cd9c79bac3c7318da1&part_number=0&other=abc&access_key_id=ACCESS_KEY_ID_EXAMPLE&expires=500&signature=GUiulUdgubQqvCaz/2olIJWIGVo2KC4fDfoARj0u6v4%3D"
            XCTAssertEqual(targetURL, (request?.url?.absoluteString)!)
        }

        let signatureString = try signer.signatureString(from: requestBuild)
        XCTAssertEqual(signatureString, "GUiulUdgubQqvCaz/2olIJWIGVo2KC4fDfoARj0u6v4=")
    }

    func testWriteNonASCIIHeaderSignature() throws {
        var context = APIContext.qingStor()
        context.query = "acl&upload_id=fde133b5f6d932cd9c79bac3c7318da1&part_number=0&other=abc&response-content-disposition=测试中文"

        let requestBuild = DefaultRequestBuilder(context: context, signer: QingStorSigner())
        requestBuild.addHeaders(["Date": String.RFC822(date: Date(timeIntervalSince1970: 0))])
        requestBuild.addHeaders(["X-QS-Test-1": "Test1", "X-QS-Test-2": "Test2", "X-QS-Test-Chinese": "中文测试"])
        requestBuild.buildRequest { request, error in
            XCTAssertNil(error)
            print("request: \(request)")

            let signatureHeader = "QS ACCESS_KEY_ID_EXAMPLE:yIcBDU7d0ybYLoaD63jd/SBubZj+FouRXxp1h98A7gM="
            XCTAssertEqual(signatureHeader, requestBuild.headers["Authorization"])
        }

        let signer = QingStorSigner()
        let signatureString = try signer.signatureString(from: requestBuild)
        XCTAssertEqual(signatureString, "yIcBDU7d0ybYLoaD63jd/SBubZj+FouRXxp1h98A7gM=")
    }

    func testWriteNonASCIIQuerySignature() throws {
        var context = APIContext.qingStor()
        context.query = "acl&upload_id=fde133b5f6d932cd9c79bac3c7318da1&part_number=0&other=abc&response-content-disposition=测试中文"

        let signer = QingStorSigner()
        signer.signatureType = .query(timeoutSeconds: 500)
        let requestBuild = DefaultRequestBuilder(context: context, signer: signer)
        requestBuild.addHeaders(["Date": String.RFC822(date: Date(timeIntervalSince1970: 0))])
        requestBuild.addHeaders(["X-QS-Test-1": "Test1", "X-QS-Test-2": "Test2", "X-QS-Test-Chinese": "中文测试"])
        requestBuild.buildRequest { request, error in
            XCTAssertNil(error)
            print("request: \(request)")

            let targetURL = "https://qingstor.com:443/?acl&upload_id=fde133b5f6d932cd9c79bac3c7318da1&part_number=0&other=abc&response-content-disposition=%E6%B5%8B%E8%AF%95%E4%B8%AD%E6%96%87&access_key_id=ACCESS_KEY_ID_EXAMPLE&expires=500&signature=E%2BI8HCqScZWWeNWwS%2BzEVRlTFZ8DO92OTN69dAdaFF4%3D"
            XCTAssertEqual(targetURL, (request?.url?.absoluteString)!)
        }

        let signatureString = try signer.signatureString(from: requestBuild)
        XCTAssertEqual(signatureString, "E+I8HCqScZWWeNWwS+zEVRlTFZ8DO92OTN69dAdaFF4=")
    }
}
