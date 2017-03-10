//
//  APITests.swift
//  QingStorSDK
//
//  Created by Chris on 16/12/4.
//  Copyright © 2016年 Yunify. All rights reserved.
//

import XCTest
@testable import QingStorSDK

class APITests: XCTestCase {
    override func setUp() {
        super.setUp()

        Registry.register(accessKeyID: "ACCESS_KEY_ID_EXAMPLE", secretAccessKey: "SECRET_ACCESS_KEY_EXAMPLE")
    }

    override func tearDown() {
        super.tearDown()
    }

    func testRegister() {
        XCTAssertEqual(Registry.accessKeyID, "ACCESS_KEY_ID_EXAMPLE")
        XCTAssertEqual(Registry.secretAccessKey, "SECRET_ACCESS_KEY_EXAMPLE")
    }

    func testContextRegister() {
        let context = APIContext.qingStor()
        XCTAssertEqual(context.accessKeyID, "ACCESS_KEY_ID_EXAMPLE")
        XCTAssertEqual(context.secretAccessKey, "SECRET_ACCESS_KEY_EXAMPLE")
    }
    
    func testContextReadConfig() {
        var context = APIContext.qingStor()
        XCTAssertEqual(context.url.absoluteString, "https://qingstor.com:443/")
        
        context.readFrom(config: ["port":"80", "protocol":"http", "host":"example.com"])
        XCTAssertEqual(context.url.absoluteString, "http://example.com:80/")
    }

    func testSetupContext() {
        let api = QingStorAPI(context: APIContext.qingStor())
        try! api.setupContext(uriFormat: "/<bucket-name>/<object-key>?test", bucketName: "test-bucket", objectKey: "test-object", zone: "test-zone")
        let targetURL = "https://test-zone.qingstor.com:443/test-bucket/test-object?test"
        XCTAssertEqual(targetURL, api.context.url.absoluteString)

        do {
            try api.setupContext(uriFormat: "/<bucket-name>/<object-key>?test")
            XCTAssert(false, "must be throw APIError")
        } catch {
            XCTAssertTrue(error is APIError)
        }
    }

    func testGetURLInQuerySignature() {
        let bucket = QingStor().bucket(bucketName: "bucket-name")
        let input = GetObjectInput()
        input.signatureType = .query(timeoutSeconds: 60)
        let (sender, _) = bucket.getObjectSender(objectKey: "object-key", input: input)
        sender?.buildRequest { request, error in
            XCTAssertNil(error)
            XCTAssertNotNil(request?.url)

            print("url: \(request?.url)")
        }
    }
}
