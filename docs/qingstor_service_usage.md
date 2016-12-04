# QingStor Service Usage Guide

Import the QingStorSDK and initialize service with a context, and you are ready to use the initialized service. Service only contains one API, and it is "ListBuckets".
To use bucket related APIs, you need to initialize a bucket from service using "bucket" function. 

Each API function take a Input struct and get a Response struct at closure. The Input struct consists of request params, request headers, request elements and request body, and the Response holds the response of `HTTPURLResponse` and Output struct. The Output struct consists of QingStor request ID, response headers, response elements, response body and error  (if error occurred).

``` swift
import QingStorSDK
```

### Code Snippet

Initialize the QingStor service with a configuration

``` swift
let context = try! APIContext(plist: configURL)
let qsService = QingStor(context: context, zone: "zone")
```

List buckets

``` swift
let input = ListBucketsInput()
qsService.listBuckets(input: input) { response, error in
    if let response = response {
        print("StatusCode: \(response.response.statusCode)")
    	if response.output.errMessage == nil {
            print("Bucket count: \(response.output.count)")
            print("First bucket name: \(response.output.buckets?[0].name)")
    	}
    }
}
```

Initialize a QingStor bucket

``` swift
let bucket = qsService.bucket(bucketName: "bucketName")
```

List objects in the bucket

``` swift
let input = ListObjectsInput()
bucket.listObjects(input: input) { response, error in
    if let response = response {
    	print("StatusCode: \(response.response.statusCode)")
    	if response.output.errMessage == nil {
    		print("Bucket object count: \(response.output.keys?.count)")
    	}
    }
}
```

Set ACL of the bucket

``` swift
let grantee = GranteeModel(name: "QS_ALL_USERS", type: "group")
let acl = ACLModel(grantee: grantee, permission: "FULL_CONTROL")
let input = PutBucketACLInput(acl: [acl])
bucket.putACL(input: input) { response, error in
    if let response = response {
        print("StatusCode: \(response.response.statusCode)")
    }
}
```

Put object

``` swift
let path = Bundle.main.path(forResource: "image", ofType: "jpeg")!
let objectFileURL = URL(fileURLWithPath: path)
let input = PutObjectInput(contentLength: objectFileURL.contentLength, 
						   contentType: objectFileURL.mimeType,
						   bodyInputStream: InputStream(url: objectFileURL))
bucket.putObject(objectKey:"image.jpeg", input: input) { response, error in
    if let response = response {
        print("StatusCode: \(response.response.statusCode)")
    }
}
```

Delete object

``` swift
bucket.deleteObject(objectKey:"image.jpeg") { response, error in
    if let response = response {
        print("StatusCode: \(response.response.statusCode)")
    }
}
```

Initialize Multipart Upload

``` swift
let input = InitiateMultipartUploadInput(contentType: "video/quicktime")
bucket.initiateMultipartUpload(objectKey: "video.mov", input: input) { 
	response, error in
    if let response = response {
    	print("StatusCode: \(response.response.statusCode)")
        if response.output.errMessage == nil {
        	print("UploadID: \(response.output.uploadID)")
        }
    }
}
```

Upload Multipart

``` swift
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
    							     uploadID: "xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx", 
    							     contentLength: partContentLength, 
    							     bodyInputStream: inputStream)
    bucket.uploadMultipart(objectKey: "video.mov", input: input) { response, error in
        if let response = response {
        	print("StatusCode: \(response.response.statusCode)")
        }
    }
}

fileHandle.closeFile()
```

Complete Multipart Upload

``` swift
let objectParts = [ObjectPartModel(partNumber: 0),
                   ObjectPartModel(partNumber: 1)]
let input = CompleteMultipartUploadInput(uploadID: "xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx", 											 objectParts: objectParts)
bucket.completeMultipartUpload(objectKey: "video.mov", input: input) { response, error in
    if let response = response {
        print("StatusCode: \(response.response.statusCode)")
    }
}
```

Abort Multipart Upload

``` swift
let input = AbortMultipartUploadInput(uploadID: "xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx")
bucket.abortMultipartUpload(objectKey: "video.mov", input: input) { response, error in
    if let response = response {
        print("StatusCode: \(response.response.statusCode)")
    }
}
```
