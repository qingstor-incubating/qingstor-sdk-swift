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

public protocol ImageProcessCodeable {
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

public enum ImageProcess: ImageProcessCodeable {
    case crop(width: Int?, height: Int?, gravity: CropGravity?)
    case rotate(angle: Int)
    case resize(width: Int?, height: Int?, mode: ResizeMode?)
    case watermark(text: String, color: String?, opacity: Float?, dpi: Int?)
    case watermarkImage(url: String, left: Int?, top: Int?, opacity: Float?)
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

    public func processCode() -> String {
        switch self {

        case let .crop(width, height, gravity):
            if width == nil && height == nil {
                return ""
            }

            let code = formatCodes([Code(prefix: "w", value: width),
                                    Code(prefix: "h", value: height),
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

@objc(QSResizeMode)
public enum ResizeMode: Int, Formatable {
    case fixed     = 0
    case force     = 1
    case thumbnail = 2

    fileprivate func format() -> String {
        return self.rawValue.format()
    }
}

public enum FormatType: String, Formatable {
    case jpeg = "jpeg"
    case png  = "png"
    case webp = "webp"
    case tiff = "tiff"

    fileprivate func format() -> String {
        return self.rawValue
    }
}

@objc(QSImageProcessor)
public class ImageProcessor: NSObject {
    public var processList: [ImageProcessCodeable] = []

    public init(processList: [ImageProcessCodeable] = []) {
        self.processList = processList
    }

    @objc public override convenience init() {
        self.init(processList: [])
    }

    public func process(_ process: ImageProcessCodeable) -> ImageProcessor {
        processList.append(process)
        return self
    }

    public func crop(width: Int?, height: Int?, gravity: CropGravity?) -> ImageProcessor {
        return process(ImageProcess.crop(width: width, height: height, gravity: gravity))
    }

    @objc public func rotate(angle: Int) -> ImageProcessor {
        return process(ImageProcess.rotate(angle: angle))
    }

    public func resize(width: Int?, height: Int?, mode: ResizeMode?) -> ImageProcessor {
        return process(ImageProcess.resize(width: width, height: height, mode: mode))
    }

    public func watermark(text: String, color: String?, opacity: Float?, dpi: Int?) -> ImageProcessor {
        return process(ImageProcess.watermark(text: text, color: color, opacity: opacity, dpi: dpi))
    }

    public func watermarkImage(url: String, left: Int?, top: Int?, opacity: Float?) -> ImageProcessor {
        return process(ImageProcess.watermarkImage(url: url, left: left, top: top, opacity: opacity))
    }

    public func format(type: FormatType) -> ImageProcessor {
        return process(ImageProcess.format(type: type))
    }

    @objc public func resetProcessing() {
        processList.removeAll()
    }

    @objc public func processingResult() -> String {
        return processList
            .map { $0.processCode() }
            .filter { !$0.isEmpty }
            .joined(separator: "|")
    }
}
