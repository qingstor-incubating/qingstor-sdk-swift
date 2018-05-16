# Change Log
All notable changes to QingStor SDK for Swift will be documented in this file.

## [v2.8.0] - 2018-05-16

### Added
- Add storage class support.

### BREAKING CHANGE
- Make `objectParts` variable required of `CompleteMultipartUploadInput`.

## [v2.7.0] - 2018-05-10

### Added
- Add progress callback of api request.
- Add left and top parameters in crop image process.

### BREAKING CHANGE
- Rename the APIContext property name from urlString to baseURL
- Rename the APIContext and APISender method names from qingStor to qingstor

## [v2.6.0] - 2018-01-12

### Added
- Compatible with objective-c.

## [v2.5.0] - 2018-01-12

### Added
- Add CustomizedSigner to handle custom signatures.

## [v2.4.1] - 2017-09-27

### Improved
- Support swift 4.0.

## [v2.4.0] - 2017-08-16

### Added
- Add image process API.
- Add ImageProcessor util class to generate image processing result.

## [v2.3.0] - 2017-07-09

### Change
- Add contentLength field in GetObjectOutput.
- Add multipart copy and range support.

### BREAKING CHANGE
- Remove default zone setting.
- Initializing Bucket must provide the zone parameter.

## [v2.2.0] - 2016-03-11

### Fixed
- Fix signer & request builder bug.

### Added
- Add list multipart uploads API.

## [v2.1.0] - 2016-12-26

### Changed
- Fix signer bug.
- Add more parameters to sign.

### Added
- Add request parameters for GET Object.
- Add IP address conditions for bucket policy.

## [v2.0.1] - 2016-12-15

### Changed
- Improve the implementation of deleting multiple objects.

## [v2.0.0] - 2016-12-14

### Added
- QingStor SDK for the Swift programming language.

[v2.8.0]: https://github.com/yunify/qingstor-sdk-swift/compare/v2.7.0...v2.8.0
[v2.7.0]: https://github.com/yunify/qingstor-sdk-swift/compare/v2.6.0...v2.7.0
[v2.6.0]: https://github.com/yunify/qingstor-sdk-swift/compare/v2.5.0...v2.6.0
[v2.5.0]: https://github.com/yunify/qingstor-sdk-swift/compare/v2.4.1...v2.5.0
[v2.4.1]: https://github.com/yunify/qingstor-sdk-swift/compare/v2.4.0...v2.4.1
[v2.4.0]: https://github.com/yunify/qingstor-sdk-swift/compare/v2.3.0...v2.4.0
[v2.3.0]: https://github.com/yunify/qingstor-sdk-swift/compare/v2.2.0...v2.3.0
[v2.2.0]: https://github.com/yunify/qingstor-sdk-swift/compare/v2.1.0...v2.2.0
[v2.1.0]: https://github.com/yunify/qingstor-sdk-swift/compare/v2.0.1...v2.1.0
[v2.0.1]: https://github.com/yunify/qingstor-sdk-swift/compare/v2.0.0...v2.0.1
[v2.0.0]: https://github.com/yunify/qingstor-sdk-swift/compare/v2.0.0...v2.0.0
