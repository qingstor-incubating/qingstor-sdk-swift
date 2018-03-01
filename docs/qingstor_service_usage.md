# QingStor Service Usage Guide

Import the QingStorSDK and initialize service with a context, and you are ready to use the initialized service. Service only contains one API, and it is "ListBuckets".
To use bucket related APIs, you need to initialize a bucket from service using "bucket" function. 

Each API function take a Input struct and get a Response struct at closure. The Input struct consists of request params, request headers, request elements and request body, and the Response holds the response of `HTTPURLResponse` and Output struct. The Output struct consists of QingStor request ID, response headers, response elements, response body and error  (if error occurred).

```swift
// Swift
import QingStorSDK
```

```objective-c
// Objective-C
#import "QingStorSDK-Swift.h"
```

### Code Snippet

Initialize the QingStor service with a configuration

```swift
// Swift
let context = try! APIContext(plist: configURL)
let qsService = QingStor(context: context)
```

```objective-c
// Objective-C
QSAPIContext *context = [[QSAPIContext alloc] initWithPlist:configURL error:nil];
QSQingStor *qsService = [[QSQingStor alloc] initWithContext:context];
```

Use customized signer to initialize the QingStor service

```swift
// Swift
let signer = CustomizedSigner { signer, plaintext, requestBuilder, completion in
    switch signer.signatureType {
    case .query:
        completion(.query(signature: "signature-string", accessKey: "access-key", expires: 1519884303))
    case .header:
        completion(.header(signature: "signature-string", accessKey: "access-key"))
    }
}
let qsService = QingStor(signer: signer)
```

```objective-c
// Objective-C
QSSignatureTypeModel *signatureType = [QSSignatureTypeModel header];
QSCustomizedSigner *customizedSigner = [[QSCustomizedSigner alloc] initWithSignatureType:signatureType handler:^(QSCustomizedSigner *signer, NSString *plainString, QSRequestBuilder *builder, void (^completion)(QSSignatureResultModel *)) {
    switch (signer.signatureTypeModel.type) {
        case QSSignatureTypeQuery:
            completion([QSSignatureResultModel queryWithSignature:@"signature-string" accessKey:@"access-key" expires:@1519884303]);
            break;
            
        case QSSignatureTypeHeader:
            completion([QSSignatureResultModel headerWithSignature:@"signature-string" accessKey:@"access-key"]);
            break;
    }
}];
QSQingStor *qsService = [[QSQingStor alloc] initWithCustomizedSigner:customizedSigner];
```

List buckets

```swift
// Swift
let input = ListBucketsInput()
qsService.listBuckets(input: input) { response, error in
    if let response = response {
        print("StatusCode: \(response.statusCode)")
        if response.output.errMessage == nil {
            print("Bucket count: \(response.output.count)")
            print("First bucket name: \(response.output.buckets?.first?.name)")
        }
    }
}
```

```objective-c
// Objective-C
QSListBucketsInput *input = [QSListBucketsInput empty];
[qsService listBucketsWithInput:input completion:^(QSListBucketsOutput *output, NSHTTPURLResponse *response, NSError *error) {
    NSLog(@"StatusCode: %ld", response.statusCode);
    NSLog(@"Bucket count: %ld", output.count);
    NSLog(@"First bucket name: %@", output.buckets.firstObject.name);
}];
```

Initialize a QingStor bucket

```swift
// Swift
let bucket = qsService.bucket(bucketName: "bucketName", zone: "pek3a")
```

```objective-c
// Objective-C
QSBucket *bucket = [qsService bucketWithBucketName:@"bucketName" zone:@"pek3a"];
```

List objects in the bucket

```swift
// Swift
let input = ListObjectsInput()
bucket.listObjects(input: input) { response, error in
    if let response = response {
        print("StatusCode: \(response.statusCode)")
        if response.output.errMessage == nil {
            print("Bucket object count: \(response.output.keys?.count)")
        }
    }
}
```

```objective-c
// Objective-C
QSListObjectsInput *input = [QSListObjectsInput empty];
[bucket listObjectsWithInput:input completion:^(QSListObjectsOutput *output, NSHTTPURLResponse *response, NSError *error) {
    NSLog(@"StatusCode: %ld", response.statusCode);
    NSLog(@"Bucket object count: %ld", output.keys.count);
}];
```

Set ACL of the bucket

```swift
// Swift
let grantee = GranteeModel(name: "QS_ALL_USERS", type: "group")
let acl = ACLModel(grantee: grantee, permission: "FULL_CONTROL")
let input = PutBucketACLInput(acl: [acl])
bucket.putACL(input: input) { response, error in
    if let response = response {
        print("StatusCode: \(response.statusCode)")
    }
}
```

```objective-c
// Objective-C
QSGranteeModel *grantee = [QSGranteeModel empty];
grantee.name = @"QS_ALL_USERS";
grantee.type = @"group";
QSACLModel *acl = [[QSACLModel alloc] initWithGrantee:grantee permission:@"FULL_CONTROL"];
QSPutBucketACLInput *input = [[QSPutBucketACLInput alloc] initWithAcl:@[acl]];
[bucket putACLWithInput:input completion:^(QSPutBucketACLOutput *output, NSHTTPURLResponse *response, NSError *error) {
    NSLog(@"StatusCode: %ld", response.statusCode);
}];
```

Put object

```swift
// Swift
let path = Bundle.main.path(forResource: "image", ofType: "jpeg")!
let objectFileURL = URL(fileURLWithPath: path)
let input = PutObjectInput(contentLength: objectFileURL.contentLength, 
                           contentType: objectFileURL.mimeType,
                           bodyInputStream: InputStream(url: objectFileURL))
bucket.putObject(objectKey:"image.jpeg", input: input) { response, error in
    if let response = response {
        print("StatusCode: \(response.statusCode)")
    }
}
```

```objective-c
// Objective-C
NSString *path = [[NSBundle mainBundle] pathForResource:@"image" ofType:@"jpeg"];
NSURL *objectFileURL = [NSURL fileURLWithPath:path];
QSPutObjectInput *input = [QSPutObjectInput empty];
input.contentLength = [objectFileURL qs_contentLength];
input.contentType = [objectFileURL qs_mimeType];
input.bodyInputStream = [[NSInputStream alloc] initWithURL:objectFileURL];
[bucket putObjectWithObjectKey:@"image.jpeg" input:input completion:^(QSPutObjectOutput *output, NSHTTPURLResponse *response, NSError *error) {
    NSLog(@"StatusCode: %ld", response.statusCode);
}];
```

Delete object

```swift
// Swift
bucket.deleteObject(objectKey:"image.jpeg") { response, error in
    if let response = response {
        print("StatusCode: \(response.statusCode)")
    }
}
```

```objective-c
// Objective-C
QSDeleteObjectInput *input = [QSDeleteObjectInput empty];
[bucket deleteObjectWithObjectKey:@"image.jpeg" input:input completion:^(QSDeleteObjectOutput *output, NSHTTPURLResponse *response, NSError *error) {
    NSLog(@"StatusCode: %ld", response.statusCode);
}];
```

Initialize Multipart Upload

```swift
// Swift
let input = InitiateMultipartUploadInput(contentType: "video/quicktime")
bucket.initiateMultipartUpload(objectKey: "video.mov", input: input) { response, error in
    if let response = response {
        print("StatusCode: \(response.statusCode)")
        if response.output.errMessage == nil {
            print("UploadID: \(response.output.uploadID)")
        }
    }
}
```

```objective-c
// Objective-C
QSInitiateMultipartUploadInput *input = [QSInitiateMultipartUploadInput empty];
[bucket initiateMultipartUploadWithObjectKey:@"video.mov" input:input completion:^(QSInitiateMultipartUploadOutput *output, NSHTTPURLResponse *response, NSError *error) {
    NSLog(@"StatusCode: %ld", response.statusCode);
    NSLog(@"UploadID: %@", output.uploadID);
}];
```

Upload Multipart

```swift
// Swift
let path = Bundle.main.path(forResource: "video", ofType: "mov")!
let objectFileURL = URL(fileURLWithPath: path)
let contentLength = objectFileURL.contentLength
var partContentLength = 4 * 1024 * 1024
var partCount = contentLength / partContentLength
if contentLength % partContentLength > 0 {
    partCount += 1
}

let fileHandle = try! FileHandle(forReadingFrom: objectFileURL)
for partNumber in 0 ..< partCount {
    if partNumber == partCount - 1 {
        partContentLength = contentLength - partNumber * partContentLength
    }
    
    fileHandle.seek(toFileOffset: UInt64(partNumber * partContentLength))
    let data = fileHandle.readData(ofLength: partContentLength)
    let inputStream = InputStream(data: data)
    
    let input = UploadMultipartInput(partNumber: partNumber, 
                                     uploadID: "xxxxxxxxxxxxx", 
                                     contentLength: partContentLength, 
                                     bodyInputStream: inputStream)
    bucket.uploadMultipart(objectKey: "video.mov", input: input) { response, error in
        if let response = response {
            print("StatusCode: \(response.statusCode)")
        }
    }
}

fileHandle.closeFile()
```

```objective-c
// Objective-C
NSString *path = [[NSBundle mainBundle] pathForResource:@"video" ofType:@"mov"];
NSURL *objectFileURL = [NSURL fileURLWithPath:path];
NSInteger contentLength = [objectFileURL qs_contentLength];
NSInteger partContentLength = 4 * 1024 * 1024;
NSInteger partCount = contentLength / partContentLength;
if (contentLength % partContentLength > 0) {
    partCount += 1;
}

NSFileHandle *fileHandle = [NSFileHandle fileHandleForReadingFromURL:objectFileURL error:nil];
for (int partNumber = 0; partNumber < partCount; partNumber++) {
    if (partNumber == partCount - 1) {
        partContentLength = contentLength - partNumber * partContentLength;
    }
    
    [fileHandle seekToFileOffset:partNumber * partContentLength];
    NSData *data = [fileHandle readDataOfLength:partContentLength];
    NSInputStream *inputStream = [NSInputStream inputStreamWithData:data];
    
    QSUploadMultipartInput *input = [QSUploadMultipartInput empty];
    input.partNumber = partNumber;
    input.uploadID = @"xxxxxxxxxxxxx";
    input.contentLength = partContentLength;
    input.bodyInputStream = inputStream;

    [bucket uploadMultipartWithObjectKey:@"video.mov" input:input completion:^(QSUploadMultipartOutput *output, NSHTTPURLResponse *response, NSError *error) {
        NSLog(@"StatusCode: %ld", response.statusCode);
    }];
}

[fileHandle closeFile];
```

Complete Multipart Upload

```swift
// Swift
let objectParts = [ObjectPartModel(partNumber: 0),
                   ObjectPartModel(partNumber: 1)]
let input = CompleteMultipartUploadInput(uploadID: "xxxxxxxxxxxxx", objectParts: objectParts)
bucket.completeMultipartUpload(objectKey: "video.mov", input: input) { response, error in
    if let response = response {
        print("StatusCode: \(response.statusCode)")
    }
}
```

```objective-c
// Objective-C
QSObjectPartModel *part1 = [QSObjectPartModel empty];
part1.partNumber = 0;

QSObjectPartModel *part2 = [QSObjectPartModel empty];
part2.partNumber = 1;

QSCompleteMultipartUploadInput *input = [QSCompleteMultipartUploadInput empty];
input.uploadID = @"xxxxxxxxxxxxx";
input.objectParts = @[part1, part2];

[bucket completeMultipartUploadWithObjectKey:@"video.mov" input:input completion:^(QSCompleteMultipartUploadOutput *output, NSHTTPURLResponse *response, NSError *error) {
    NSLog(@"StatusCode: %ld", response.statusCode);
}];
```

Abort Multipart Upload

```swift
// Swift
let input = AbortMultipartUploadInput(uploadID: "xxxxxxxxxxxxx")
bucket.abortMultipartUpload(objectKey: "video.mov", input: input) { response, error in
    if let response = response {
        print("StatusCode: \(response.statusCode)")
    }
}
```

```objective-c
// Objective-C
QSAbortMultipartUploadInput *input = [QSAbortMultipartUploadInput empty];
input.uploadID = @"xxxxxxxxxxxxx";
[bucket abortMultipartUploadWithObjectKey:@"video.mov" input:input completion:^(QSAbortMultipartUploadOutput *output, NSHTTPURLResponse *response, NSError *error) {
    NSLog(@"StatusCode: %ld", response.statusCode);
}];
```

