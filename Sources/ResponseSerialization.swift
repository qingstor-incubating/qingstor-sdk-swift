//
//  ResponseSerialization.swift
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
import ObjectMapper

fileprivate func append(map: [AnyHashable:Any], to JSONToMap: inout Any) {
    if var jsonMap = JSONToMap as? [AnyHashable:Any] {
        for (key, value) in map {
            jsonMap[key] = value
        }
        JSONToMap = jsonMap
    }
}

extension Request {
    enum ErrorCode: Int {
        case noData = 1
        case dataSerializationFailed = 2
    }

    internal class func newError(_ code: ErrorCode, failureReason: String) -> NSError {
        let errorDomain = "com.qingstor.error"

        let userInfo = [NSLocalizedFailureReasonErrorKey: failureReason]
        let returnError = NSError(domain: errorDomain, code: code.rawValue, userInfo: userInfo)

        return returnError
    }
}

extension DataRequest {

    public class func outputMapperSerializer<T: BaseMappable>(writeHeaders: Bool = false,
                                             keyPath: String?,
                                             mapToObject object: T? = nil,
                                             context: MapContext? = nil) -> DataResponseSerializer<T> {
        return DataResponseSerializer { request, response, data, error in
            guard error == nil else {
                return .failure(error!)
            }

            guard let _ = data else {
                let failureReason = "Data could not be serialized. Input data was nil."
                let error = newError(.noData, failureReason: failureReason)
                return .failure(error)
            }

            var JSONToMap: Any = [:]
            if (data?.count ?? 0) > 0 {
                let jsonResponseSerializer = DataRequest.jsonResponseSerializer(options: .allowFragments)
                let result = jsonResponseSerializer.serializeResponse(request, response, data, error)

                if result.isSuccess {
                    if !(result.value is NSNull) {
                        if let keyPath = keyPath, keyPath.isEmpty == false {
                            JSONToMap = (result.value as AnyObject?)?.value(forKeyPath: keyPath) ?? [:]
                        } else if let value = result.value {
                            JSONToMap = value
                        }
                    }
                }
            }

            if writeHeaders {
                if let headers = response?.allHeaderFields {
                    append(map: headers, to: &JSONToMap)
                }
            }

            if let object = object {
                _ = Mapper<T>().map(JSONObject: JSONToMap, toObject: object)
                return .success(object)
            } else if let parsedObject = Mapper<T>(context: context).map(JSONObject: JSONToMap) {
                return .success(parsedObject)
            }

            let failureReason = "ObjectMapper failed to serialize response."
            let error = newError(.dataSerializationFailed, failureReason: failureReason)
            return .failure(error)
        }
    }

    @discardableResult
    public func responseOutput<T: BaseMappable>(queue: DispatchQueue? = nil,
                               writeHeaders: Bool = false,
                               keyPath: String? = nil,
                               mapToObject object: T? = nil,
                               context: MapContext? = nil,
                               completionHandler: @escaping (DataResponse<T>) -> Void) -> Self {
        let responseSerializer = DataRequest.outputMapperSerializer(writeHeaders: writeHeaders,
                                                                    keyPath: keyPath,
                                                                    mapToObject: object,
                                                                    context: context)
        return response(queue: queue,
                        responseSerializer: responseSerializer,
                        completionHandler: completionHandler)
    }
}

extension DownloadRequest {
    public class func outputMapperSerializer<T: BaseMappable>(writeHeaders: Bool = false,
                                             keyPath: String?,
                                             mapToObject object: T? = nil,
                                             context: MapContext? = nil) -> DownloadResponseSerializer<T> {
        return DownloadResponseSerializer { request, response, fileURL, error in
            guard error == nil else {
                return .failure(error!)
            }

            guard let fileURL = fileURL else {
                let failureReason = "Data could not be serialized. Input data was nil."
                let error = newError(.noData, failureReason: failureReason)
                return .failure(error)
            }

            var JSONToMap: Any = [:]
            let jsonResponseSerializer = DownloadRequest.jsonResponseSerializer(options: .allowFragments)
            let jsonResult = jsonResponseSerializer.serializeResponse(request, response, fileURL, error)
            if jsonResult.isSuccess {
                if !(jsonResult.value is NSNull) {
                    if let keyPath = keyPath, keyPath.isEmpty == false {
                        JSONToMap = (jsonResult.value as AnyObject?)?.value(forKeyPath: keyPath) ?? [:]
                    } else if let value = jsonResult.value {
                        JSONToMap = value
                    }
                }
            }

            append(map: ["destination_url":fileURL], to: &JSONToMap)

            if writeHeaders {
                if let headers = response?.allHeaderFields {
                    append(map: headers, to: &JSONToMap)
                }
            }

            if let object = object {
                _ = Mapper<T>().map(JSONObject: JSONToMap, toObject: object)
                return .success(object)
            } else if let parsedObject = Mapper<T>(context: context).map(JSONObject: JSONToMap) {
                return .success(parsedObject)
            }

            let failureReason = "ObjectMapper failed to serialize response."
            let error = newError(.dataSerializationFailed, failureReason: failureReason)
            return .failure(error)
        }
    }

    @discardableResult
    public func responseOutput<T: BaseMappable>(queue: DispatchQueue? = nil,
                               writeHeaders: Bool = false,
                               keyPath: String? = nil,
                               mapToObject object: T? = nil,
                               context: MapContext? = nil,
                               completionHandler: @escaping (DownloadResponse<T>) -> Void) -> Self {
        let responseSerializer = DownloadRequest.outputMapperSerializer(writeHeaders: writeHeaders,
                                                                        keyPath: keyPath,
                                                                        mapToObject: object,
                                                                        context: context)
        return response(queue: queue,
                        responseSerializer: responseSerializer,
                        completionHandler: completionHandler)
    }
}
