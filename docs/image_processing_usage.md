# QingStor Image Processing Usage Guide

For processing the image stored in QingStor by a variety of basic operations, such as format, crop, watermark and so on.
Please see [QingStor Image API](https://docs.qingcloud.com/qingstor/data_process/image_process/index.html).

## Code Snippet

``` swift
import QingStorSDK
```

Initialize the ImageProcessor.

``` swift
let imageProcessor = ImageProcessor()
```

Crop the image.

``` swift
imageProcessor.crop(width: 500, height: 500, gravity: .center)
```

Rotate the image.

``` swift
imageProcessor.rotate(angle: 90)
```

Resize the image.

``` swift
imageProcessor.resize(width: 200, height: 400, mode: .force)
```

Watermark the image.

``` swift
imageProcessor.watermark(text: "水印测试", color: "#ff00ff", opacity: 0.5, dpi: 250)
```

WatermarkImage the image.

``` swift
imageProcessor.watermarkImage(url: "https://pek3a.qingstor.com/bucket/image.png", left: 50, top: 100, opacity: 0.5)
```

Format the image.

``` swift
imageProcessor.format(type: .jpeg)
```

Get processing result.

``` swift
let query = imageProcessor.processingResult()
```

Reset processing.

``` swift
imageProcessor.resetProcessing()
```

Operation pipline, the image will be processed by order. 

``` swift
let query = ImageProcessor()
    .rotate(angle: 180)
    .resize(width: nil, height: nil, mode: nil)  // invalid operate, will ignore
    .watermarkImage(url: "https://pek3a.qingstor.com/bucket/image.png", left: 20, top: 80, opacity: 0.1)
    .crop(width: 850, height: nil, gravity: nil)
    .watermark(text: "文本text", color: nil, opacity: nil, dpi: nil)
    .resize(width: nil, height: 1024, mode: .force)
    .crop(width: nil, height: nil, gravity: nil) // invalid operate, will ignore
    .format(type: .png)
    .processingResult()
```

Use api to rotate and crop image.

``` swift
let context = try! APIContext(plist: configURL)
let service = QingStor(context: context)
let bucket = service.bucket(bucketName: "bucketName", zone: "pek3a")

let query = ImageProcessor()
    .rotate(angle: 90)
	.crop(width: 500, height: 500, gravity: .northEast)
	.processingResult()
let input = ImageProcessInput(action: query)
bucket.imageProcess(objectKey: "objectKey", input: input) { response, error in
    if let response = response {
        print("StatusCode: \(response.statusCode)")
    }
}
```

