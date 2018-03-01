# Configuration Guide

## Summary

This SDK uses a plist file to configure context information, except for AccessKeyID and SecretAccessKey, you can also configure the API servers for private cloud usage scenario. All available configureable items are list in default configuration file.

___Default Configuration File:___

```xml
<dict>
	<key>access_key_id</key>
	<string>ACCESS_KEY_ID</string>
	<key>secret_access_key</key>
	<string>SECRET_ACCESS_KEY</string>
	<key>protocol</key>
	<string>https</string>
	<key>host</key>
	<string>qingstor.com</string>
	<key>port</key>
	<string>443</string>
</dict>
```

## Usage

#### Configure general context for the entire SDK

You can use `Registry` to register AccessKeyID and SecretAccessKey to the general context information for the entire SDK

```swift
// Swift
Registry.register(accessKeyID: "ACCESS_KEY_ID", secretAccessKey: "SECRET_ACCESS_KEY")
```

```objective-c
// Objective-C
[QSRegistry registerWithAccessKeyID:@"ACCESS_KEY_ID" secretAccessKey:@"SECRET_ACCESS_KEY"];
```

Can also use the plist file to register:

```swift
// Swift
Registry.registerFrom(plist: configURL)
```

```objective-c
// Objective-C
[QSRegistry registerFromPlist:url error:nil];
```

#### Create API context

```swift
// Swift
let context = APIContext(urlString: "https://api.private.com:4433")
```

```objective-c
// Objective-C
QSAPIContext *context = [[QSAPIContext alloc] initWithUrlString:@"https://api.private.com:4433"];
```

Can also use the plist file to create:

```swift
// Swift
let context = try! APIContext(plist: configURL)
```

```objective-c
// Objective-C
QSAPIContext *context = [[QSAPIContext alloc] initWithPlist:configURL error:nil];
```

Change API server:

```swift
// Swift
var context = try! APIContext(plist: configURL)
context.`protocol` = "https"
context.host = "api.private.com"
context.port = 4433
```

```objective-c
// Objective-C
QSAPIContext *context = [[QSAPIContext alloc] initWithPlist:configURL error:nil];
context.protocol = @"https";
context.host = @"api.private.com";
context.portNumber = @4433;
```
