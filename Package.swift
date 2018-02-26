import PackageDescription

let package = Package(
    name: "QingStorSDK",
    dependencies: [
        .Package(url: "https://github.com/Alamofire/Alamofire.git", majorVersion: 4, minor: 6),
        .Package(url: "https://github.com/Hearst-DD/ObjectMapper.git", majorVersion: 3, minor: 1),
        .Package(url: "https://github.com/krzyzanowskim/CryptoSwift.git", majorVersion: 0, minor: 7)
        ],
    exclude: ["Tests"]
)
