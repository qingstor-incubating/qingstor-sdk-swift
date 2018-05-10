//
//  APIHelper.swift
//
// +-------------------------------------------------------------------------
// | Copyright (C) 2016 Yunify, Inc.
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
import CryptoSwift

#if os(iOS) || os(watchOS) || os(tvOS)
    import MobileCoreServices
#elseif os(macOS)
    import CoreServices
#endif

class APIHelper {
    class func buildQueryString(parameters: inout [String:Any], escaped: Bool = true) -> String {
        parameters = serialize(parameters: parameters)

        return query(from: parameters, escaped: escaped)
    }

    class func serialize(parameters: [String:Any]) -> [String:Any] {
        var components: [String:Any] = [:]

        for (key, value) in parameters {
            serialize(to: &components, key: key, value: value)
        }

        return components
    }

    fileprivate class func serialize(to parameters: inout [String:Any], key: String, value: Any) {
        if let dictionary = value as? [String: Any] {
            for (nestedKey, nestedValue) in dictionary {
                serialize(to: &parameters, key: "\(key).\(nestedKey)", value: nestedValue)
            }
        } else if let array = value as? [Any] {
            for (index, value) in array.enumerated() {
                serialize(to: &parameters, key: "\(key).\(index + 1)", value: value)
            }
        } else {
            parameters[key] = value
        }
    }

    class func query(from parameters: [String:Any], escaped: Bool = true) -> String {
        var components: [(String, String)] = []

        for key in parameters.keys.sorted(by: <) {
            let value = parameters[key]!
            components.append(queryComponents(key: key, value: value, escaped: escaped))
        }

        return components.map {
                if $1.isEmpty {
                    return $0
                } else {
                    return "\($0)=\($1)"
                }
            }.joined(separator: "&")
    }

    fileprivate class func queryComponents(key: String, value: Any, escaped: Bool = true) -> (String, String) {
        var escape: (String) -> String = { return $0 }
        if escaped {
            escape = { return $0.escape() }
        }

        if let value = value as? NSNumber {
            if value.isBoolValue {
                return (escape(key), escape(value.boolValue ? "1" : "0"))
            } else {
                return (escape(key), escape("\(value)"))
            }
        } else if let bool = value as? Bool {
            return (escape(key), escape(bool ? "1" : "0"))
        } else {
            return (escape(key), escape("\(value)"))
        }
    }

    class func mimeType(forPathExtension pathExtension: String) -> String {
        if let id = UTTypeCreatePreferredIdentifierForTag(kUTTagClassFilenameExtension, pathExtension as CFString, nil)?.takeRetainedValue(),
            let contentType = UTTypeCopyPreferredTagWithClass(id, kUTTagClassMIMEType)?.takeRetainedValue() {
            return contentType as String
        }

        return "application/octet-stream"
    }
}

extension NSNumber {
    var isBoolValue: Bool { return CFBooleanGetTypeID() == CFGetTypeID(self) }
}

extension String {
    func hmacSHA256Data(key: String) throws -> Data {
        do {
            let hmac = HMAC(key: Array(key.utf8), variant: .sha256)
            let data = try Data(bytes: hmac.authenticate(Array(self.utf8)))

            return data
        } catch {
            throw APIError.encodingError(info: "hmac sha256 encoding error")
        }
    }

    func allowedCharacterSet() -> CharacterSet {
        let generalDelimitersToEncode = ":#[]@"
        let subDelimitersToEncode = "!$&'()*+,;="

        var allowedCharacterSet = CharacterSet.urlQueryAllowed
        allowedCharacterSet.remove(charactersIn: "\(generalDelimitersToEncode)\(subDelimitersToEncode)")

        return allowedCharacterSet
    }

    func escape() -> String {
        return self.addingPercentEncoding(withAllowedCharacters: self.allowedCharacterSet()) ?? self
    }

    func unescape() -> String {
        return self.removingPercentEncoding ?? self
    }

    func escapeNonASCIIOnly() -> String {
        return self.addingPercentEncoding(withAllowedCharacters: CharacterSet().inverted) ?? self
    }

    func urlPathEscape() -> String {
        return self.addingPercentEncoding(withAllowedCharacters: .urlPathAllowed) ?? self
    }

    func toDate(format: String) -> Date? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        dateFormatter.timeZone = TimeZone(abbreviation: "UTC")
        return dateFormatter.date(from: self)
    }

    func toISO8601Date() -> Date? {
        return toDate(format: "yyyy-MM-dd'T'HH:mm:ss'Z'")
    }

    func toRFC822Date() -> Date? {
        return toDate(format: "EEE, dd MMM yyyy HH:mm:ss z")
    }

    static func date(format: String, date: Date = Date()) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        dateFormatter.timeZone = TimeZone(abbreviation: "UTC")
        return dateFormatter.string(from: date)
    }

    static func ISO8601(date: Date = Date()) -> String {
        return self.date(format: "yyyy-MM-dd'T'HH:mm:ss'Z'", date: date)
    }

    static func RFC822(date: Date = Date()) -> String {
        return self.date(format: "EEE, dd MMM yyyy HH:mm:ss z", date: date)
    }
}

public extension URL {
    /// The size of file in bytes.
    public var contentLength: Int {
        var length = 0

        do {
            if self.isFileURL {
                let path = self.path
                let fileManager = FileManager.default
                if fileManager.fileExists(atPath: path) {
                    let fileInfo = try fileManager.attributesOfItem(atPath: path)
                    length = fileInfo[FileAttributeKey.size] as! Int
                }
            }
        } catch { }

        return length
    }

    /// The MIME type to associate with the data in the `Content-Type` HTTP header.
    public var mimeType: String {
        return APIHelper.mimeType(forPathExtension: self.pathExtension)
    }
}
