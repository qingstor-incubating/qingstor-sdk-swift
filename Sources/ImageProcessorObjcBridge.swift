//
//  ImageProcessorObjcBridge.swift
//  QingStorSDK
//
//  Created by Chris on 28/02/2018.
//  Copyright © 2018 Yunify. All rights reserved.
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
