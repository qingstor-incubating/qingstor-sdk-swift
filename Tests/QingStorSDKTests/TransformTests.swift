//
//  TransformTests.swift
//  QingStorSDK
//
//  Created by Chris on 16/12/4.
//  Copyright © 2016年 Yunify. All rights reserved.
//

import XCTest
@testable import QingStorSDK

class TransformTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    func testISO8601DateTransform() {
        let transform = ISO8601DateTransform()
        
        let objectValue = String.ISO8601(date: Date(timeIntervalSince1970: 0)).toISO8601Date()
        let jsonValue = "1970-01-01T00:00:00Z"
        
        XCTAssertEqual(objectValue, transform.transformFromJSON(jsonValue))
        XCTAssertEqual(jsonValue, transform.transformToJSON(objectValue))
    }
    
    func testRFC822DateTransform() {
        let transform = RFC822DateTransform()
        
        let objectValue = String.RFC822(date: Date(timeIntervalSince1970: 0)).toRFC822Date()
        let jsonValue = "Thu, 01 Jan 1970 00:00:00 GMT"
        
        XCTAssertEqual(objectValue, transform.transformFromJSON(jsonValue))
        XCTAssertEqual(jsonValue, transform.transformToJSON(objectValue))
    }
}
