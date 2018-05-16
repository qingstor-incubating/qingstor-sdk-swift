//
//  ImageProcessor.swift
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

import Foundation

/// The protocol of image process format code.
public protocol ImageProcessCodeable {
    /// Calculate process code.
    ///
    /// - returns: The process code.
    func processCode() -> String
}

private protocol Codeable {
    func code() -> String
}

private protocol Formatable {
    func format() -> String
}

extension Formatable {
    func format() -> String {
        return String(describing: self)
    }
}

extension Int: Formatable { }
extension Float: Formatable { }

extension String: Formatable {
    func format() -> String {
        return self
    }
}

/// ImageProcess will convert the image process type to the format code.
public enum ImageProcess: ImageProcessCodeable {
    /// The process type of crop image.
    ///
    /// - parameter width:   The image crop width.
    /// - parameter height:  The image crop height.
    /// - parameter left:    The image crop left margin.
    /// - parameter top:     The image crop top margin.
    /// - parameter gravity: Defining how the image is displayed within an bounds rect.
    case crop(width: Int?, height: Int?, left: Int?, top: Int?, gravity: CropGravity?)

    /// The process type of rotate image.
    ///
    /// - parameter angle: The image rotation angle.
    case rotate(angle: Int)

    /// The process type of resize image.
    ///
    /// - parameter width:  The image resize width.
    /// - parameter height: The image resize height.
    /// - parameter mode:   Defining how the image is displayed within an bounds rect.
    case resize(width: Int?, height: Int?, mode: ResizeMode?)

    /// The process type of add watermark text to original image.
    ///
    /// - parameter text:    The watermark text.
    /// - parameter color:   The watermark text color.
    /// - parameter opacity: The watermark text opacity.
    /// - parameter dpi:     The watermark text size in dpi.
    case watermark(text: String, color: String?, opacity: Float?, dpi: Int?)

    /// The process type of add watermark image to original image.
    ///
    /// - parameter url:     The watermark image url.
    /// - parameter left:    The watermark image left margin.
    /// - parameter top:     The watermark image top margin.
    /// - parameter opacity: The watermark iamge opacity.
    case watermarkImage(url: String, left: Int?, top: Int?, opacity: Float?)

    /// The process type of to format image.
    ///
    /// - parameter type: The format type.
    case format(type: FormatType)

    fileprivate struct Code<T: Formatable>: Codeable {
        let prefix: String
        let value: T?
        let base64: Bool

        var description: String {
            if let value = value {
                var format = value.format()
                if base64 {
                    // Convert to Base64 and make safe for URLs
                    format = format.data(using: .utf8)!.base64EncodedString()
                    format = format.replacingOccurrences(of: "/", with: "_")
                    format = format.replacingOccurrences(of: "+", with: "-")
                    format = format.trimmingCharacters(in: CharacterSet(charactersIn: "="))
                }

                return "\(prefix)_\(format)"
            }

            return ""
        }

        init(prefix: String, value: T? = nil, base64: Bool = false) {
            self.prefix = prefix
            self.value = value
            self.base64 = base64
        }

        func code() -> String {
            return self.description
        }
    }

    /// Calculate process code.
    ///
    /// - returns: The process code.
    public func processCode() -> String {
        switch self {

        case let .crop(width, height, left, top, gravity):
            if width == nil && height == nil && left == nil && top == nil {
                return ""
            }

            let code = formatCodes([Code(prefix: "w", value: width),
                                    Code(prefix: "h", value: height),
                                    Code(prefix: "l", value: left),
                                    Code(prefix: "t", value: top),
                                    Code(prefix: "g", value: gravity)])
            return "crop:\(code)"

        case let .rotate(angle):
            let code = Code(prefix: "a", value: angle).description
            return "rotate:\(code)"

        case let .resize(width, height, mode):
            if width == nil && height == nil {
                return ""
            }

            let code = formatCodes([Code(prefix: "w", value: width),
                                    Code(prefix: "h", value: height),
                                    Code(prefix: "m", value: mode)])
            return "resize:\(code)"

        case let .watermark(text, color, opacity, dpi):
            let code = formatCodes([Code(prefix: "t", value: text, base64: true),
                                    Code(prefix: "c", value: color, base64: true),
                                    Code(prefix: "p", value: opacity),
                                    Code(prefix: "d", value: dpi)])
            return "watermark:\(code)"

        case let .watermarkImage(url, left, top, opacity):
            let code = formatCodes([Code(prefix: "u", value: url, base64: true),
                                    Code(prefix: "l", value: left),
                                    Code(prefix: "t", value: top),
                                    Code(prefix: "p", value: opacity)])
            return "watermark_image:\(code)"

        case let .format(type):
            let code = Code(prefix: "t", value: type).description
            return "format:\(code)"
        }
    }

    fileprivate func formatCodes(_ codes: [Codeable]) -> String {
        return codes
            .map { $0.code() }
            .filter { !$0.isEmpty }
            .joined(separator: ",")
    }
}

/// The image crop gravity mode.
@objc(QSCropGravity)
public enum CropGravity: Int, Formatable {
    case center    = 0
    case north     = 1
    case east      = 2
    case south     = 3
    case west      = 4
    case northWest = 5
    case northEast = 6
    case southWest = 7
    case southEast = 8
    case auto      = 9

    fileprivate func format() -> String {
        return self.rawValue.format()
    }
}

/// The image resize mode.
@objc(QSResizeMode)
public enum ResizeMode: Int, Formatable {
    case fixed     = 0
    case force     = 1
    case thumbnail = 2

    fileprivate func format() -> String {
        return self.rawValue.format()
    }
}

/// The image format type.
public enum FormatType: String, Formatable {
    case jpeg = "jpeg"
    case png  = "png"
    case webp = "webp"
    case tiff = "tiff"

    fileprivate func format() -> String {
        return self.rawValue
    }
}

/// A image process handler, ability to combine multiple image processes together using chained calls
@objc(QSImageProcessor)
public class ImageProcessor: NSObject {
    /// The image process list.
    public var processList: [ImageProcessCodeable] = []

    /// Initialize `ImageProcessor` with the specified `processList`
    ///
    /// - parameter processList: The image process list.
    ///
    /// - returns: The new `ImageProcessor` instance.
    public init(processList: [ImageProcessCodeable] = []) {
        self.processList = processList
    }

    /// Initialize `ImageProcessor` with empty process list.
    ///
    /// - returns: The new `ImageProcessor` instance.
    @objc public override convenience init() {
        self.init(processList: [])
    }

    /// Add the image process.
    ///
    /// - parameter process: The implementation of `ImageProcessCodeable`
    ///
    /// - returns: The image processor.
    public func process(_ process: ImageProcessCodeable) -> ImageProcessor {
        processList.append(process)
        return self
    }

    /// Add the process of crop image.
    ///
    /// - parameter width:   The image crop width.
    /// - parameter height:  The image crop height.
    /// - parameter left:    The image crop left margin.
    /// - parameter top:     The image crop top margin.
    ///
    /// - returns: The image processor.
    public func crop(width: Int? = nil, height: Int? = nil, left: Int? = nil, top: Int? = nil) -> ImageProcessor {
        return process(ImageProcess.crop(width: width, height: height, left: left, top: top, gravity: nil))
    }

    /// Add the process of crop image.
    ///
    /// - parameter width:   The image crop width.
    /// - parameter height:  The image crop height.
    /// - parameter gravity: Defining how the image is displayed within an bounds rect.
    ///
    /// - returns: The image processor.
    public func crop(width: Int? = nil, height: Int? = nil, gravity: CropGravity? = nil) -> ImageProcessor {
        return process(ImageProcess.crop(width: width, height: height, left: nil, top: nil, gravity: gravity))
    }

    /// Add the process of rotate image.
    ///
    /// - parameter angle: The image rotation angle.
    ///
    /// - returns: The image processor.
    @objc public func rotate(angle: Int) -> ImageProcessor {
        return process(ImageProcess.rotate(angle: angle))
    }

    /// Add the process of resize image.
    ///
    /// - parameter width:  The image resize width.
    /// - parameter height: The image resize height.
    /// - parameter mode:   Defining how the image is displayed within an bounds rect.
    ///
    /// - returns: The image processor.
    public func resize(width: Int? = nil, height: Int? = nil, mode: ResizeMode? = nil) -> ImageProcessor {
        return process(ImageProcess.resize(width: width, height: height, mode: mode))
    }

    /// Add the process of add watermark text to original image.
    ///
    /// - parameter text:    The watermark text.
    /// - parameter color:   The watermark text color.
    /// - parameter opacity: The watermark text opacity.
    /// - parameter dpi:     The watermark text size in dpi.
    ///
    /// - returns: The image processor.
    public func watermark(text: String, color: String? = nil, opacity: Float? = nil, dpi: Int? = nil) -> ImageProcessor {
        return process(ImageProcess.watermark(text: text, color: color, opacity: opacity, dpi: dpi))
    }

    /// Add the process of add watermark image to original image.
    ///
    /// - parameter url:     The watermark image url.
    /// - parameter left:    The watermark image left margin.
    /// - parameter top:     The watermark image top margin.
    /// - parameter opacity: The watermark iamge opacity.
    ///
    /// - returns: The image processor.
    public func watermarkImage(url: String, left: Int? = nil, top: Int? = nil, opacity: Float? = nil) -> ImageProcessor {
        return process(ImageProcess.watermarkImage(url: url, left: left, top: top, opacity: opacity))
    }

    /// Add the process of format image.
    ///
    /// - parameter type: The format type.
    ///
    /// - returns: The image processor.
    public func format(type: FormatType) -> ImageProcessor {
        return process(ImageProcess.format(type: type))
    }

    /// Reset image process.
    @objc public func resetProcessing() {
        processList.removeAll()
    }

    /// Handle image process.
    ///
    /// - returns: The image process result.
    @objc public func processingResult() -> String {
        return processList
            .map { $0.processCode() }
            .filter { !$0.isEmpty }
            .joined(separator: "|")
    }
}
