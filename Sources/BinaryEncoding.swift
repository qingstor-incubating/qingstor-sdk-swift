//
//  BinaryEncoding.swift
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
import Alamofire

public struct BinaryEncoding: Alamofire.ParameterEncoding {

    public static var `default`: BinaryEncoding { return BinaryEncoding() }

    public func encode(_ urlRequest: URLRequestConvertible, with parameters: Parameters?) throws -> URLRequest {
        var urlRequest = try urlRequest.asURLRequest()

        guard let parameters = parameters else { return urlRequest }

        for value in parameters.values {
            if let fileURL = value as? URL {
                append(fileURL: fileURL, mimeType: fileURL.mimeType, to: &urlRequest)
                break
            } else if let bodyData = value as? Data {
                append(data: bodyData, to: &urlRequest)
                break
            } else if let stream = value as? InputStream {
                append(stream: stream, to: &urlRequest)
            }
        }

        setupDefaultMimeType(&urlRequest)
        return urlRequest
    }

    func append(fileURL: URL, mimeType: String, to urlRequest: inout URLRequest) {
        guard fileURL.isFileURL else {
            return
        }

        do {
            let isReachable = try fileURL.checkPromisedItemIsReachable()
            guard isReachable else {
                return
            }
        } catch {
            return
        }

        var isDirectory: ObjCBool = false
        let path = fileURL.path
        guard FileManager.default.fileExists(atPath: path, isDirectory: &isDirectory) && !isDirectory.boolValue else {
            return
        }

        let bodyContentLength: UInt64
        do {
            guard let fileSize = try FileManager.default.attributesOfItem(atPath: path)[.size] as? NSNumber else {
                return
            }

            bodyContentLength = fileSize.uint64Value
        } catch {
            return
        }

        guard let stream = InputStream(url: fileURL) else {
            return
        }

        if urlRequest.value(forHTTPHeaderField: "Content-Type") == nil {
            urlRequest.setValue(mimeType, forHTTPHeaderField: "Content-Type")
        }

        if urlRequest.value(forHTTPHeaderField: "Content-Length") == nil {
            urlRequest.setValue(String(bodyContentLength), forHTTPHeaderField: "Content-Length")
        }

        urlRequest.httpBodyStream = stream
    }

    func append(data: Data, to urlRequest: inout URLRequest) {
        if urlRequest.value(forHTTPHeaderField: "Content-Length") == nil {
            urlRequest.setValue(String(UInt64(data.count)), forHTTPHeaderField: "Content-Length")
        }

        urlRequest.httpBody = data
    }

    func append(stream: InputStream, to urlRequest: inout URLRequest) {
        urlRequest.httpBodyStream = stream
    }

    func setupDefaultMimeType(_ urlRequest: inout URLRequest) {
        if urlRequest.value(forHTTPHeaderField: "Content-Type") == nil {
            urlRequest.setValue(APIHelper.mimeType(forPathExtension: ""), forHTTPHeaderField: "Content-Type")
        }
    }
}
