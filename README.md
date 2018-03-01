# QingStor SDK for Swift

[![Build Status](https://travis-ci.org/yunify/qingstor-sdk-swift.svg?branch=master)](https://travis-ci.org/yunify/qingstor-sdk-swift)
[![CocoaPods Compatible](https://img.shields.io/cocoapods/v/QingStorSDK.svg)](https://github.com/yunify/qingstor-sdk-swift)
[![API Reference](http://img.shields.io/badge/api-reference-green.svg)](http://docs.qingcloud.com/qingstor/)
[![License](http://img.shields.io/badge/license-apache%20v2-blue.svg)](https://github.com/yunify/qingstor-sdk-swift/blob/master/LICENSE)

The official QingStor SDK for the Swift programming language.

## Getting Started

### Swift versions support

Below is a table that shows which version of QingCloudSDK you should use for your Swift version.

| Swift Version | QingCloudSDK Version |
| ------------- | -------------------- |
| 3.x           | <= 2.4.0             |
| 4.x           | >= 2.4.1             |

### Installation

Refer to the [Installation Guide](docs/installation.md), and have this SDK installed.

### Preparation

Before your start, please go to [QingCloud Console](https://console.qingcloud.com/access_keys/) to create a pair of QingCloud API AccessKey.

___API AccessKey Example:___

```yaml
access_key_id: 'ACCESS_KEY_ID_EXAMPLE'
secret_access_key: 'SECRET_ACCESS_KEY_EXAMPLE'
```

### Usage

Now you are ready to code. You can read the detailed guides in the list below to have a clear understanding or just take the quick start code example.

Checkout our [releases](https://github.com/yunify/qingstor-sdk-swift/releases) and [change log](https://github.com/yunify/qingstor-sdk-swift/blob/master/CHANGELOG.md) for information about the latest features, bug fixes and new ideas.

- [Configuration Guide](docs/configuration.md)
- [QingStor Service Usage Guide](docs/qingstor_service_usage.md)
- ​[Image Processing Usage Guide](docs/image_processing_usage.md)

___Quick Start Code Example:___

```swift
import QingStorSDK

func main() {
    Registry.register(accessKeyID: "ACCESS_KEY_ID", secretAccessKey: "SECRET_ACCESS_KEY")
    let qsService = QingStor()
    qsService.listBuckets(input: ListBucketsInput()) { response, error in
        // Print HTTP status code.
        print("\(response?.statusCode)")
        
        // Print the count of buckets.
        print("\(response?.output.count)")
        
        // Print the first bucket name.
        print("\(response?.output.buckets?[0].name)")
    }
}
```

## Demos

- [qingstor-sdk-swift-demo](https://github.com/qychrisyang/qingstor-sdk-swift-demo)
- [qingstor-sdk-objc-demo](https://github.com/qychrisyang/qingstor-sdk-objc-demo)

## Reference Documentations

- [QingStor Documentation](https://docs.qingcloud.com/qingstor/index.html)
- [QingStor Guide](https://docs.qingcloud.com/qingstor/guide/index.html)
- [QingStor APIs](https://docs.qingcloud.com/qingstor/api/index.html)

## Contributing

1. Fork it ( [https://github.com/yunify/qingstor-sdk-swift/fork](https://github.com/yunify/qingstor-sdk-swift/fork) )
2. Create your feature branch (git checkout -b new-feature)
3. Commit your changes (git commit -asm 'Add some feature')
4. Push to the branch (git push origin new-feature)
5. Create a new Pull Request

## LICENSE

The Apache License (Version 2.0, January 2004).
