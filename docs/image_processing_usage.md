# QingStor Image Processing Usage Guide

For processing the image stored in QingStor by a variety of basic operations, such as format, crop, watermark and so on.
Please see [QingStor Image API](https://docs.qingcloud.com/qingstor/data_process/image_process/index.html).

## Code Snippet

```swift
// Swift
import QingStorSDK
```

```objective-c
// Objective-C
#import "QingStorSDK-Swift.h"
```

Initialize the ImageProcessor.

```swift
// Swift
let imageProcessor = ImageProcessor()
```

```objective-c
// Objective-C
QSImageProcessor *imageProcessor = [[QSImageProcessor alloc] init];
```

Crop the image.

```swift
// Swift
imageProcessor.crop(width: 500, height: 500, gravity: .center)
```

```objective-c
// Objective-C
[imageProcessor cropWithWidth:@500 height:@500 gravity:QSCropGravityCenter];
```

Rotate the image.

```swift
// Swift
imageProcessor.rotate(angle: 90)
```

```objective-c
// Objective-C
[imageProcessor rotateWithAngle:90];
```

Resize the image.

```swift
// Swift
imageProcessor.resize(width: 200, height: 400, mode: .force)
```

```objective-c
// Objective-C
[imageProcessor resizeWithWidth:@200 height:@400 mode:QSResizeModeForce];
```

Watermark the image.

```swift
// Swift
imageProcessor.watermark(text: "水印测试", color: "#ff00ff", opacity: 0.5, dpi: 250)
```

```objective-c
// Objective-C
[imageProcessor watermarkWithText:@"水印测试" color:@"#ff00ff" opacity:@.5f dpi:@250];
```

WatermarkImage the image.

```swift
// Swift
imageProcessor.watermarkImage(url: "https://pek3a.qingstor.com/bucket/image.png", left: 50, top: 100, opacity: 0.5)
```

```objective-c
// Objective-C
[imageProcessor watermarkImageWithURL:@"https://pek3a.qingstor.com/bucket/image.png" left:@50 top:@100 opacity:@.5f];
```

Format the image.

```swift
// Swift
imageProcessor.format(type: .jpeg)
```

```objective-c
// Objective-C
[imageProcessor formatWithType:QSFormatTypeJpeg];
```

Get processing result.

```swift
// Swift
let query = imageProcessor.processingResult()
```

```objective-c
// Objective-C
NSString *query = [imageProcessor processingResult];
```

Reset processing.

```swift
// Swift
imageProcessor.resetProcessing()
```

```objective-c
// Objective-C
[imageProcessor resetProcessing];
```

Operation pipline, the image will be processed by order. 

```swift
// Swift
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

```objective-c
// Objective-C
QSImageProcessor *imageProcessor = [[QSImageProcessor alloc] init];
imageProcessor = [imageProcessor rotateWithAngle:180];
imageProcessor = [imageProcessor resizeWithWidth:nil height:nil]; // invalid operate, will ignore
imageProcessor = [imageProcessor watermarkImageWithURL:@"https://pek3a.qingstor.com/bucket/image.png" left:@20 top:@80 opacity:@.1f];
imageProcessor = [imageProcessor cropWithWidth:@850 height:nil];
imageProcessor = [imageProcessor watermarkWithText:@"文本text" color:nil opacity:nil dpi:nil];
imageProcessor = [imageProcessor resizeWithWidth:nil height:@1024 mode:QSResizeModeForce];
imageProcessor = [imageProcessor cropWithWidth:nil height:nil]; // invalid operate, will ignore
imageProcessor = [imageProcessor formatWithType:QSFormatTypePng];
NSString *query = [imageProcessor processingResult];
```

Use api to rotate and crop image.

```swift
// Swift
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

```objective-c
// Objective-C
QSAPIContext *context = [[QSAPIContext alloc] initWithPlist:configURL error:nil];
QSQingStor *service = [[QSQingStor alloc] initWithContext:context];
QSBucket *bucket = [service bucketWithBucketName:@"bucketName" zone:@"pek3a"];

QSImageProcessor *imageProcessor = [[QSImageProcessor alloc] init];
imageProcessor = [imageProcessor rotateWithAngle:90];
imageProcessor = [imageProcessor cropWithWidth:@500 height:@500 gravity:QSCropGravityNorthEast];

NSString *query = [imageProcessor processingResult];
QSImageProcessInput *input = [QSImageProcessInput empty];
input.action = query;

[bucket imageProcessWithObjectKey:@"objectKey" input:input completion:^(QSImageProcessOutput *output, NSHTTPURLResponse *response, NSError *error) {
    NSLog(@"StatusCode: %ld", response.statusCode);
}];
```
