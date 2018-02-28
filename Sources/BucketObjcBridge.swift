//
// BucketObjcBridge.swift
//
// +-------------------------------------------------------------------------
// | Copyright (C) 2018 Yunify, Inc.
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

extension Bucket {

    // delete: Delete a bucket.
    // Documentation URL: https://docs.qingcloud.com/qingstor/api/bucket/delete.html
    @objc public func delete(input: DeleteBucketInput = DeleteBucketInput(), completion: @escaping (_ output: DeleteBucketOutput?, _ response: HTTPURLResponse?, _ error: Error?) -> Void) {
    	self.delete(input: input) { response, error in
            if let response = response {
                completion(response.output, response.rawResponse, error)
            } else {
                completion(nil, nil, error)
            }
        }
    }

    // deleteSender create sender of delete.
    @objc public func deleteSender(input: DeleteBucketInput = DeleteBucketInput()) -> APISenderResult {
        let (sender, error) = self.deleteSender(input: input)

        return APISenderResult(sender: sender, error: error)
    }

    // deleteCORS: Delete CORS information of the bucket.
    // Documentation URL: https://docs.qingcloud.com/qingstor/api/bucket/cors/delete_cors.html
    @objc public func deleteCORS(input: DeleteBucketCORSInput = DeleteBucketCORSInput(), completion: @escaping (_ output: DeleteBucketCORSOutput?, _ response: HTTPURLResponse?, _ error: Error?) -> Void) {
    	self.deleteCORS(input: input) { response, error in
            if let response = response {
                completion(response.output, response.rawResponse, error)
            } else {
                completion(nil, nil, error)
            }
        }
    }

    // deleteCORSSender create sender of deleteCORS.
    @objc public func deleteCORSSender(input: DeleteBucketCORSInput = DeleteBucketCORSInput()) -> APISenderResult {
        let (sender, error) = self.deleteCORSSender(input: input)

        return APISenderResult(sender: sender, error: error)
    }

    // deleteExternalMirror: Delete external mirror of the bucket.
    // Documentation URL: https://docs.qingcloud.com/qingstor/api/bucket/external_mirror/delete_external_mirror.html
    @objc public func deleteExternalMirror(input: DeleteBucketExternalMirrorInput = DeleteBucketExternalMirrorInput(), completion: @escaping (_ output: DeleteBucketExternalMirrorOutput?, _ response: HTTPURLResponse?, _ error: Error?) -> Void) {
    	self.deleteExternalMirror(input: input) { response, error in
            if let response = response {
                completion(response.output, response.rawResponse, error)
            } else {
                completion(nil, nil, error)
            }
        }
    }

    // deleteExternalMirrorSender create sender of deleteExternalMirror.
    @objc public func deleteExternalMirrorSender(input: DeleteBucketExternalMirrorInput = DeleteBucketExternalMirrorInput()) -> APISenderResult {
        let (sender, error) = self.deleteExternalMirrorSender(input: input)

        return APISenderResult(sender: sender, error: error)
    }

    // deletePolicy: Delete policy information of the bucket.
    // Documentation URL: https://docs.qingcloud.com/qingstor/api/bucket/policy/delete_policy.html
    @objc public func deletePolicy(input: DeleteBucketPolicyInput = DeleteBucketPolicyInput(), completion: @escaping (_ output: DeleteBucketPolicyOutput?, _ response: HTTPURLResponse?, _ error: Error?) -> Void) {
    	self.deletePolicy(input: input) { response, error in
            if let response = response {
                completion(response.output, response.rawResponse, error)
            } else {
                completion(nil, nil, error)
            }
        }
    }

    // deletePolicySender create sender of deletePolicy.
    @objc public func deletePolicySender(input: DeleteBucketPolicyInput = DeleteBucketPolicyInput()) -> APISenderResult {
        let (sender, error) = self.deletePolicySender(input: input)

        return APISenderResult(sender: sender, error: error)
    }

    // deleteMultipleObjects: Delete multiple objects from the bucket.
    // Documentation URL: https://docs.qingcloud.com/qingstor/api/bucket/delete_multiple.html
    @objc public func deleteMultipleObjects(input: DeleteMultipleObjectsInput, completion: @escaping (_ output: DeleteMultipleObjectsOutput?, _ response: HTTPURLResponse?, _ error: Error?) -> Void) {
    	self.deleteMultipleObjects(input: input) { response, error in
            if let response = response {
                completion(response.output, response.rawResponse, error)
            } else {
                completion(nil, nil, error)
            }
        }
    }

    // deleteMultipleObjectsSender create sender of deleteMultipleObjects.
    @objc public func deleteMultipleObjectsSender(input: DeleteMultipleObjectsInput) -> APISenderResult {
        let (sender, error) = self.deleteMultipleObjectsSender(input: input)

        return APISenderResult(sender: sender, error: error)
    }

    // getACL: Get ACL information of the bucket.
    // Documentation URL: https://docs.qingcloud.com/qingstor/api/bucket/get_acl.html
    @objc public func getACL(input: GetBucketACLInput = GetBucketACLInput(), completion: @escaping (_ output: GetBucketACLOutput?, _ response: HTTPURLResponse?, _ error: Error?) -> Void) {
    	self.getACL(input: input) { response, error in
            if let response = response {
                completion(response.output, response.rawResponse, error)
            } else {
                completion(nil, nil, error)
            }
        }
    }

    // getACLSender create sender of getACL.
    @objc public func getACLSender(input: GetBucketACLInput = GetBucketACLInput()) -> APISenderResult {
        let (sender, error) = self.getACLSender(input: input)

        return APISenderResult(sender: sender, error: error)
    }

    // getCORS: Get CORS information of the bucket.
    // Documentation URL: https://docs.qingcloud.com/qingstor/api/bucket/cors/get_cors.html
    @objc public func getCORS(input: GetBucketCORSInput = GetBucketCORSInput(), completion: @escaping (_ output: GetBucketCORSOutput?, _ response: HTTPURLResponse?, _ error: Error?) -> Void) {
    	self.getCORS(input: input) { response, error in
            if let response = response {
                completion(response.output, response.rawResponse, error)
            } else {
                completion(nil, nil, error)
            }
        }
    }

    // getCORSSender create sender of getCORS.
    @objc public func getCORSSender(input: GetBucketCORSInput = GetBucketCORSInput()) -> APISenderResult {
        let (sender, error) = self.getCORSSender(input: input)

        return APISenderResult(sender: sender, error: error)
    }

    // getExternalMirror: Get external mirror of the bucket.
    // Documentation URL: https://docs.qingcloud.com/qingstor/api/bucket/external_mirror/get_external_mirror.html
    @objc public func getExternalMirror(input: GetBucketExternalMirrorInput = GetBucketExternalMirrorInput(), completion: @escaping (_ output: GetBucketExternalMirrorOutput?, _ response: HTTPURLResponse?, _ error: Error?) -> Void) {
    	self.getExternalMirror(input: input) { response, error in
            if let response = response {
                completion(response.output, response.rawResponse, error)
            } else {
                completion(nil, nil, error)
            }
        }
    }

    // getExternalMirrorSender create sender of getExternalMirror.
    @objc public func getExternalMirrorSender(input: GetBucketExternalMirrorInput = GetBucketExternalMirrorInput()) -> APISenderResult {
        let (sender, error) = self.getExternalMirrorSender(input: input)

        return APISenderResult(sender: sender, error: error)
    }

    // getPolicy: Get policy information of the bucket.
    // Documentation URL: https://https://docs.qingcloud.com/qingstor/api/bucket/policy/get_policy.html
    @objc public func getPolicy(input: GetBucketPolicyInput = GetBucketPolicyInput(), completion: @escaping (_ output: GetBucketPolicyOutput?, _ response: HTTPURLResponse?, _ error: Error?) -> Void) {
    	self.getPolicy(input: input) { response, error in
            if let response = response {
                completion(response.output, response.rawResponse, error)
            } else {
                completion(nil, nil, error)
            }
        }
    }

    // getPolicySender create sender of getPolicy.
    @objc public func getPolicySender(input: GetBucketPolicyInput = GetBucketPolicyInput()) -> APISenderResult {
        let (sender, error) = self.getPolicySender(input: input)

        return APISenderResult(sender: sender, error: error)
    }

    // getStatistics: Get statistics information of the bucket.
    // Documentation URL: https://docs.qingcloud.com/qingstor/api/bucket/get_stats.html
    @objc public func getStatistics(input: GetBucketStatisticsInput = GetBucketStatisticsInput(), completion: @escaping (_ output: GetBucketStatisticsOutput?, _ response: HTTPURLResponse?, _ error: Error?) -> Void) {
    	self.getStatistics(input: input) { response, error in
            if let response = response {
                completion(response.output, response.rawResponse, error)
            } else {
                completion(nil, nil, error)
            }
        }
    }

    // getStatisticsSender create sender of getStatistics.
    @objc public func getStatisticsSender(input: GetBucketStatisticsInput = GetBucketStatisticsInput()) -> APISenderResult {
        let (sender, error) = self.getStatisticsSender(input: input)

        return APISenderResult(sender: sender, error: error)
    }

    // head: Check whether the bucket exists and available.
    // Documentation URL: https://docs.qingcloud.com/qingstor/api/bucket/head.html
    @objc public func head(input: HeadBucketInput = HeadBucketInput(), completion: @escaping (_ output: HeadBucketOutput?, _ response: HTTPURLResponse?, _ error: Error?) -> Void) {
    	self.head(input: input) { response, error in
            if let response = response {
                completion(response.output, response.rawResponse, error)
            } else {
                completion(nil, nil, error)
            }
        }
    }

    // headSender create sender of head.
    @objc public func headSender(input: HeadBucketInput = HeadBucketInput()) -> APISenderResult {
        let (sender, error) = self.headSender(input: input)

        return APISenderResult(sender: sender, error: error)
    }

    // listMultipartUploads: List multipart uploads in the bucket.
    // Documentation URL: https://docs.qingcloud.com/qingstor/api/bucket/list_multipart_uploads.html
    @objc public func listMultipartUploads(input: ListMultipartUploadsInput, completion: @escaping (_ output: ListMultipartUploadsOutput?, _ response: HTTPURLResponse?, _ error: Error?) -> Void) {
    	self.listMultipartUploads(input: input) { response, error in
            if let response = response {
                completion(response.output, response.rawResponse, error)
            } else {
                completion(nil, nil, error)
            }
        }
    }

    // listMultipartUploadsSender create sender of listMultipartUploads.
    @objc public func listMultipartUploadsSender(input: ListMultipartUploadsInput) -> APISenderResult {
        let (sender, error) = self.listMultipartUploadsSender(input: input)

        return APISenderResult(sender: sender, error: error)
    }

    // listObjects: Retrieve the object list in a bucket.
    // Documentation URL: https://docs.qingcloud.com/qingstor/api/bucket/get.html
    @objc public func listObjects(input: ListObjectsInput, completion: @escaping (_ output: ListObjectsOutput?, _ response: HTTPURLResponse?, _ error: Error?) -> Void) {
    	self.listObjects(input: input) { response, error in
            if let response = response {
                completion(response.output, response.rawResponse, error)
            } else {
                completion(nil, nil, error)
            }
        }
    }

    // listObjectsSender create sender of listObjects.
    @objc public func listObjectsSender(input: ListObjectsInput) -> APISenderResult {
        let (sender, error) = self.listObjectsSender(input: input)

        return APISenderResult(sender: sender, error: error)
    }

    // put: Create a new bucket.
    // Documentation URL: https://docs.qingcloud.com/qingstor/api/bucket/put.html
    @objc public func put(input: PutBucketInput = PutBucketInput(), completion: @escaping (_ output: PutBucketOutput?, _ response: HTTPURLResponse?, _ error: Error?) -> Void) {
    	self.put(input: input) { response, error in
            if let response = response {
                completion(response.output, response.rawResponse, error)
            } else {
                completion(nil, nil, error)
            }
        }
    }

    // putSender create sender of put.
    @objc public func putSender(input: PutBucketInput = PutBucketInput()) -> APISenderResult {
        let (sender, error) = self.putSender(input: input)

        return APISenderResult(sender: sender, error: error)
    }

    // putACL: Set ACL information of the bucket.
    // Documentation URL: https://docs.qingcloud.com/qingstor/api/bucket/put_acl.html
    @objc public func putACL(input: PutBucketACLInput, completion: @escaping (_ output: PutBucketACLOutput?, _ response: HTTPURLResponse?, _ error: Error?) -> Void) {
    	self.putACL(input: input) { response, error in
            if let response = response {
                completion(response.output, response.rawResponse, error)
            } else {
                completion(nil, nil, error)
            }
        }
    }

    // putACLSender create sender of putACL.
    @objc public func putACLSender(input: PutBucketACLInput) -> APISenderResult {
        let (sender, error) = self.putACLSender(input: input)

        return APISenderResult(sender: sender, error: error)
    }

    // putCORS: Set CORS information of the bucket.
    // Documentation URL: https://docs.qingcloud.com/qingstor/api/bucket/cors/put_cors.html
    @objc public func putCORS(input: PutBucketCORSInput, completion: @escaping (_ output: PutBucketCORSOutput?, _ response: HTTPURLResponse?, _ error: Error?) -> Void) {
    	self.putCORS(input: input) { response, error in
            if let response = response {
                completion(response.output, response.rawResponse, error)
            } else {
                completion(nil, nil, error)
            }
        }
    }

    // putCORSSender create sender of putCORS.
    @objc public func putCORSSender(input: PutBucketCORSInput) -> APISenderResult {
        let (sender, error) = self.putCORSSender(input: input)

        return APISenderResult(sender: sender, error: error)
    }

    // putExternalMirror: Set external mirror of the bucket.
    // Documentation URL: https://docs.qingcloud.com/qingstor/api/bucket/external_mirror/put_external_mirror.html
    @objc public func putExternalMirror(input: PutBucketExternalMirrorInput, completion: @escaping (_ output: PutBucketExternalMirrorOutput?, _ response: HTTPURLResponse?, _ error: Error?) -> Void) {
    	self.putExternalMirror(input: input) { response, error in
            if let response = response {
                completion(response.output, response.rawResponse, error)
            } else {
                completion(nil, nil, error)
            }
        }
    }

    // putExternalMirrorSender create sender of putExternalMirror.
    @objc public func putExternalMirrorSender(input: PutBucketExternalMirrorInput) -> APISenderResult {
        let (sender, error) = self.putExternalMirrorSender(input: input)

        return APISenderResult(sender: sender, error: error)
    }

    // putPolicy: Set policy information of the bucket.
    // Documentation URL: https://docs.qingcloud.com/qingstor/api/bucket/policy/put_policy.html
    @objc public func putPolicy(input: PutBucketPolicyInput, completion: @escaping (_ output: PutBucketPolicyOutput?, _ response: HTTPURLResponse?, _ error: Error?) -> Void) {
    	self.putPolicy(input: input) { response, error in
            if let response = response {
                completion(response.output, response.rawResponse, error)
            } else {
                completion(nil, nil, error)
            }
        }
    }

    // putPolicySender create sender of putPolicy.
    @objc public func putPolicySender(input: PutBucketPolicyInput) -> APISenderResult {
        let (sender, error) = self.putPolicySender(input: input)

        return APISenderResult(sender: sender, error: error)
    }

    // abortMultipartUpload: Abort multipart upload.
    // Documentation URL: https://docs.qingcloud.com/qingstor/api/object/abort_multipart_upload.html
    @objc public func abortMultipartUpload(objectKey: String, input: AbortMultipartUploadInput, completion: @escaping (_ output: AbortMultipartUploadOutput?, _ response: HTTPURLResponse?, _ error: Error?) -> Void) {
    	self.abortMultipartUpload(objectKey: objectKey, input: input) { response, error in
            if let response = response {
                completion(response.output, response.rawResponse, error)
            } else {
                completion(nil, nil, error)
            }
        }
    }

    // abortMultipartUploadSender create sender of abortMultipartUpload.
    @objc public func abortMultipartUploadSender(objectKey: String, input: AbortMultipartUploadInput) -> APISenderResult {
        let (sender, error) = self.abortMultipartUploadSender(objectKey: objectKey, input: input)

        return APISenderResult(sender: sender, error: error)
    }

    // completeMultipartUpload: Complete multipart upload.
    // Documentation URL: https://docs.qingcloud.com/qingstor/api/object/complete_multipart_upload.html
    @objc public func completeMultipartUpload(objectKey: String, input: CompleteMultipartUploadInput, completion: @escaping (_ output: CompleteMultipartUploadOutput?, _ response: HTTPURLResponse?, _ error: Error?) -> Void) {
    	self.completeMultipartUpload(objectKey: objectKey, input: input) { response, error in
            if let response = response {
                completion(response.output, response.rawResponse, error)
            } else {
                completion(nil, nil, error)
            }
        }
    }

    // completeMultipartUploadSender create sender of completeMultipartUpload.
    @objc public func completeMultipartUploadSender(objectKey: String, input: CompleteMultipartUploadInput) -> APISenderResult {
        let (sender, error) = self.completeMultipartUploadSender(objectKey: objectKey, input: input)

        return APISenderResult(sender: sender, error: error)
    }

    // deleteObject: Delete the object.
    // Documentation URL: https://docs.qingcloud.com/qingstor/api/object/delete.html
    @objc public func deleteObject(objectKey: String, input: DeleteObjectInput = DeleteObjectInput(), completion: @escaping (_ output: DeleteObjectOutput?, _ response: HTTPURLResponse?, _ error: Error?) -> Void) {
    	self.deleteObject(objectKey: objectKey, input: input) { response, error in
            if let response = response {
                completion(response.output, response.rawResponse, error)
            } else {
                completion(nil, nil, error)
            }
        }
    }

    // deleteObjectSender create sender of deleteObject.
    @objc public func deleteObjectSender(objectKey: String, input: DeleteObjectInput = DeleteObjectInput()) -> APISenderResult {
        let (sender, error) = self.deleteObjectSender(objectKey: objectKey, input: input)

        return APISenderResult(sender: sender, error: error)
    }

    // getObject: Retrieve the object.
    // Documentation URL: https://docs.qingcloud.com/qingstor/api/object/get.html
    @objc public func getObject(objectKey: String, input: GetObjectInput, completion: @escaping (_ output: GetObjectOutput?, _ response: HTTPURLResponse?, _ error: Error?) -> Void) {
    	self.getObject(objectKey: objectKey, input: input) { response, error in
            if let response = response {
                completion(response.output, response.rawResponse, error)
            } else {
                completion(nil, nil, error)
            }
        }
    }

    // getObjectSender create sender of getObject.
    @objc public func getObjectSender(objectKey: String, input: GetObjectInput) -> APISenderResult {
        let (sender, error) = self.getObjectSender(objectKey: objectKey, input: input)

        return APISenderResult(sender: sender, error: error)
    }

    // headObject: Check whether the object exists and available.
    // Documentation URL: https://docs.qingcloud.com/qingstor/api/object/head.html
    @objc public func headObject(objectKey: String, input: HeadObjectInput, completion: @escaping (_ output: HeadObjectOutput?, _ response: HTTPURLResponse?, _ error: Error?) -> Void) {
    	self.headObject(objectKey: objectKey, input: input) { response, error in
            if let response = response {
                completion(response.output, response.rawResponse, error)
            } else {
                completion(nil, nil, error)
            }
        }
    }

    // headObjectSender create sender of headObject.
    @objc public func headObjectSender(objectKey: String, input: HeadObjectInput) -> APISenderResult {
        let (sender, error) = self.headObjectSender(objectKey: objectKey, input: input)

        return APISenderResult(sender: sender, error: error)
    }

    // imageProcess: Image process with the action on the object
    // Documentation URL: https://docs.qingcloud.com/qingstor/data_process/image_process/index.html
    @objc public func imageProcess(objectKey: String, input: ImageProcessInput, completion: @escaping (_ output: ImageProcessOutput?, _ response: HTTPURLResponse?, _ error: Error?) -> Void) {
    	self.imageProcess(objectKey: objectKey, input: input) { response, error in
            if let response = response {
                completion(response.output, response.rawResponse, error)
            } else {
                completion(nil, nil, error)
            }
        }
    }

    // imageProcessSender create sender of imageProcess.
    @objc public func imageProcessSender(objectKey: String, input: ImageProcessInput) -> APISenderResult {
        let (sender, error) = self.imageProcessSender(objectKey: objectKey, input: input)

        return APISenderResult(sender: sender, error: error)
    }

    // initiateMultipartUpload: Initial multipart upload on the object.
    // Documentation URL: https://docs.qingcloud.com/qingstor/api/object/initiate_multipart_upload.html
    @objc public func initiateMultipartUpload(objectKey: String, input: InitiateMultipartUploadInput, completion: @escaping (_ output: InitiateMultipartUploadOutput?, _ response: HTTPURLResponse?, _ error: Error?) -> Void) {
    	self.initiateMultipartUpload(objectKey: objectKey, input: input) { response, error in
            if let response = response {
                completion(response.output, response.rawResponse, error)
            } else {
                completion(nil, nil, error)
            }
        }
    }

    // initiateMultipartUploadSender create sender of initiateMultipartUpload.
    @objc public func initiateMultipartUploadSender(objectKey: String, input: InitiateMultipartUploadInput) -> APISenderResult {
        let (sender, error) = self.initiateMultipartUploadSender(objectKey: objectKey, input: input)

        return APISenderResult(sender: sender, error: error)
    }

    // listMultipart: List object parts.
    // Documentation URL: https://docs.qingcloud.com/qingstor/api/object/list_multipart.html
    @objc public func listMultipart(objectKey: String, input: ListMultipartInput, completion: @escaping (_ output: ListMultipartOutput?, _ response: HTTPURLResponse?, _ error: Error?) -> Void) {
    	self.listMultipart(objectKey: objectKey, input: input) { response, error in
            if let response = response {
                completion(response.output, response.rawResponse, error)
            } else {
                completion(nil, nil, error)
            }
        }
    }

    // listMultipartSender create sender of listMultipart.
    @objc public func listMultipartSender(objectKey: String, input: ListMultipartInput) -> APISenderResult {
        let (sender, error) = self.listMultipartSender(objectKey: objectKey, input: input)

        return APISenderResult(sender: sender, error: error)
    }

    // optionsObject: Check whether the object accepts a origin with method and header.
    // Documentation URL: https://docs.qingcloud.com/qingstor/api/object/options.html
    @objc public func optionsObject(objectKey: String, input: OptionsObjectInput, completion: @escaping (_ output: OptionsObjectOutput?, _ response: HTTPURLResponse?, _ error: Error?) -> Void) {
    	self.optionsObject(objectKey: objectKey, input: input) { response, error in
            if let response = response {
                completion(response.output, response.rawResponse, error)
            } else {
                completion(nil, nil, error)
            }
        }
    }

    // optionsObjectSender create sender of optionsObject.
    @objc public func optionsObjectSender(objectKey: String, input: OptionsObjectInput) -> APISenderResult {
        let (sender, error) = self.optionsObjectSender(objectKey: objectKey, input: input)

        return APISenderResult(sender: sender, error: error)
    }

    // putObject: Upload the object.
    // Documentation URL: https://docs.qingcloud.com/qingstor/api/object/put.html
    @objc public func putObject(objectKey: String, input: PutObjectInput, completion: @escaping (_ output: PutObjectOutput?, _ response: HTTPURLResponse?, _ error: Error?) -> Void) {
    	self.putObject(objectKey: objectKey, input: input) { response, error in
            if let response = response {
                completion(response.output, response.rawResponse, error)
            } else {
                completion(nil, nil, error)
            }
        }
    }

    // putObjectSender create sender of putObject.
    @objc public func putObjectSender(objectKey: String, input: PutObjectInput) -> APISenderResult {
        let (sender, error) = self.putObjectSender(objectKey: objectKey, input: input)

        return APISenderResult(sender: sender, error: error)
    }

    // uploadMultipart: Upload object multipart.
    // Documentation URL: https://docs.qingcloud.com/qingstor/api/object/multipart/upload_multipart.html
    @objc public func uploadMultipart(objectKey: String, input: UploadMultipartInput, completion: @escaping (_ output: UploadMultipartOutput?, _ response: HTTPURLResponse?, _ error: Error?) -> Void) {
    	self.uploadMultipart(objectKey: objectKey, input: input) { response, error in
            if let response = response {
                completion(response.output, response.rawResponse, error)
            } else {
                completion(nil, nil, error)
            }
        }
    }

    // uploadMultipartSender create sender of uploadMultipart.
    @objc public func uploadMultipartSender(objectKey: String, input: UploadMultipartInput) -> APISenderResult {
        let (sender, error) = self.uploadMultipartSender(objectKey: objectKey, input: input)

        return APISenderResult(sender: sender, error: error)
    }

}

extension DeleteBucketInput {
    @objc public static func empty() -> DeleteBucketInput {
        return DeleteBucketInput()
    }
}

extension DeleteBucketCORSInput {
    @objc public static func empty() -> DeleteBucketCORSInput {
        return DeleteBucketCORSInput()
    }
}

extension DeleteBucketExternalMirrorInput {
    @objc public static func empty() -> DeleteBucketExternalMirrorInput {
        return DeleteBucketExternalMirrorInput()
    }
}

extension DeleteBucketPolicyInput {
    @objc public static func empty() -> DeleteBucketPolicyInput {
        return DeleteBucketPolicyInput()
    }
}

extension DeleteMultipleObjectsInput {
    @objc public static func empty() -> DeleteMultipleObjectsInput {
        return DeleteMultipleObjectsInput(objects: [], quiet: false)
    }
}

extension GetBucketACLInput {
    @objc public static func empty() -> GetBucketACLInput {
        return GetBucketACLInput()
    }
}

extension GetBucketCORSInput {
    @objc public static func empty() -> GetBucketCORSInput {
        return GetBucketCORSInput()
    }
}

extension GetBucketExternalMirrorInput {
    @objc public static func empty() -> GetBucketExternalMirrorInput {
        return GetBucketExternalMirrorInput()
    }
}

extension GetBucketPolicyInput {
    @objc public static func empty() -> GetBucketPolicyInput {
        return GetBucketPolicyInput()
    }
}

extension GetBucketStatisticsInput {
    @objc public static func empty() -> GetBucketStatisticsInput {
        return GetBucketStatisticsInput()
    }
}

extension HeadBucketInput {
    @objc public static func empty() -> HeadBucketInput {
        return HeadBucketInput()
    }
}

extension ListMultipartUploadsInput {
    @objc public static func empty() -> ListMultipartUploadsInput {
        return ListMultipartUploadsInput(delimiter: nil, keyMarker: nil, limit: Int.min, prefix: nil, uploadIDMarker: nil)
    }
}

extension ListObjectsInput {
    @objc public static func empty() -> ListObjectsInput {
        return ListObjectsInput(delimiter: nil, limit: Int.min, marker: nil, prefix: nil)
    }
}

extension PutBucketInput {
    @objc public static func empty() -> PutBucketInput {
        return PutBucketInput()
    }
}

extension PutBucketACLInput {
    @objc public static func empty() -> PutBucketACLInput {
        return PutBucketACLInput(acl: [])
    }
}

extension PutBucketCORSInput {
    @objc public static func empty() -> PutBucketCORSInput {
        return PutBucketCORSInput(corsRules: [])
    }
}

extension PutBucketExternalMirrorInput {
    @objc public static func empty() -> PutBucketExternalMirrorInput {
        return PutBucketExternalMirrorInput(sourceSite: "")
    }
}

extension PutBucketPolicyInput {
    @objc public static func empty() -> PutBucketPolicyInput {
        return PutBucketPolicyInput(statement: [])
    }
}

extension AbortMultipartUploadInput {
    @objc public static func empty() -> AbortMultipartUploadInput {
        return AbortMultipartUploadInput(uploadID: "")
    }
}

extension CompleteMultipartUploadInput {
    @objc public static func empty() -> CompleteMultipartUploadInput {
        return CompleteMultipartUploadInput(uploadID: "", etag: nil, xQSEncryptionCustomerAlgorithm: nil, xQSEncryptionCustomerKey: nil, xQSEncryptionCustomerKeyMD5: nil, objectParts: nil)
    }
}

extension DeleteObjectInput {
    @objc public static func empty() -> DeleteObjectInput {
        return DeleteObjectInput()
    }
}

extension GetObjectInput {
    @objc public static func empty() -> GetObjectInput {
        return GetObjectInput(responseCacheControl: nil, responseContentDisposition: nil, responseContentEncoding: nil, responseContentLanguage: nil, responseContentType: nil, responseExpires: nil, ifMatch: nil, ifModifiedSince: nil, ifNoneMatch: nil, ifUnmodifiedSince: nil, range: nil, xQSEncryptionCustomerAlgorithm: nil, xQSEncryptionCustomerKey: nil, xQSEncryptionCustomerKeyMD5: nil)
    }
}

extension HeadObjectInput {
    @objc public static func empty() -> HeadObjectInput {
        return HeadObjectInput(ifMatch: nil, ifModifiedSince: nil, ifNoneMatch: nil, ifUnmodifiedSince: nil, xQSEncryptionCustomerAlgorithm: nil, xQSEncryptionCustomerKey: nil, xQSEncryptionCustomerKeyMD5: nil)
    }
}

extension ImageProcessInput {
    @objc public static func empty() -> ImageProcessInput {
        return ImageProcessInput(action: "", responseCacheControl: nil, responseContentDisposition: nil, responseContentEncoding: nil, responseContentLanguage: nil, responseContentType: nil, responseExpires: nil, ifModifiedSince: nil)
    }
}

extension InitiateMultipartUploadInput {
    @objc public static func empty() -> InitiateMultipartUploadInput {
        return InitiateMultipartUploadInput(contentType: nil, xQSEncryptionCustomerAlgorithm: nil, xQSEncryptionCustomerKey: nil, xQSEncryptionCustomerKeyMD5: nil)
    }
}

extension ListMultipartInput {
    @objc public static func empty() -> ListMultipartInput {
        return ListMultipartInput(limit: Int.min, partNumberMarker: Int.min, uploadID: "")
    }
}

extension OptionsObjectInput {
    @objc public static func empty() -> OptionsObjectInput {
        return OptionsObjectInput(accessControlRequestHeaders: nil, accessControlRequestMethod: "", origin: "")
    }
}

extension PutObjectInput {
    @objc public static func empty() -> PutObjectInput {
        return PutObjectInput(contentLength: Int.min, contentMD5: nil, contentType: nil, expect: nil, xQSCopySource: nil, xQSCopySourceEncryptionCustomerAlgorithm: nil, xQSCopySourceEncryptionCustomerKey: nil, xQSCopySourceEncryptionCustomerKeyMD5: nil, xQSCopySourceIfMatch: nil, xQSCopySourceIfModifiedSince: nil, xQSCopySourceIfNoneMatch: nil, xQSCopySourceIfUnmodifiedSince: nil, xQSEncryptionCustomerAlgorithm: nil, xQSEncryptionCustomerKey: nil, xQSEncryptionCustomerKeyMD5: nil, xQSFetchIfUnmodifiedSince: nil, xQSFetchSource: nil, xQSMoveSource: nil, bodyInputStream: nil)
    }
}

extension UploadMultipartInput {
    @objc public static func empty() -> UploadMultipartInput {
        return UploadMultipartInput(partNumber: Int.min, uploadID: "", contentLength: Int.min, contentMD5: nil, xQSCopyRange: nil, xQSCopySource: nil, xQSCopySourceEncryptionCustomerAlgorithm: nil, xQSCopySourceEncryptionCustomerKey: nil, xQSCopySourceEncryptionCustomerKeyMD5: nil, xQSCopySourceIfMatch: nil, xQSCopySourceIfModifiedSince: nil, xQSCopySourceIfNoneMatch: nil, xQSCopySourceIfUnmodifiedSince: nil, xQSEncryptionCustomerAlgorithm: nil, xQSEncryptionCustomerKey: nil, xQSEncryptionCustomerKeyMD5: nil, bodyInputStream: nil)
    }
}
