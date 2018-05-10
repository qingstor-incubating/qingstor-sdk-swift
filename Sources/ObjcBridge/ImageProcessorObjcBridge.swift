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

/// The objc bridge of the `FormatType`.
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
    /// The objc bridge of add the crop image process.
    ///
    /// - parameter width:   The image crop width.
    /// - parameter height:  The image crop height.
    /// - parameter left:    The image crop left margin.
    /// - parameter top:     The image crop top margin.
    ///
    /// - returns: The image processor.
    @objc(cropWithWidth:height:left:top:)
    public func cropObjcBridge(width: NSNumber?, height: NSNumber?, left: NSNumber?, top: NSNumber?) -> ImageProcessor {
        return crop(width: width?.intValue, height: height?.intValue, left: left?.intValue, top: top?.intValue)
    }
    
    /// The objc bridge of add the crop image process.
    ///
    /// - parameter width:   The image crop width.
    /// - parameter height:  The image crop height.
    /// - parameter gravity: Defining how the image is displayed within an bounds rect.
    ///
    /// - returns: The image processor.
    @objc(cropWithWidth:height:gravity:)
    public func cropObjcBridge(width: NSNumber?, height: NSNumber?, gravity: CropGravity) -> ImageProcessor {
        return crop(width: width?.intValue, height: height?.intValue, gravity: gravity)
    }

    /// The objc bridge of add the crop image process.
    ///
    /// - parameter width:   The image crop width.
    /// - parameter height:  The image crop height.
    ///
    /// - returns: The image processor.
    @objc(cropWithWidth:height:)
    public func cropObjcBridge(width: NSNumber?, height: NSNumber?) -> ImageProcessor {
        return crop(width: width?.intValue, height: height?.intValue)
    }
    
    /// The objc bridge of add the crop image process.
    ///
    /// - parameter left:    The image crop left margin.
    /// - parameter top:     The image crop top margin.
    ///
    /// - returns: The image processor.
    @objc(cropWithLeft:top:)
    public func cropObjcBridge(left: NSNumber?, top: NSNumber?) -> ImageProcessor {
        return crop(left: left?.intValue, top: top?.intValue)
    }

    /// The objc bridge of add the resize image process.
    ///
    /// - parameter width:  The image resize width.
    /// - parameter height: The image resize height.
    /// - parameter mode:   Defining how the image is displayed within an bounds rect.
    ///
    /// - returns: The image processor.
    @objc(resizeWithWidth:height:mode:)
    public func resizeObjcBridge(width: NSNumber?, height: NSNumber?, mode: ResizeMode) -> ImageProcessor {
        return resize(width: width?.intValue, height: height?.intValue, mode: mode)
    }

    /// The objc bridge of add the resize image process.
    ///
    /// - parameter width:  The image resize width.
    /// - parameter height: The image resize height.
    ///
    /// - returns: The image processor.
    @objc(resizeWithWidth:height:)
    public func resizeObjcBridge(width: NSNumber?, height: NSNumber?) -> ImageProcessor {
        return resize(width: width?.intValue, height: height?.intValue)
    }

    /// The objc bridge of add watermark text to original image process.
    ///
    /// - parameter text:    The watermark text.
    /// - parameter color:   The watermark text color.
    /// - parameter opacity: The watermark text opacity.
    /// - parameter dpi:     The watermark text size in dpi.
    ///
    /// - returns: The image processor.
    @objc(watermarkWithText:color:opacity:dpi:)
    public func watermarkObjcBridge(text: String, color: String?, opacity: NSNumber?, dpi: NSNumber?) -> ImageProcessor {
        return watermark(text: text, color: color, opacity: opacity?.floatValue, dpi: dpi?.intValue)
    }

    /// The objc bridge of add watermark text to original image process.
    ///
    /// - parameter text:    The watermark text.
    /// - parameter color:   The watermark text color.
    ///
    /// - returns: The image processor.
    @objc(watermarkWithText:color:)
    public func watermarkObjcBridge(text: String, color: String?) -> ImageProcessor {
        return watermark(text: text, color: color)
    }

    /// The objc bridge of add watermark image to original image process.
    ///
    /// - parameter url:     The watermark image url.
    /// - parameter left:    The watermark image let margin.
    /// - parameter top:     The watermark image top margin.
    /// - parameter opacity: The watermark iamge opacity.
    ///
    /// - returns: The image processor.
    @objc(watermarkImageWithURL:left:top:opacity:)
    public func watermarkImageObjcBridge(url: String, left: NSNumber?, top: NSNumber?, opacity: NSNumber?) -> ImageProcessor {
        return watermarkImage(url: url, left: left?.intValue, top: top?.intValue, opacity: opacity?.floatValue)
    }

    /// The objc bridge of add watermark image to original image process.
    ///
    /// - parameter url:     The watermark image url.
    /// - parameter left:    The watermark image let margin.
    /// - parameter top:     The watermark image top margin.
    ///
    /// - returns: The image processor.
    @objc(watermarkImageWithURL:left:top:)
    public func watermarkImageObjcBridge(url: String, left: NSNumber?, top: NSNumber?) -> ImageProcessor {
        return watermarkImage(url: url, left: left?.intValue, top: top?.intValue)
    }

    /// The objc bridge of add watermark image to original image process.
    ///
    /// - parameter url:     The watermark image url.
    ///
    /// - returns: The image processor.
    @objc(watermarkImageWithURL:)
    public func watermarkImageObjcBridge(url: String) -> ImageProcessor {
        return watermarkImage(url: url)
    }

    /// The objc bridge of add format image process.
    ///
    /// - parameter type: The format type.
    ///
    /// - returns: The image processor.
    @objc(formatWithType:)
    public func formatObjcBridge(type: FormatTypeObjcBridge) -> ImageProcessor {
        return format(type: FormatType(type))
    }
}
