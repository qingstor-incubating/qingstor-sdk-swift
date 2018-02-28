//
// ImageProcessorObjcBridge.swift
//
// +-------------------------------------------------------------------------
// | Copyright (C) 2018 Yunify, Inc.
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

@objc(QSFormatType)
public enum FormatTypeObjcBridge: Int {
    case jpeg = 0
    case png
    case webp
    case tiff
}

extension FormatType {
    init(_ type: FormatTypeObjcBridge) {
        switch type {
        case .jpeg:
            self = .jpeg
        case .png:
            self = .png
        case .webp:
            self = .webp
        case .tiff:
            self = .tiff
        }
    }
}

extension ImageProcessor {
    @objc(cropWithWidth:height:gravity:)
    public func cropObjcBridge(width: NSNumber?, height: NSNumber?, gravity: CropGravity) -> ImageProcessor {
        return process(ImageProcess.crop(width: width?.intValue, height: height?.intValue, gravity: gravity))
    }

    @objc(cropWithWidth:height:)
    public func cropObjcBridge(width: NSNumber?, height: NSNumber?) -> ImageProcessor {
        return process(ImageProcess.crop(width: width?.intValue, height: height?.intValue, gravity: nil))
    }

    @objc(resizeWithWidth:height:mode:)
    public func resizeObjcBridge(width: NSNumber?, height: NSNumber?, mode: ResizeMode) -> ImageProcessor {
        return process(ImageProcess.resize(width: width?.intValue, height: height?.intValue, mode: mode))
    }

    @objc(resizeWithWidth:height:)
    public func resizeObjcBridge(width: NSNumber?, height: NSNumber?) -> ImageProcessor {
        return process(ImageProcess.resize(width: width?.intValue, height: height?.intValue, mode: nil))
    }

    @objc(watermarkWithText:color:opacity:dpi:)
    public func watermarkObjcBridge(text: String, color: String?, opacity: NSNumber?, dpi: NSNumber?) -> ImageProcessor {
        return process(ImageProcess.watermark(text: text, color: color, opacity: opacity?.floatValue, dpi: dpi?.intValue))
    }

    @objc(watermarkWithText:color:)
    public func watermarkObjcBridge(text: String, color: String?) -> ImageProcessor {
        return process(ImageProcess.watermark(text: text, color: color, opacity: nil, dpi: nil))
    }

    @objc(watermarkImageWithURL:left:top:opacity:)
    public func watermarkImageObjcBridge(url: String, left: NSNumber?, top: NSNumber?, opacity: NSNumber?) -> ImageProcessor {
        return process(ImageProcess.watermarkImage(url: url, left: left?.intValue, top: top?.intValue, opacity: opacity?.floatValue))
    }

    @objc(watermarkImageWithURL:left:top:)
    public func watermarkImageObjcBridge(url: String, left: NSNumber?, top: NSNumber?) -> ImageProcessor {
        return process(ImageProcess.watermarkImage(url: url, left: left?.intValue, top: top?.intValue, opacity: nil))
    }

    @objc(watermarkImageWithURL:)
    public func watermarkImageObjcBridge(url: String) -> ImageProcessor {
        return process(ImageProcess.watermarkImage(url: url, left: nil, top: nil, opacity: nil))
    }

    @objc(formatWithType:)
    public func formatObjcBridge(type: FormatTypeObjcBridge) -> ImageProcessor {
        return process(ImageProcess.format(type: FormatType(type)))
    }
}
