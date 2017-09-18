//
//  HelperTests.swift
//  QingStorSDK
//
//  Created by Chris on 16/12/4.
//  Copyright © 2016年 Yunify. All rights reserved.
//

import XCTest
@testable import QingStorSDK

class HelperTests: XCTestCase {

    override func setUp() {
        super.setUp()
    }

    override func tearDown() {
        super.tearDown()
    }

    func testEscape() {
        let result = ";=%".escape()
        let targetResult = "%3B%3D%25"
        XCTAssertEqual(targetResult, result)
    }

    func testUnescape() {
        let result = "%3B%3D%25".unescape()
        let targetResult = ";=%"
        XCTAssertEqual(targetResult, result)
    }

    func testBuildQuery() {
        var parameters: [String:Any] = ["test-1": "1", "test-2": ["value1", "value2"]]
        let result = APIHelper.buildQueryString(parameters: &parameters, escaped: false)

        let targetResult = "test-1=1&test-2.1=value1&test-2.2=value2"
        XCTAssertEqual(targetResult, result)
        XCTAssertEqual(parameters.count, 3)
    }

    func testBuildEscapedQuery() {
        var parameters: [String:Any] = ["test-1": "1", "test-2": ["value1", "value2"], "test-3": "+="]
        let result = APIHelper.buildQueryString(parameters: &parameters, escaped: true)

        let targetResult = "test-1=1&test-2.1=value1&test-2.2=value2&test-3=%2B%3D"
        XCTAssertEqual(targetResult, result)
        XCTAssertEqual(parameters.count, 4)
    }

    func testMimeType() {
        XCTAssertEqual("image/png", URL(string: "/file.png")?.mimeType)
        XCTAssertEqual("video/quicktime", URL(string: "/file.mov")?.mimeType)
        XCTAssertEqual("application/octet-stream", URL(string: "/file")?.mimeType)
    }

    func testContentLength() {
        let data = "test-file-length".data(using: String.Encoding.utf8)
        let url = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0].appendingPathComponent("test-content-length")
        try! data?.write(to: url)

        XCTAssertEqual(data?.count, url.contentLength)
    }
}
