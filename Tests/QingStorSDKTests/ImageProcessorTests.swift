//
//  QingStorAPIs.swift
//
// +-------------------------------------------------------------------------
// | Copyright (C) 2017 Yunify, Inc.
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
@testable import QingStorSDK

class ImageProcessorTests: XCTestCase {

    override func setUp() {
        super.setUp()
    }

    override func tearDown() {
        super.tearDown()
    }

    func testCrop() {
        let result = "crop:w_100,h_200,g_6"
        let target = ImageProcessor()
            .crop(width: 100, height: 200, gravity: .northEast)
            .processingResult()

        XCTAssertEqual(target, result)
    }

    func testRotate() {
        let result = "rotate:a_360"
        let target = ImageProcessor()
            .rotate(angle: 360)
            .processingResult()

        XCTAssertEqual(target, result)
    }

    func testResize() {
        let result = "resize:w_200,h_400,m_2"
        let target = ImageProcessor()
            .resize(width: 200, height: 400, mode: .thumbnail)
            .processingResult()

        XCTAssertEqual(target, result)
    }

    func testWatermark() {
        let result = "watermark:t_5rC05Y2w5rWL6K-V,c_I2ZmMDBmZg,p_0.1123,d_250"
        let target = ImageProcessor()
            .watermark(text: "水印测试", color: "#ff00ff", opacity: 0.1123, dpi: 250)
            .processingResult()

        XCTAssertEqual(target, result)
    }

    func testWatermarkImage() {
        let result = "watermark_image:u_aHR0cHM6Ly9wZWszYS5xaW5nc3Rvci5jb20vaW1nLWRvYy1lZy9xaW5jbG91ZC5wbmc,l_50,t_100,p_1.0"
        let target = ImageProcessor()
            .watermarkImage(url: "https://pek3a.qingstor.com/img-doc-eg/qincloud.png", left: 50, top: 100, opacity: 1.000)
            .processingResult()

        XCTAssertEqual(target, result)
    }

    func testFormat() {
        let result = "format:t_tiff"
        let target = ImageProcessor()
            .format(type: .tiff)
            .processingResult()

        XCTAssertEqual(target, result)
    }

    func testCombinationProcess() {
        let result = "rotate:a_180|watermark_image:u_aHR0cHM6Ly9wZWszYS5xaW5nc3Rvci5jb20vaW1nLWRvYy1lZy9xaW5jbG91ZC5wbmc,l_20,t_80,p_0.1|crop:w_850|watermark:t_5paH5pysdGV4dA|resize:h_1024,m_1|format:t_png"
        let target = ImageProcessor()
            .rotate(angle: 180)
            .resize(width: nil, height: nil, mode: nil)  // invalid operate, will ignore
            .watermarkImage(url: "https://pek3a.qingstor.com/img-doc-eg/qincloud.png", left: 20, top: 80, opacity: 0.1)
            .crop(width: 850, height: nil, gravity: nil)
            .watermark(text: "文本text", color: nil, opacity: nil, dpi: nil)
            .resize(width: nil, height: 1024, mode: .force)
            .crop(width: nil, height: nil, gravity: nil) // invalid operate, will ignore
            .format(type: .png)
            .processingResult()

        XCTAssertEqual(target, result)
    }

    func testResetProcessing() {
        let imageProcessor = ImageProcessor()

        let result = "rotate:a_180"
        let target = imageProcessor.rotate(angle: 180).processingResult()
        XCTAssertEqual(target, result)

        imageProcessor.resetProcessing()
        XCTAssertEqual("", imageProcessor.processingResult())
    }
}
