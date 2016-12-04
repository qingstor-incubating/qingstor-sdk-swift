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
    
    func testSetupContext() {
        let api = QingStorAPI(context: APIContext.qingStor())
        api.setupContext(uriFormat: "/<bucket-name>/<object-key>?test", bucketName: "test-bucket", objectKey: "test-object", zone: "test-zone")
        let targetURL = "https://test-zone.qingstor.com:443/test-bucket/test-object?test"
        XCTAssertEqual(targetURL, api.context.url.absoluteString)
    }
}
