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
    @objc public convenience init(context: APIContext,
                                  bucketName: String,
                                  zone: String) {
        self.init(context: context,
                  bucketName: bucketName,
                  zone: zone,
                  signer: QingStorSigner(),
                  credential: nil,
                  buildingQueue: DispatchQueue.global(),
                  callbackQueue: DispatchQueue.main)
    }

    @objc public convenience init(context: APIContext,
                                  bucketName: String,
                                  zone: String,
                                  credential: URLCredential?,
                                  buildingQueue: DispatchQueue,
                                  callbackQueue: DispatchQueue) {
        self.init(context: context,
                  bucketName: bucketName,
                  zone: zone,
                  signer: QingStorSigner(),
                  credential: credential,
                  buildingQueue: buildingQueue,
                  callbackQueue: callbackQueue)
    }

    @objc public convenience init(bucketName: String,
                                  zone: String,
                                  qingstorSigner: QingStorSigner) {
        self.init(bucketName: bucketName,
                  zone: zone,
                  signer: qingstorSigner)
    }

    @objc public convenience init(context: APIContext,
                                  bucketName: String,
                                  zone: String,
                                  qingstorSigner: QingStorSigner) {
        self.init(context: context,
                  bucketName: bucketName,
                  zone: zone,
                  signer: qingstorSigner)
    }

    @objc public convenience init(bucketName: String,
                                  zone: String,
                                  customizedSigner: CustomizedSigner) {
        self.init(bucketName: bucketName,
                  zone: zone,
                  signer: customizedSigner)
    }

    @objc public convenience init(context: APIContext,
                                  bucketName: String,
                                  zone: String,
                                  customizedSigner: CustomizedSigner) {
        self.init(context: context,
                  bucketName: bucketName,
                  zone: zone,
                  signer: customizedSigner)
    }

    /// delete: Delete a bucket.
    /// Documentation URL: https://docs.qingcloud.com/qingstor/api/bucket/delete.html
    @objc public func delete(input: DeleteBucketInput = DeleteBucketInput(), progress: RequestProgress?, completion: @escaping (DeleteBucketOutput?, HTTPURLResponse?, Error?) -> Void) {
    	  self.delete(input: input, progress: progress) { response, error in
            completion(response?.output, response?.rawResponse, error)
        }
    }
    /// delete: Delete a bucket.
    /// Documentation URL: https://docs.qingcloud.com/qingstor/api/bucket/delete.html
    @objc public func delete(input: DeleteBucketInput = DeleteBucketInput(), completion: @escaping (DeleteBucketOutput?, HTTPURLResponse?, Error?) -> Void) {
        self.delete(input: input, progress: nil, completion: completion)
    }

    /// deleteSender create sender of delete.
    @objc public func deleteSender(input: DeleteBucketInput = DeleteBucketInput()) -> APISenderResult {
        let (sender, error) = self.deleteSender(input: input)
        return APISenderResult(sender: sender, error: error)
    }
    
    /// deleteCORS: Delete CORS information of the bucket.
    /// Documentation URL: https://docs.qingcloud.com/qingstor/api/bucket/cors/delete_cors.html
    @objc public func deleteCORS(input: DeleteBucketCORSInput = DeleteBucketCORSInput(), progress: RequestProgress?, completion: @escaping (DeleteBucketCORSOutput?, HTTPURLResponse?, Error?) -> Void) {
    	  self.deleteCORS(input: input, progress: progress) { response, error in
            completion(response?.output, response?.rawResponse, error)
        }
    }
    /// deleteCORS: Delete CORS information of the bucket.
    /// Documentation URL: https://docs.qingcloud.com/qingstor/api/bucket/cors/delete_cors.html
    @objc public func deleteCORS(input: DeleteBucketCORSInput = DeleteBucketCORSInput(), completion: @escaping (DeleteBucketCORSOutput?, HTTPURLResponse?, Error?) -> Void) {
        self.deleteCORS(input: input, progress: nil, completion: completion)
    }

    /// deleteCORSSender create sender of deleteCORS.
    @objc public func deleteCORSSender(input: DeleteBucketCORSInput = DeleteBucketCORSInput()) -> APISenderResult {
        let (sender, error) = self.deleteCORSSender(input: input)
        return APISenderResult(sender: sender, error: error)
    }
    
    /// deleteExternalMirror: Delete external mirror of the bucket.
    /// Documentation URL: https://docs.qingcloud.com/qingstor/api/bucket/external_mirror/delete_external_mirror.html
    @objc public func deleteExternalMirror(input: DeleteBucketExternalMirrorInput = DeleteBucketExternalMirrorInput(), progress: RequestProgress?, completion: @escaping (DeleteBucketExternalMirrorOutput?, HTTPURLResponse?, Error?) -> Void) {
    	  self.deleteExternalMirror(input: input, progress: progress) { response, error in
            completion(response?.output, response?.rawResponse, error)
        }
    }
    /// deleteExternalMirror: Delete external mirror of the bucket.
    /// Documentation URL: https://docs.qingcloud.com/qingstor/api/bucket/external_mirror/delete_external_mirror.html
    @objc public func deleteExternalMirror(input: DeleteBucketExternalMirrorInput = DeleteBucketExternalMirrorInput(), completion: @escaping (DeleteBucketExternalMirrorOutput?, HTTPURLResponse?, Error?) -> Void) {
        self.deleteExternalMirror(input: input, progress: nil, completion: completion)
    }

    /// deleteExternalMirrorSender create sender of deleteExternalMirror.
    @objc public func deleteExternalMirrorSender(input: DeleteBucketExternalMirrorInput = DeleteBucketExternalMirrorInput()) -> APISenderResult {
        let (sender, error) = self.deleteExternalMirrorSender(input: input)
        return APISenderResult(sender: sender, error: error)
    }
    
    /// deleteLifecycle: Delete Lifecycle information of the bucket.
    /// Documentation URL: https://docs.qingcloud.com/qingstor/api/bucket/lifecycle/delete_lifecycle.html
    @objc public func deleteLifecycle(input: DeleteBucketLifecycleInput = DeleteBucketLifecycleInput(), progress: RequestProgress?, completion: @escaping (DeleteBucketLifecycleOutput?, HTTPURLResponse?, Error?) -> Void) {
    	  self.deleteLifecycle(input: input, progress: progress) { response, error in
            completion(response?.output, response?.rawResponse, error)
        }
    }
    /// deleteLifecycle: Delete Lifecycle information of the bucket.
    /// Documentation URL: https://docs.qingcloud.com/qingstor/api/bucket/lifecycle/delete_lifecycle.html
    @objc public func deleteLifecycle(input: DeleteBucketLifecycleInput = DeleteBucketLifecycleInput(), completion: @escaping (DeleteBucketLifecycleOutput?, HTTPURLResponse?, Error?) -> Void) {
        self.deleteLifecycle(input: input, progress: nil, completion: completion)
    }

    /// deleteLifecycleSender create sender of deleteLifecycle.
    @objc public func deleteLifecycleSender(input: DeleteBucketLifecycleInput = DeleteBucketLifecycleInput()) -> APISenderResult {
        let (sender, error) = self.deleteLifecycleSender(input: input)
        return APISenderResult(sender: sender, error: error)
    }
    
    /// deleteNotification: Delete Notification information of the bucket.
    /// Documentation URL: https://docs.qingcloud.com/qingstor/api/bucket/notification/delete_notification.html
    @objc public func deleteNotification(input: DeleteBucketNotificationInput = DeleteBucketNotificationInput(), progress: RequestProgress?, completion: @escaping (DeleteBucketNotificationOutput?, HTTPURLResponse?, Error?) -> Void) {
    	  self.deleteNotification(input: input, progress: progress) { response, error in
            completion(response?.output, response?.rawResponse, error)
        }
    }
    /// deleteNotification: Delete Notification information of the bucket.
    /// Documentation URL: https://docs.qingcloud.com/qingstor/api/bucket/notification/delete_notification.html
    @objc public func deleteNotification(input: DeleteBucketNotificationInput = DeleteBucketNotificationInput(), completion: @escaping (DeleteBucketNotificationOutput?, HTTPURLResponse?, Error?) -> Void) {
        self.deleteNotification(input: input, progress: nil, completion: completion)
    }

    /// deleteNotificationSender create sender of deleteNotification.
    @objc public func deleteNotificationSender(input: DeleteBucketNotificationInput = DeleteBucketNotificationInput()) -> APISenderResult {
        let (sender, error) = self.deleteNotificationSender(input: input)
        return APISenderResult(sender: sender, error: error)
    }
    
    /// deletePolicy: Delete policy information of the bucket.
    /// Documentation URL: https://docs.qingcloud.com/qingstor/api/bucket/policy/delete_policy.html
    @objc public func deletePolicy(input: DeleteBucketPolicyInput = DeleteBucketPolicyInput(), progress: RequestProgress?, completion: @escaping (DeleteBucketPolicyOutput?, HTTPURLResponse?, Error?) -> Void) {
    	  self.deletePolicy(input: input, progress: progress) { response, error in
            completion(response?.output, response?.rawResponse, error)
        }
    }
    /// deletePolicy: Delete policy information of the bucket.
    /// Documentation URL: https://docs.qingcloud.com/qingstor/api/bucket/policy/delete_policy.html
    @objc public func deletePolicy(input: DeleteBucketPolicyInput = DeleteBucketPolicyInput(), completion: @escaping (DeleteBucketPolicyOutput?, HTTPURLResponse?, Error?) -> Void) {
        self.deletePolicy(input: input, progress: nil, completion: completion)
    }

    /// deletePolicySender create sender of deletePolicy.
    @objc public func deletePolicySender(input: DeleteBucketPolicyInput = DeleteBucketPolicyInput()) -> APISenderResult {
        let (sender, error) = self.deletePolicySender(input: input)
        return APISenderResult(sender: sender, error: error)
    }
    
    /// deleteMultipleObjects: Delete multiple objects from the bucket.
    /// Documentation URL: https://docs.qingcloud.com/qingstor/api/bucket/delete_multiple.html
    @objc public func deleteMultipleObjects(input: DeleteMultipleObjectsInput, progress: RequestProgress?, completion: @escaping (DeleteMultipleObjectsOutput?, HTTPURLResponse?, Error?) -> Void) {
    	  self.deleteMultipleObjects(input: input, progress: progress) { response, error in
            completion(response?.output, response?.rawResponse, error)
        }
    }
    /// deleteMultipleObjects: Delete multiple objects from the bucket.
    /// Documentation URL: https://docs.qingcloud.com/qingstor/api/bucket/delete_multiple.html
    @objc public func deleteMultipleObjects(input: DeleteMultipleObjectsInput, completion: @escaping (DeleteMultipleObjectsOutput?, HTTPURLResponse?, Error?) -> Void) {
        self.deleteMultipleObjects(input: input, progress: nil, completion: completion)
    }

    /// deleteMultipleObjectsSender create sender of deleteMultipleObjects.
    @objc public func deleteMultipleObjectsSender(input: DeleteMultipleObjectsInput) -> APISenderResult {
        let (sender, error) = self.deleteMultipleObjectsSender(input: input)
        return APISenderResult(sender: sender, error: error)
    }
    
    /// getACL: Get ACL information of the bucket.
    /// Documentation URL: https://docs.qingcloud.com/qingstor/api/bucket/get_acl.html
    @objc public func getACL(input: GetBucketACLInput = GetBucketACLInput(), progress: RequestProgress?, completion: @escaping (GetBucketACLOutput?, HTTPURLResponse?, Error?) -> Void) {
    	  self.getACL(input: input, progress: progress) { response, error in
            completion(response?.output, response?.rawResponse, error)
        }
    }
    /// getACL: Get ACL information of the bucket.
    /// Documentation URL: https://docs.qingcloud.com/qingstor/api/bucket/get_acl.html
    @objc public func getACL(input: GetBucketACLInput = GetBucketACLInput(), completion: @escaping (GetBucketACLOutput?, HTTPURLResponse?, Error?) -> Void) {
        self.getACL(input: input, progress: nil, completion: completion)
    }

    /// getACLSender create sender of getACL.
    @objc public func getACLSender(input: GetBucketACLInput = GetBucketACLInput()) -> APISenderResult {
        let (sender, error) = self.getACLSender(input: input)
        return APISenderResult(sender: sender, error: error)
    }
    
    /// getCORS: Get CORS information of the bucket.
    /// Documentation URL: https://docs.qingcloud.com/qingstor/api/bucket/cors/get_cors.html
    @objc public func getCORS(input: GetBucketCORSInput = GetBucketCORSInput(), progress: RequestProgress?, completion: @escaping (GetBucketCORSOutput?, HTTPURLResponse?, Error?) -> Void) {
    	  self.getCORS(input: input, progress: progress) { response, error in
            completion(response?.output, response?.rawResponse, error)
        }
    }
    /// getCORS: Get CORS information of the bucket.
    /// Documentation URL: https://docs.qingcloud.com/qingstor/api/bucket/cors/get_cors.html
    @objc public func getCORS(input: GetBucketCORSInput = GetBucketCORSInput(), completion: @escaping (GetBucketCORSOutput?, HTTPURLResponse?, Error?) -> Void) {
        self.getCORS(input: input, progress: nil, completion: completion)
    }

    /// getCORSSender create sender of getCORS.
    @objc public func getCORSSender(input: GetBucketCORSInput = GetBucketCORSInput()) -> APISenderResult {
        let (sender, error) = self.getCORSSender(input: input)
        return APISenderResult(sender: sender, error: error)
    }
    
    /// getExternalMirror: Get external mirror of the bucket.
    /// Documentation URL: https://docs.qingcloud.com/qingstor/api/bucket/external_mirror/get_external_mirror.html
    @objc public func getExternalMirror(input: GetBucketExternalMirrorInput = GetBucketExternalMirrorInput(), progress: RequestProgress?, completion: @escaping (GetBucketExternalMirrorOutput?, HTTPURLResponse?, Error?) -> Void) {
    	  self.getExternalMirror(input: input, progress: progress) { response, error in
            completion(response?.output, response?.rawResponse, error)
        }
    }
    /// getExternalMirror: Get external mirror of the bucket.
    /// Documentation URL: https://docs.qingcloud.com/qingstor/api/bucket/external_mirror/get_external_mirror.html
    @objc public func getExternalMirror(input: GetBucketExternalMirrorInput = GetBucketExternalMirrorInput(), completion: @escaping (GetBucketExternalMirrorOutput?, HTTPURLResponse?, Error?) -> Void) {
        self.getExternalMirror(input: input, progress: nil, completion: completion)
    }

    /// getExternalMirrorSender create sender of getExternalMirror.
    @objc public func getExternalMirrorSender(input: GetBucketExternalMirrorInput = GetBucketExternalMirrorInput()) -> APISenderResult {
        let (sender, error) = self.getExternalMirrorSender(input: input)
        return APISenderResult(sender: sender, error: error)
    }
    
    /// getLifecycle: Get Lifecycle information of the bucket.
    /// Documentation URL: https://docs.qingcloud.com/qingstor/api/bucket/lifecycle/get_lifecycle.html
    @objc public func getLifecycle(input: GetBucketLifecycleInput = GetBucketLifecycleInput(), progress: RequestProgress?, completion: @escaping (GetBucketLifecycleOutput?, HTTPURLResponse?, Error?) -> Void) {
    	  self.getLifecycle(input: input, progress: progress) { response, error in
            completion(response?.output, response?.rawResponse, error)
        }
    }
    /// getLifecycle: Get Lifecycle information of the bucket.
    /// Documentation URL: https://docs.qingcloud.com/qingstor/api/bucket/lifecycle/get_lifecycle.html
    @objc public func getLifecycle(input: GetBucketLifecycleInput = GetBucketLifecycleInput(), completion: @escaping (GetBucketLifecycleOutput?, HTTPURLResponse?, Error?) -> Void) {
        self.getLifecycle(input: input, progress: nil, completion: completion)
    }

    /// getLifecycleSender create sender of getLifecycle.
    @objc public func getLifecycleSender(input: GetBucketLifecycleInput = GetBucketLifecycleInput()) -> APISenderResult {
        let (sender, error) = self.getLifecycleSender(input: input)
        return APISenderResult(sender: sender, error: error)
    }
    
    /// getNotification: Get Notification information of the bucket.
    /// Documentation URL: https://docs.qingcloud.com/qingstor/api/bucket/notification/get_notification.html
    @objc public func getNotification(input: GetBucketNotificationInput = GetBucketNotificationInput(), progress: RequestProgress?, completion: @escaping (GetBucketNotificationOutput?, HTTPURLResponse?, Error?) -> Void) {
    	  self.getNotification(input: input, progress: progress) { response, error in
            completion(response?.output, response?.rawResponse, error)
        }
    }
    /// getNotification: Get Notification information of the bucket.
    /// Documentation URL: https://docs.qingcloud.com/qingstor/api/bucket/notification/get_notification.html
    @objc public func getNotification(input: GetBucketNotificationInput = GetBucketNotificationInput(), completion: @escaping (GetBucketNotificationOutput?, HTTPURLResponse?, Error?) -> Void) {
        self.getNotification(input: input, progress: nil, completion: completion)
    }

    /// getNotificationSender create sender of getNotification.
    @objc public func getNotificationSender(input: GetBucketNotificationInput = GetBucketNotificationInput()) -> APISenderResult {
        let (sender, error) = self.getNotificationSender(input: input)
        return APISenderResult(sender: sender, error: error)
    }
    
    /// getPolicy: Get policy information of the bucket.
    /// Documentation URL: https://https://docs.qingcloud.com/qingstor/api/bucket/policy/get_policy.html
    @objc public func getPolicy(input: GetBucketPolicyInput = GetBucketPolicyInput(), progress: RequestProgress?, completion: @escaping (GetBucketPolicyOutput?, HTTPURLResponse?, Error?) -> Void) {
    	  self.getPolicy(input: input, progress: progress) { response, error in
            completion(response?.output, response?.rawResponse, error)
        }
    }
    /// getPolicy: Get policy information of the bucket.
    /// Documentation URL: https://https://docs.qingcloud.com/qingstor/api/bucket/policy/get_policy.html
    @objc public func getPolicy(input: GetBucketPolicyInput = GetBucketPolicyInput(), completion: @escaping (GetBucketPolicyOutput?, HTTPURLResponse?, Error?) -> Void) {
        self.getPolicy(input: input, progress: nil, completion: completion)
    }

    /// getPolicySender create sender of getPolicy.
    @objc public func getPolicySender(input: GetBucketPolicyInput = GetBucketPolicyInput()) -> APISenderResult {
        let (sender, error) = self.getPolicySender(input: input)
        return APISenderResult(sender: sender, error: error)
    }
    
    /// getStatistics: Get statistics information of the bucket.
    /// Documentation URL: https://docs.qingcloud.com/qingstor/api/bucket/get_stats.html
    @objc public func getStatistics(input: GetBucketStatisticsInput = GetBucketStatisticsInput(), progress: RequestProgress?, completion: @escaping (GetBucketStatisticsOutput?, HTTPURLResponse?, Error?) -> Void) {
    	  self.getStatistics(input: input, progress: progress) { response, error in
            completion(response?.output, response?.rawResponse, error)
        }
    }
    /// getStatistics: Get statistics information of the bucket.
    /// Documentation URL: https://docs.qingcloud.com/qingstor/api/bucket/get_stats.html
    @objc public func getStatistics(input: GetBucketStatisticsInput = GetBucketStatisticsInput(), completion: @escaping (GetBucketStatisticsOutput?, HTTPURLResponse?, Error?) -> Void) {
        self.getStatistics(input: input, progress: nil, completion: completion)
    }

    /// getStatisticsSender create sender of getStatistics.
    @objc public func getStatisticsSender(input: GetBucketStatisticsInput = GetBucketStatisticsInput()) -> APISenderResult {
        let (sender, error) = self.getStatisticsSender(input: input)
        return APISenderResult(sender: sender, error: error)
    }
    
    /// head: Check whether the bucket exists and available.
    /// Documentation URL: https://docs.qingcloud.com/qingstor/api/bucket/head.html
    @objc public func head(input: HeadBucketInput = HeadBucketInput(), progress: RequestProgress?, completion: @escaping (HeadBucketOutput?, HTTPURLResponse?, Error?) -> Void) {
    	  self.head(input: input, progress: progress) { response, error in
            completion(response?.output, response?.rawResponse, error)
        }
    }
    /// head: Check whether the bucket exists and available.
    /// Documentation URL: https://docs.qingcloud.com/qingstor/api/bucket/head.html
    @objc public func head(input: HeadBucketInput = HeadBucketInput(), completion: @escaping (HeadBucketOutput?, HTTPURLResponse?, Error?) -> Void) {
        self.head(input: input, progress: nil, completion: completion)
    }

    /// headSender create sender of head.
    @objc public func headSender(input: HeadBucketInput = HeadBucketInput()) -> APISenderResult {
        let (sender, error) = self.headSender(input: input)
        return APISenderResult(sender: sender, error: error)
    }
    
    /// listMultipartUploads: List multipart uploads in the bucket.
    /// Documentation URL: https://docs.qingcloud.com/qingstor/api/bucket/list_multipart_uploads.html
    @objc public func listMultipartUploads(input: ListMultipartUploadsInput, progress: RequestProgress?, completion: @escaping (ListMultipartUploadsOutput?, HTTPURLResponse?, Error?) -> Void) {
    	  self.listMultipartUploads(input: input, progress: progress) { response, error in
            completion(response?.output, response?.rawResponse, error)
        }
    }
    /// listMultipartUploads: List multipart uploads in the bucket.
    /// Documentation URL: https://docs.qingcloud.com/qingstor/api/bucket/list_multipart_uploads.html
    @objc public func listMultipartUploads(input: ListMultipartUploadsInput, completion: @escaping (ListMultipartUploadsOutput?, HTTPURLResponse?, Error?) -> Void) {
        self.listMultipartUploads(input: input, progress: nil, completion: completion)
    }

    /// listMultipartUploadsSender create sender of listMultipartUploads.
    @objc public func listMultipartUploadsSender(input: ListMultipartUploadsInput) -> APISenderResult {
        let (sender, error) = self.listMultipartUploadsSender(input: input)
        return APISenderResult(sender: sender, error: error)
    }
    
    /// listObjects: Retrieve the object list in a bucket.
    /// Documentation URL: https://docs.qingcloud.com/qingstor/api/bucket/get.html
    @objc public func listObjects(input: ListObjectsInput, progress: RequestProgress?, completion: @escaping (ListObjectsOutput?, HTTPURLResponse?, Error?) -> Void) {
    	  self.listObjects(input: input, progress: progress) { response, error in
            completion(response?.output, response?.rawResponse, error)
        }
    }
    /// listObjects: Retrieve the object list in a bucket.
    /// Documentation URL: https://docs.qingcloud.com/qingstor/api/bucket/get.html
    @objc public func listObjects(input: ListObjectsInput, completion: @escaping (ListObjectsOutput?, HTTPURLResponse?, Error?) -> Void) {
        self.listObjects(input: input, progress: nil, completion: completion)
    }

    /// listObjectsSender create sender of listObjects.
    @objc public func listObjectsSender(input: ListObjectsInput) -> APISenderResult {
        let (sender, error) = self.listObjectsSender(input: input)
        return APISenderResult(sender: sender, error: error)
    }
    
    /// put: Create a new bucket.
    /// Documentation URL: https://docs.qingcloud.com/qingstor/api/bucket/put.html
    @objc public func put(input: PutBucketInput = PutBucketInput(), progress: RequestProgress?, completion: @escaping (PutBucketOutput?, HTTPURLResponse?, Error?) -> Void) {
    	  self.put(input: input, progress: progress) { response, error in
            completion(response?.output, response?.rawResponse, error)
        }
    }
    /// put: Create a new bucket.
    /// Documentation URL: https://docs.qingcloud.com/qingstor/api/bucket/put.html
    @objc public func put(input: PutBucketInput = PutBucketInput(), completion: @escaping (PutBucketOutput?, HTTPURLResponse?, Error?) -> Void) {
        self.put(input: input, progress: nil, completion: completion)
    }

    /// putSender create sender of put.
    @objc public func putSender(input: PutBucketInput = PutBucketInput()) -> APISenderResult {
        let (sender, error) = self.putSender(input: input)
        return APISenderResult(sender: sender, error: error)
    }
    
    /// putACL: Set ACL information of the bucket.
    /// Documentation URL: https://docs.qingcloud.com/qingstor/api/bucket/put_acl.html
    @objc public func putACL(input: PutBucketACLInput, progress: RequestProgress?, completion: @escaping (PutBucketACLOutput?, HTTPURLResponse?, Error?) -> Void) {
    	  self.putACL(input: input, progress: progress) { response, error in
            completion(response?.output, response?.rawResponse, error)
        }
    }
    /// putACL: Set ACL information of the bucket.
    /// Documentation URL: https://docs.qingcloud.com/qingstor/api/bucket/put_acl.html
    @objc public func putACL(input: PutBucketACLInput, completion: @escaping (PutBucketACLOutput?, HTTPURLResponse?, Error?) -> Void) {
        self.putACL(input: input, progress: nil, completion: completion)
    }

    /// putACLSender create sender of putACL.
    @objc public func putACLSender(input: PutBucketACLInput) -> APISenderResult {
        let (sender, error) = self.putACLSender(input: input)
        return APISenderResult(sender: sender, error: error)
    }
    
    /// putCORS: Set CORS information of the bucket.
    /// Documentation URL: https://docs.qingcloud.com/qingstor/api/bucket/cors/put_cors.html
    @objc public func putCORS(input: PutBucketCORSInput, progress: RequestProgress?, completion: @escaping (PutBucketCORSOutput?, HTTPURLResponse?, Error?) -> Void) {
    	  self.putCORS(input: input, progress: progress) { response, error in
            completion(response?.output, response?.rawResponse, error)
        }
    }
    /// putCORS: Set CORS information of the bucket.
    /// Documentation URL: https://docs.qingcloud.com/qingstor/api/bucket/cors/put_cors.html
    @objc public func putCORS(input: PutBucketCORSInput, completion: @escaping (PutBucketCORSOutput?, HTTPURLResponse?, Error?) -> Void) {
        self.putCORS(input: input, progress: nil, completion: completion)
    }

    /// putCORSSender create sender of putCORS.
    @objc public func putCORSSender(input: PutBucketCORSInput) -> APISenderResult {
        let (sender, error) = self.putCORSSender(input: input)
        return APISenderResult(sender: sender, error: error)
    }
    
    /// putExternalMirror: Set external mirror of the bucket.
    /// Documentation URL: https://docs.qingcloud.com/qingstor/api/bucket/external_mirror/put_external_mirror.html
    @objc public func putExternalMirror(input: PutBucketExternalMirrorInput, progress: RequestProgress?, completion: @escaping (PutBucketExternalMirrorOutput?, HTTPURLResponse?, Error?) -> Void) {
    	  self.putExternalMirror(input: input, progress: progress) { response, error in
            completion(response?.output, response?.rawResponse, error)
        }
    }
    /// putExternalMirror: Set external mirror of the bucket.
    /// Documentation URL: https://docs.qingcloud.com/qingstor/api/bucket/external_mirror/put_external_mirror.html
    @objc public func putExternalMirror(input: PutBucketExternalMirrorInput, completion: @escaping (PutBucketExternalMirrorOutput?, HTTPURLResponse?, Error?) -> Void) {
        self.putExternalMirror(input: input, progress: nil, completion: completion)
    }

    /// putExternalMirrorSender create sender of putExternalMirror.
    @objc public func putExternalMirrorSender(input: PutBucketExternalMirrorInput) -> APISenderResult {
        let (sender, error) = self.putExternalMirrorSender(input: input)
        return APISenderResult(sender: sender, error: error)
    }
    
    /// putLifecycle: Set Lifecycle information of the bucket.
    /// Documentation URL: https://docs.qingcloud.com/qingstor/api/bucket/lifecycle/put_lifecycle.html
    @objc public func putLifecycle(input: PutBucketLifecycleInput, progress: RequestProgress?, completion: @escaping (PutBucketLifecycleOutput?, HTTPURLResponse?, Error?) -> Void) {
    	  self.putLifecycle(input: input, progress: progress) { response, error in
            completion(response?.output, response?.rawResponse, error)
        }
    }
    /// putLifecycle: Set Lifecycle information of the bucket.
    /// Documentation URL: https://docs.qingcloud.com/qingstor/api/bucket/lifecycle/put_lifecycle.html
    @objc public func putLifecycle(input: PutBucketLifecycleInput, completion: @escaping (PutBucketLifecycleOutput?, HTTPURLResponse?, Error?) -> Void) {
        self.putLifecycle(input: input, progress: nil, completion: completion)
    }

    /// putLifecycleSender create sender of putLifecycle.
    @objc public func putLifecycleSender(input: PutBucketLifecycleInput) -> APISenderResult {
        let (sender, error) = self.putLifecycleSender(input: input)
        return APISenderResult(sender: sender, error: error)
    }
    
    /// putNotification: Set Notification information of the bucket.
    /// Documentation URL: https://docs.qingcloud.com/qingstor/api/bucket/notification/put_notification.html
    @objc public func putNotification(input: PutBucketNotificationInput, progress: RequestProgress?, completion: @escaping (PutBucketNotificationOutput?, HTTPURLResponse?, Error?) -> Void) {
    	  self.putNotification(input: input, progress: progress) { response, error in
            completion(response?.output, response?.rawResponse, error)
        }
    }
    /// putNotification: Set Notification information of the bucket.
    /// Documentation URL: https://docs.qingcloud.com/qingstor/api/bucket/notification/put_notification.html
    @objc public func putNotification(input: PutBucketNotificationInput, completion: @escaping (PutBucketNotificationOutput?, HTTPURLResponse?, Error?) -> Void) {
        self.putNotification(input: input, progress: nil, completion: completion)
    }

    /// putNotificationSender create sender of putNotification.
    @objc public func putNotificationSender(input: PutBucketNotificationInput) -> APISenderResult {
        let (sender, error) = self.putNotificationSender(input: input)
        return APISenderResult(sender: sender, error: error)
    }
    
    /// putPolicy: Set policy information of the bucket.
    /// Documentation URL: https://docs.qingcloud.com/qingstor/api/bucket/policy/put_policy.html
    @objc public func putPolicy(input: PutBucketPolicyInput, progress: RequestProgress?, completion: @escaping (PutBucketPolicyOutput?, HTTPURLResponse?, Error?) -> Void) {
    	  self.putPolicy(input: input, progress: progress) { response, error in
            completion(response?.output, response?.rawResponse, error)
        }
    }
    /// putPolicy: Set policy information of the bucket.
    /// Documentation URL: https://docs.qingcloud.com/qingstor/api/bucket/policy/put_policy.html
    @objc public func putPolicy(input: PutBucketPolicyInput, completion: @escaping (PutBucketPolicyOutput?, HTTPURLResponse?, Error?) -> Void) {
        self.putPolicy(input: input, progress: nil, completion: completion)
    }

    /// putPolicySender create sender of putPolicy.
    @objc public func putPolicySender(input: PutBucketPolicyInput) -> APISenderResult {
        let (sender, error) = self.putPolicySender(input: input)
        return APISenderResult(sender: sender, error: error)
    }
    
    /// abortMultipartUpload: Abort multipart upload.
    /// Documentation URL: https://docs.qingcloud.com/qingstor/api/object/abort_multipart_upload.html
    @objc public func abortMultipartUpload(objectKey: String, input: AbortMultipartUploadInput, progress: RequestProgress?, completion: @escaping (AbortMultipartUploadOutput?, HTTPURLResponse?, Error?) -> Void) {
    	  self.abortMultipartUpload(objectKey: objectKey, input: input, progress: progress) { response, error in
            completion(response?.output, response?.rawResponse, error)
        }
    }
    /// abortMultipartUpload: Abort multipart upload.
    /// Documentation URL: https://docs.qingcloud.com/qingstor/api/object/abort_multipart_upload.html
    @objc public func abortMultipartUpload(objectKey: String, input: AbortMultipartUploadInput, completion: @escaping (AbortMultipartUploadOutput?, HTTPURLResponse?, Error?) -> Void) {
        self.abortMultipartUpload(objectKey: objectKey, input: input, progress: nil, completion: completion)
    }

    /// abortMultipartUploadSender create sender of abortMultipartUpload.
    @objc public func abortMultipartUploadSender(objectKey: String, input: AbortMultipartUploadInput) -> APISenderResult {
        let (sender, error) = self.abortMultipartUploadSender(objectKey: objectKey, input: input)
        return APISenderResult(sender: sender, error: error)
    }
    
    /// completeMultipartUpload: Complete multipart upload.
    /// Documentation URL: https://docs.qingcloud.com/qingstor/api/object/complete_multipart_upload.html
    @objc public func completeMultipartUpload(objectKey: String, input: CompleteMultipartUploadInput, progress: RequestProgress?, completion: @escaping (CompleteMultipartUploadOutput?, HTTPURLResponse?, Error?) -> Void) {
    	  self.completeMultipartUpload(objectKey: objectKey, input: input, progress: progress) { response, error in
            completion(response?.output, response?.rawResponse, error)
        }
    }
    /// completeMultipartUpload: Complete multipart upload.
    /// Documentation URL: https://docs.qingcloud.com/qingstor/api/object/complete_multipart_upload.html
    @objc public func completeMultipartUpload(objectKey: String, input: CompleteMultipartUploadInput, completion: @escaping (CompleteMultipartUploadOutput?, HTTPURLResponse?, Error?) -> Void) {
        self.completeMultipartUpload(objectKey: objectKey, input: input, progress: nil, completion: completion)
    }

    /// completeMultipartUploadSender create sender of completeMultipartUpload.
    @objc public func completeMultipartUploadSender(objectKey: String, input: CompleteMultipartUploadInput) -> APISenderResult {
        let (sender, error) = self.completeMultipartUploadSender(objectKey: objectKey, input: input)
        return APISenderResult(sender: sender, error: error)
    }
    
    /// deleteObject: Delete the object.
    /// Documentation URL: https://docs.qingcloud.com/qingstor/api/object/delete.html
    @objc public func deleteObject(objectKey: String, input: DeleteObjectInput = DeleteObjectInput(), progress: RequestProgress?, completion: @escaping (DeleteObjectOutput?, HTTPURLResponse?, Error?) -> Void) {
    	  self.deleteObject(objectKey: objectKey, input: input, progress: progress) { response, error in
            completion(response?.output, response?.rawResponse, error)
        }
    }
    /// deleteObject: Delete the object.
    /// Documentation URL: https://docs.qingcloud.com/qingstor/api/object/delete.html
    @objc public func deleteObject(objectKey: String, input: DeleteObjectInput = DeleteObjectInput(), completion: @escaping (DeleteObjectOutput?, HTTPURLResponse?, Error?) -> Void) {
        self.deleteObject(objectKey: objectKey, input: input, progress: nil, completion: completion)
    }

    /// deleteObjectSender create sender of deleteObject.
    @objc public func deleteObjectSender(objectKey: String, input: DeleteObjectInput = DeleteObjectInput()) -> APISenderResult {
        let (sender, error) = self.deleteObjectSender(objectKey: objectKey, input: input)
        return APISenderResult(sender: sender, error: error)
    }
    
    /// getObject: Retrieve the object.
    /// Documentation URL: https://docs.qingcloud.com/qingstor/api/object/get.html
    @objc public func getObject(objectKey: String, input: GetObjectInput, progress: RequestProgress?, completion: @escaping (GetObjectOutput?, HTTPURLResponse?, Error?) -> Void) {
    	  self.getObject(objectKey: objectKey, input: input, progress: progress) { response, error in
            completion(response?.output, response?.rawResponse, error)
        }
    }
    /// getObject: Retrieve the object.
    /// Documentation URL: https://docs.qingcloud.com/qingstor/api/object/get.html
    @objc public func getObject(objectKey: String, input: GetObjectInput, completion: @escaping (GetObjectOutput?, HTTPURLResponse?, Error?) -> Void) {
        self.getObject(objectKey: objectKey, input: input, progress: nil, completion: completion)
    }

    /// getObjectSender create sender of getObject.
    @objc public func getObjectSender(objectKey: String, input: GetObjectInput) -> APISenderResult {
        let (sender, error) = self.getObjectSender(objectKey: objectKey, input: input)
        return APISenderResult(sender: sender, error: error)
    }
    
    /// headObject: Check whether the object exists and available.
    /// Documentation URL: https://docs.qingcloud.com/qingstor/api/object/head.html
    @objc public func headObject(objectKey: String, input: HeadObjectInput, progress: RequestProgress?, completion: @escaping (HeadObjectOutput?, HTTPURLResponse?, Error?) -> Void) {
    	  self.headObject(objectKey: objectKey, input: input, progress: progress) { response, error in
            completion(response?.output, response?.rawResponse, error)
        }
    }
    /// headObject: Check whether the object exists and available.
    /// Documentation URL: https://docs.qingcloud.com/qingstor/api/object/head.html
    @objc public func headObject(objectKey: String, input: HeadObjectInput, completion: @escaping (HeadObjectOutput?, HTTPURLResponse?, Error?) -> Void) {
        self.headObject(objectKey: objectKey, input: input, progress: nil, completion: completion)
    }

    /// headObjectSender create sender of headObject.
    @objc public func headObjectSender(objectKey: String, input: HeadObjectInput) -> APISenderResult {
        let (sender, error) = self.headObjectSender(objectKey: objectKey, input: input)
        return APISenderResult(sender: sender, error: error)
    }
    
    /// imageProcess: Image process with the action on the object
    /// Documentation URL: https://docs.qingcloud.com/qingstor/data_process/image_process/index.html
    @objc public func imageProcess(objectKey: String, input: ImageProcessInput, progress: RequestProgress?, completion: @escaping (ImageProcessOutput?, HTTPURLResponse?, Error?) -> Void) {
    	  self.imageProcess(objectKey: objectKey, input: input, progress: progress) { response, error in
            completion(response?.output, response?.rawResponse, error)
        }
    }
    /// imageProcess: Image process with the action on the object
    /// Documentation URL: https://docs.qingcloud.com/qingstor/data_process/image_process/index.html
    @objc public func imageProcess(objectKey: String, input: ImageProcessInput, completion: @escaping (ImageProcessOutput?, HTTPURLResponse?, Error?) -> Void) {
        self.imageProcess(objectKey: objectKey, input: input, progress: nil, completion: completion)
    }

    /// imageProcessSender create sender of imageProcess.
    @objc public func imageProcessSender(objectKey: String, input: ImageProcessInput) -> APISenderResult {
        let (sender, error) = self.imageProcessSender(objectKey: objectKey, input: input)
        return APISenderResult(sender: sender, error: error)
    }
    
    /// initiateMultipartUpload: Initial multipart upload on the object.
    /// Documentation URL: https://docs.qingcloud.com/qingstor/api/object/initiate_multipart_upload.html
    @objc public func initiateMultipartUpload(objectKey: String, input: InitiateMultipartUploadInput, progress: RequestProgress?, completion: @escaping (InitiateMultipartUploadOutput?, HTTPURLResponse?, Error?) -> Void) {
    	  self.initiateMultipartUpload(objectKey: objectKey, input: input, progress: progress) { response, error in
            completion(response?.output, response?.rawResponse, error)
        }
    }
    /// initiateMultipartUpload: Initial multipart upload on the object.
    /// Documentation URL: https://docs.qingcloud.com/qingstor/api/object/initiate_multipart_upload.html
    @objc public func initiateMultipartUpload(objectKey: String, input: InitiateMultipartUploadInput, completion: @escaping (InitiateMultipartUploadOutput?, HTTPURLResponse?, Error?) -> Void) {
        self.initiateMultipartUpload(objectKey: objectKey, input: input, progress: nil, completion: completion)
    }

    /// initiateMultipartUploadSender create sender of initiateMultipartUpload.
    @objc public func initiateMultipartUploadSender(objectKey: String, input: InitiateMultipartUploadInput) -> APISenderResult {
        let (sender, error) = self.initiateMultipartUploadSender(objectKey: objectKey, input: input)
        return APISenderResult(sender: sender, error: error)
    }
    
    /// listMultipart: List object parts.
    /// Documentation URL: https://docs.qingcloud.com/qingstor/api/object/list_multipart.html
    @objc public func listMultipart(objectKey: String, input: ListMultipartInput, progress: RequestProgress?, completion: @escaping (ListMultipartOutput?, HTTPURLResponse?, Error?) -> Void) {
    	  self.listMultipart(objectKey: objectKey, input: input, progress: progress) { response, error in
            completion(response?.output, response?.rawResponse, error)
        }
    }
    /// listMultipart: List object parts.
    /// Documentation URL: https://docs.qingcloud.com/qingstor/api/object/list_multipart.html
    @objc public func listMultipart(objectKey: String, input: ListMultipartInput, completion: @escaping (ListMultipartOutput?, HTTPURLResponse?, Error?) -> Void) {
        self.listMultipart(objectKey: objectKey, input: input, progress: nil, completion: completion)
    }

    /// listMultipartSender create sender of listMultipart.
    @objc public func listMultipartSender(objectKey: String, input: ListMultipartInput) -> APISenderResult {
        let (sender, error) = self.listMultipartSender(objectKey: objectKey, input: input)
        return APISenderResult(sender: sender, error: error)
    }
    
    /// optionsObject: Check whether the object accepts a origin with method and header.
    /// Documentation URL: https://docs.qingcloud.com/qingstor/api/object/options.html
    @objc public func optionsObject(objectKey: String, input: OptionsObjectInput, progress: RequestProgress?, completion: @escaping (OptionsObjectOutput?, HTTPURLResponse?, Error?) -> Void) {
    	  self.optionsObject(objectKey: objectKey, input: input, progress: progress) { response, error in
            completion(response?.output, response?.rawResponse, error)
        }
    }
    /// optionsObject: Check whether the object accepts a origin with method and header.
    /// Documentation URL: https://docs.qingcloud.com/qingstor/api/object/options.html
    @objc public func optionsObject(objectKey: String, input: OptionsObjectInput, completion: @escaping (OptionsObjectOutput?, HTTPURLResponse?, Error?) -> Void) {
        self.optionsObject(objectKey: objectKey, input: input, progress: nil, completion: completion)
    }

    /// optionsObjectSender create sender of optionsObject.
    @objc public func optionsObjectSender(objectKey: String, input: OptionsObjectInput) -> APISenderResult {
        let (sender, error) = self.optionsObjectSender(objectKey: objectKey, input: input)
        return APISenderResult(sender: sender, error: error)
    }
    
    /// putObject: Upload the object.
    /// Documentation URL: https://docs.qingcloud.com/qingstor/api/object/put.html
    @objc public func putObject(objectKey: String, input: PutObjectInput, progress: RequestProgress?, completion: @escaping (PutObjectOutput?, HTTPURLResponse?, Error?) -> Void) {
    	  self.putObject(objectKey: objectKey, input: input, progress: progress) { response, error in
            completion(response?.output, response?.rawResponse, error)
        }
    }
    /// putObject: Upload the object.
    /// Documentation URL: https://docs.qingcloud.com/qingstor/api/object/put.html
    @objc public func putObject(objectKey: String, input: PutObjectInput, completion: @escaping (PutObjectOutput?, HTTPURLResponse?, Error?) -> Void) {
        self.putObject(objectKey: objectKey, input: input, progress: nil, completion: completion)
    }

    /// putObjectSender create sender of putObject.
    @objc public func putObjectSender(objectKey: String, input: PutObjectInput) -> APISenderResult {
        let (sender, error) = self.putObjectSender(objectKey: objectKey, input: input)
        return APISenderResult(sender: sender, error: error)
    }
    
    /// uploadMultipart: Upload object multipart.
    /// Documentation URL: https://docs.qingcloud.com/qingstor/api/object/multipart/upload_multipart.html
    @objc public func uploadMultipart(objectKey: String, input: UploadMultipartInput, progress: RequestProgress?, completion: @escaping (UploadMultipartOutput?, HTTPURLResponse?, Error?) -> Void) {
    	  self.uploadMultipart(objectKey: objectKey, input: input, progress: progress) { response, error in
            completion(response?.output, response?.rawResponse, error)
        }
    }
    /// uploadMultipart: Upload object multipart.
    /// Documentation URL: https://docs.qingcloud.com/qingstor/api/object/multipart/upload_multipart.html
    @objc public func uploadMultipart(objectKey: String, input: UploadMultipartInput, completion: @escaping (UploadMultipartOutput?, HTTPURLResponse?, Error?) -> Void) {
        self.uploadMultipart(objectKey: objectKey, input: input, progress: nil, completion: completion)
    }

    /// uploadMultipartSender create sender of uploadMultipart.
    @objc public func uploadMultipartSender(objectKey: String, input: UploadMultipartInput) -> APISenderResult {
        let (sender, error) = self.uploadMultipartSender(objectKey: objectKey, input: input)
        return APISenderResult(sender: sender, error: error)
    }
    
}

extension APISender {
    /// Send Delete api.
    @objc public func sendDeleteAPI(completion: @escaping (DeleteBucketOutput?, HTTPURLResponse?, Error?) -> Void) {
        sendAPI { (response: Response<DeleteBucketOutput>?, error: Error?) in
            completion(response?.output, response?.rawResponse, error)
        }
    }
    
    /// Send DeleteCORS api.
    @objc public func sendDeleteCORSAPI(completion: @escaping (DeleteBucketCORSOutput?, HTTPURLResponse?, Error?) -> Void) {
        sendAPI { (response: Response<DeleteBucketCORSOutput>?, error: Error?) in
            completion(response?.output, response?.rawResponse, error)
        }
    }
    
    /// Send DeleteExternalMirror api.
    @objc public func sendDeleteExternalMirrorAPI(completion: @escaping (DeleteBucketExternalMirrorOutput?, HTTPURLResponse?, Error?) -> Void) {
        sendAPI { (response: Response<DeleteBucketExternalMirrorOutput>?, error: Error?) in
            completion(response?.output, response?.rawResponse, error)
        }
    }
    
    /// Send DeleteLifecycle api.
    @objc public func sendDeleteLifecycleAPI(completion: @escaping (DeleteBucketLifecycleOutput?, HTTPURLResponse?, Error?) -> Void) {
        sendAPI { (response: Response<DeleteBucketLifecycleOutput>?, error: Error?) in
            completion(response?.output, response?.rawResponse, error)
        }
    }
    
    /// Send DeleteNotification api.
    @objc public func sendDeleteNotificationAPI(completion: @escaping (DeleteBucketNotificationOutput?, HTTPURLResponse?, Error?) -> Void) {
        sendAPI { (response: Response<DeleteBucketNotificationOutput>?, error: Error?) in
            completion(response?.output, response?.rawResponse, error)
        }
    }
    
    /// Send DeletePolicy api.
    @objc public func sendDeletePolicyAPI(completion: @escaping (DeleteBucketPolicyOutput?, HTTPURLResponse?, Error?) -> Void) {
        sendAPI { (response: Response<DeleteBucketPolicyOutput>?, error: Error?) in
            completion(response?.output, response?.rawResponse, error)
        }
    }
    
    /// Send DeleteMultipleObjects api.
    @objc public func sendDeleteMultipleObjectsAPI(completion: @escaping (DeleteMultipleObjectsOutput?, HTTPURLResponse?, Error?) -> Void) {
        sendAPI { (response: Response<DeleteMultipleObjectsOutput>?, error: Error?) in
            completion(response?.output, response?.rawResponse, error)
        }
    }
    
    /// Send GetACL api.
    @objc public func sendGetACLAPI(completion: @escaping (GetBucketACLOutput?, HTTPURLResponse?, Error?) -> Void) {
        sendAPI { (response: Response<GetBucketACLOutput>?, error: Error?) in
            completion(response?.output, response?.rawResponse, error)
        }
    }
    
    /// Send GetCORS api.
    @objc public func sendGetCORSAPI(completion: @escaping (GetBucketCORSOutput?, HTTPURLResponse?, Error?) -> Void) {
        sendAPI { (response: Response<GetBucketCORSOutput>?, error: Error?) in
            completion(response?.output, response?.rawResponse, error)
        }
    }
    
    /// Send GetExternalMirror api.
    @objc public func sendGetExternalMirrorAPI(completion: @escaping (GetBucketExternalMirrorOutput?, HTTPURLResponse?, Error?) -> Void) {
        sendAPI { (response: Response<GetBucketExternalMirrorOutput>?, error: Error?) in
            completion(response?.output, response?.rawResponse, error)
        }
    }
    
    /// Send GetLifecycle api.
    @objc public func sendGetLifecycleAPI(completion: @escaping (GetBucketLifecycleOutput?, HTTPURLResponse?, Error?) -> Void) {
        sendAPI { (response: Response<GetBucketLifecycleOutput>?, error: Error?) in
            completion(response?.output, response?.rawResponse, error)
        }
    }
    
    /// Send GetNotification api.
    @objc public func sendGetNotificationAPI(completion: @escaping (GetBucketNotificationOutput?, HTTPURLResponse?, Error?) -> Void) {
        sendAPI { (response: Response<GetBucketNotificationOutput>?, error: Error?) in
            completion(response?.output, response?.rawResponse, error)
        }
    }
    
    /// Send GetPolicy api.
    @objc public func sendGetPolicyAPI(completion: @escaping (GetBucketPolicyOutput?, HTTPURLResponse?, Error?) -> Void) {
        sendAPI { (response: Response<GetBucketPolicyOutput>?, error: Error?) in
            completion(response?.output, response?.rawResponse, error)
        }
    }
    
    /// Send GetStatistics api.
    @objc public func sendGetStatisticsAPI(completion: @escaping (GetBucketStatisticsOutput?, HTTPURLResponse?, Error?) -> Void) {
        sendAPI { (response: Response<GetBucketStatisticsOutput>?, error: Error?) in
            completion(response?.output, response?.rawResponse, error)
        }
    }
    
    /// Send Head api.
    @objc public func sendHeadAPI(completion: @escaping (HeadBucketOutput?, HTTPURLResponse?, Error?) -> Void) {
        sendAPI { (response: Response<HeadBucketOutput>?, error: Error?) in
            completion(response?.output, response?.rawResponse, error)
        }
    }
    
    /// Send ListMultipartUploads api.
    @objc public func sendListMultipartUploadsAPI(completion: @escaping (ListMultipartUploadsOutput?, HTTPURLResponse?, Error?) -> Void) {
        sendAPI { (response: Response<ListMultipartUploadsOutput>?, error: Error?) in
            completion(response?.output, response?.rawResponse, error)
        }
    }
    
    /// Send ListObjects api.
    @objc public func sendListObjectsAPI(completion: @escaping (ListObjectsOutput?, HTTPURLResponse?, Error?) -> Void) {
        sendAPI { (response: Response<ListObjectsOutput>?, error: Error?) in
            completion(response?.output, response?.rawResponse, error)
        }
    }
    
    /// Send Put api.
    @objc public func sendPutAPI(completion: @escaping (PutBucketOutput?, HTTPURLResponse?, Error?) -> Void) {
        sendAPI { (response: Response<PutBucketOutput>?, error: Error?) in
            completion(response?.output, response?.rawResponse, error)
        }
    }
    
    /// Send PutACL api.
    @objc public func sendPutACLAPI(completion: @escaping (PutBucketACLOutput?, HTTPURLResponse?, Error?) -> Void) {
        sendAPI { (response: Response<PutBucketACLOutput>?, error: Error?) in
            completion(response?.output, response?.rawResponse, error)
        }
    }
    
    /// Send PutCORS api.
    @objc public func sendPutCORSAPI(completion: @escaping (PutBucketCORSOutput?, HTTPURLResponse?, Error?) -> Void) {
        sendAPI { (response: Response<PutBucketCORSOutput>?, error: Error?) in
            completion(response?.output, response?.rawResponse, error)
        }
    }
    
    /// Send PutExternalMirror api.
    @objc public func sendPutExternalMirrorAPI(completion: @escaping (PutBucketExternalMirrorOutput?, HTTPURLResponse?, Error?) -> Void) {
        sendAPI { (response: Response<PutBucketExternalMirrorOutput>?, error: Error?) in
            completion(response?.output, response?.rawResponse, error)
        }
    }
    
    /// Send PutLifecycle api.
    @objc public func sendPutLifecycleAPI(completion: @escaping (PutBucketLifecycleOutput?, HTTPURLResponse?, Error?) -> Void) {
        sendAPI { (response: Response<PutBucketLifecycleOutput>?, error: Error?) in
            completion(response?.output, response?.rawResponse, error)
        }
    }
    
    /// Send PutNotification api.
    @objc public func sendPutNotificationAPI(completion: @escaping (PutBucketNotificationOutput?, HTTPURLResponse?, Error?) -> Void) {
        sendAPI { (response: Response<PutBucketNotificationOutput>?, error: Error?) in
            completion(response?.output, response?.rawResponse, error)
        }
    }
    
    /// Send PutPolicy api.
    @objc public func sendPutPolicyAPI(completion: @escaping (PutBucketPolicyOutput?, HTTPURLResponse?, Error?) -> Void) {
        sendAPI { (response: Response<PutBucketPolicyOutput>?, error: Error?) in
            completion(response?.output, response?.rawResponse, error)
        }
    }
    
    /// Send AbortMultipartUpload api.
    @objc public func sendAbortMultipartUploadAPI(completion: @escaping (AbortMultipartUploadOutput?, HTTPURLResponse?, Error?) -> Void) {
        sendAPI { (response: Response<AbortMultipartUploadOutput>?, error: Error?) in
            completion(response?.output, response?.rawResponse, error)
        }
    }
    
    /// Send CompleteMultipartUpload api.
    @objc public func sendCompleteMultipartUploadAPI(completion: @escaping (CompleteMultipartUploadOutput?, HTTPURLResponse?, Error?) -> Void) {
        sendAPI { (response: Response<CompleteMultipartUploadOutput>?, error: Error?) in
            completion(response?.output, response?.rawResponse, error)
        }
    }
    
    /// Send DeleteObject api.
    @objc public func sendDeleteObjectAPI(completion: @escaping (DeleteObjectOutput?, HTTPURLResponse?, Error?) -> Void) {
        sendAPI { (response: Response<DeleteObjectOutput>?, error: Error?) in
            completion(response?.output, response?.rawResponse, error)
        }
    }
    
    /// Send GetObject api.
    @objc public func sendGetObjectAPI(completion: @escaping (GetObjectOutput?, HTTPURLResponse?, Error?) -> Void) {
        sendAPI { (response: Response<GetObjectOutput>?, error: Error?) in
            completion(response?.output, response?.rawResponse, error)
        }
    }
    
    /// Send HeadObject api.
    @objc public func sendHeadObjectAPI(completion: @escaping (HeadObjectOutput?, HTTPURLResponse?, Error?) -> Void) {
        sendAPI { (response: Response<HeadObjectOutput>?, error: Error?) in
            completion(response?.output, response?.rawResponse, error)
        }
    }
    
    /// Send ImageProcess api.
    @objc public func sendImageProcessAPI(completion: @escaping (ImageProcessOutput?, HTTPURLResponse?, Error?) -> Void) {
        sendAPI { (response: Response<ImageProcessOutput>?, error: Error?) in
            completion(response?.output, response?.rawResponse, error)
        }
    }
    
    /// Send InitiateMultipartUpload api.
    @objc public func sendInitiateMultipartUploadAPI(completion: @escaping (InitiateMultipartUploadOutput?, HTTPURLResponse?, Error?) -> Void) {
        sendAPI { (response: Response<InitiateMultipartUploadOutput>?, error: Error?) in
            completion(response?.output, response?.rawResponse, error)
        }
    }
    
    /// Send ListMultipart api.
    @objc public func sendListMultipartAPI(completion: @escaping (ListMultipartOutput?, HTTPURLResponse?, Error?) -> Void) {
        sendAPI { (response: Response<ListMultipartOutput>?, error: Error?) in
            completion(response?.output, response?.rawResponse, error)
        }
    }
    
    /// Send OptionsObject api.
    @objc public func sendOptionsObjectAPI(completion: @escaping (OptionsObjectOutput?, HTTPURLResponse?, Error?) -> Void) {
        sendAPI { (response: Response<OptionsObjectOutput>?, error: Error?) in
            completion(response?.output, response?.rawResponse, error)
        }
    }
    
    /// Send PutObject api.
    @objc public func sendPutObjectAPI(completion: @escaping (PutObjectOutput?, HTTPURLResponse?, Error?) -> Void) {
        sendAPI { (response: Response<PutObjectOutput>?, error: Error?) in
            completion(response?.output, response?.rawResponse, error)
        }
    }
    
    /// Send UploadMultipart api.
    @objc public func sendUploadMultipartAPI(completion: @escaping (UploadMultipartOutput?, HTTPURLResponse?, Error?) -> Void) {
        sendAPI { (response: Response<UploadMultipartOutput>?, error: Error?) in
            completion(response?.output, response?.rawResponse, error)
        }
    }
     
}


        

extension DeleteBucketInput {
    /// Create empty `DeleteBucketInput` instance.
    ///
    /// - returns: The new `DeleteBucketInput` instance.
    @objc public static func empty() -> DeleteBucketInput { 
        return DeleteBucketInput()
    }
}
    
        

extension DeleteBucketCORSInput {
    /// Create empty `DeleteBucketCORSInput` instance.
    ///
    /// - returns: The new `DeleteBucketCORSInput` instance.
    @objc public static func empty() -> DeleteBucketCORSInput { 
        return DeleteBucketCORSInput()
    }
}
    
        

extension DeleteBucketExternalMirrorInput {
    /// Create empty `DeleteBucketExternalMirrorInput` instance.
    ///
    /// - returns: The new `DeleteBucketExternalMirrorInput` instance.
    @objc public static func empty() -> DeleteBucketExternalMirrorInput { 
        return DeleteBucketExternalMirrorInput()
    }
}
    
        

extension DeleteBucketLifecycleInput {
    /// Create empty `DeleteBucketLifecycleInput` instance.
    ///
    /// - returns: The new `DeleteBucketLifecycleInput` instance.
    @objc public static func empty() -> DeleteBucketLifecycleInput { 
        return DeleteBucketLifecycleInput()
    }
}
    
        

extension DeleteBucketNotificationInput {
    /// Create empty `DeleteBucketNotificationInput` instance.
    ///
    /// - returns: The new `DeleteBucketNotificationInput` instance.
    @objc public static func empty() -> DeleteBucketNotificationInput { 
        return DeleteBucketNotificationInput()
    }
}
    
        

extension DeleteBucketPolicyInput {
    /// Create empty `DeleteBucketPolicyInput` instance.
    ///
    /// - returns: The new `DeleteBucketPolicyInput` instance.
    @objc public static func empty() -> DeleteBucketPolicyInput { 
        return DeleteBucketPolicyInput()
    }
}
    
        

extension DeleteMultipleObjectsInput {
    /// Create empty `DeleteMultipleObjectsInput` instance.
    ///
    /// - returns: The new `DeleteMultipleObjectsInput` instance.
    @objc public static func empty() -> DeleteMultipleObjectsInput { 
        return DeleteMultipleObjectsInput(objects: [], quiet: false)
    }
}
    
        

extension GetBucketACLInput {
    /// Create empty `GetBucketACLInput` instance.
    ///
    /// - returns: The new `GetBucketACLInput` instance.
    @objc public static func empty() -> GetBucketACLInput { 
        return GetBucketACLInput()
    }
}
    
        

extension GetBucketCORSInput {
    /// Create empty `GetBucketCORSInput` instance.
    ///
    /// - returns: The new `GetBucketCORSInput` instance.
    @objc public static func empty() -> GetBucketCORSInput { 
        return GetBucketCORSInput()
    }
}
    
        

extension GetBucketExternalMirrorInput {
    /// Create empty `GetBucketExternalMirrorInput` instance.
    ///
    /// - returns: The new `GetBucketExternalMirrorInput` instance.
    @objc public static func empty() -> GetBucketExternalMirrorInput { 
        return GetBucketExternalMirrorInput()
    }
}
    
        

extension GetBucketLifecycleInput {
    /// Create empty `GetBucketLifecycleInput` instance.
    ///
    /// - returns: The new `GetBucketLifecycleInput` instance.
    @objc public static func empty() -> GetBucketLifecycleInput { 
        return GetBucketLifecycleInput()
    }
}
    
        

extension GetBucketNotificationInput {
    /// Create empty `GetBucketNotificationInput` instance.
    ///
    /// - returns: The new `GetBucketNotificationInput` instance.
    @objc public static func empty() -> GetBucketNotificationInput { 
        return GetBucketNotificationInput()
    }
}
    
        

extension GetBucketPolicyInput {
    /// Create empty `GetBucketPolicyInput` instance.
    ///
    /// - returns: The new `GetBucketPolicyInput` instance.
    @objc public static func empty() -> GetBucketPolicyInput { 
        return GetBucketPolicyInput()
    }
}
    
        

extension GetBucketStatisticsInput {
    /// Create empty `GetBucketStatisticsInput` instance.
    ///
    /// - returns: The new `GetBucketStatisticsInput` instance.
    @objc public static func empty() -> GetBucketStatisticsInput { 
        return GetBucketStatisticsInput()
    }
}
    
        

extension HeadBucketInput {
    /// Create empty `HeadBucketInput` instance.
    ///
    /// - returns: The new `HeadBucketInput` instance.
    @objc public static func empty() -> HeadBucketInput { 
        return HeadBucketInput()
    }
}
    
        

extension ListMultipartUploadsInput {
    /// Create empty `ListMultipartUploadsInput` instance.
    ///
    /// - returns: The new `ListMultipartUploadsInput` instance.
    @objc public static func empty() -> ListMultipartUploadsInput { 
        return ListMultipartUploadsInput(delimiter: nil, keyMarker: nil, limit: Int.min, prefix: nil, uploadIDMarker: nil)
    }
}
    
        

extension ListObjectsInput {
    /// Create empty `ListObjectsInput` instance.
    ///
    /// - returns: The new `ListObjectsInput` instance.
    @objc public static func empty() -> ListObjectsInput { 
        return ListObjectsInput(delimiter: nil, limit: Int.min, marker: nil, prefix: nil)
    }
}
    
        

extension PutBucketInput {
    /// Create empty `PutBucketInput` instance.
    ///
    /// - returns: The new `PutBucketInput` instance.
    @objc public static func empty() -> PutBucketInput { 
        return PutBucketInput()
    }
}
    
        

extension PutBucketACLInput {
    /// Create empty `PutBucketACLInput` instance.
    ///
    /// - returns: The new `PutBucketACLInput` instance.
    @objc public static func empty() -> PutBucketACLInput { 
        return PutBucketACLInput(acl: [])
    }
}
    
        

extension PutBucketCORSInput {
    /// Create empty `PutBucketCORSInput` instance.
    ///
    /// - returns: The new `PutBucketCORSInput` instance.
    @objc public static func empty() -> PutBucketCORSInput { 
        return PutBucketCORSInput(corsRules: [])
    }
}
    
        

extension PutBucketExternalMirrorInput {
    /// Create empty `PutBucketExternalMirrorInput` instance.
    ///
    /// - returns: The new `PutBucketExternalMirrorInput` instance.
    @objc public static func empty() -> PutBucketExternalMirrorInput { 
        return PutBucketExternalMirrorInput(sourceSite: "")
    }
}
    
        

extension PutBucketLifecycleInput {
    /// Create empty `PutBucketLifecycleInput` instance.
    ///
    /// - returns: The new `PutBucketLifecycleInput` instance.
    @objc public static func empty() -> PutBucketLifecycleInput { 
        return PutBucketLifecycleInput(rule: [])
    }
}
    
        

extension PutBucketNotificationInput {
    /// Create empty `PutBucketNotificationInput` instance.
    ///
    /// - returns: The new `PutBucketNotificationInput` instance.
    @objc public static func empty() -> PutBucketNotificationInput { 
        return PutBucketNotificationInput(notifications: [])
    }
}
    
        

extension PutBucketPolicyInput {
    /// Create empty `PutBucketPolicyInput` instance.
    ///
    /// - returns: The new `PutBucketPolicyInput` instance.
    @objc public static func empty() -> PutBucketPolicyInput { 
        return PutBucketPolicyInput(statement: [])
    }
}
    
        

extension AbortMultipartUploadInput {
    /// Create empty `AbortMultipartUploadInput` instance.
    ///
    /// - returns: The new `AbortMultipartUploadInput` instance.
    @objc public static func empty() -> AbortMultipartUploadInput { 
        return AbortMultipartUploadInput(uploadID: "")
    }
}
    
        

extension CompleteMultipartUploadInput {
    /// Create empty `CompleteMultipartUploadInput` instance.
    ///
    /// - returns: The new `CompleteMultipartUploadInput` instance.
    @objc public static func empty() -> CompleteMultipartUploadInput { 
        return CompleteMultipartUploadInput(uploadID: "", etag: nil, xQSEncryptionCustomerAlgorithm: nil, xQSEncryptionCustomerKey: nil, xQSEncryptionCustomerKeyMD5: nil, objectParts: [])
    }
}
    
        

extension DeleteObjectInput {
    /// Create empty `DeleteObjectInput` instance.
    ///
    /// - returns: The new `DeleteObjectInput` instance.
    @objc public static func empty() -> DeleteObjectInput { 
        return DeleteObjectInput()
    }
}
    
        

extension GetObjectInput {
    /// Create empty `GetObjectInput` instance.
    ///
    /// - returns: The new `GetObjectInput` instance.
    @objc public static func empty() -> GetObjectInput { 
        return GetObjectInput(responseCacheControl: nil, responseContentDisposition: nil, responseContentEncoding: nil, responseContentLanguage: nil, responseContentType: nil, responseExpires: nil, ifMatch: nil, ifModifiedSince: nil, ifNoneMatch: nil, ifUnmodifiedSince: nil, range: nil, xQSEncryptionCustomerAlgorithm: nil, xQSEncryptionCustomerKey: nil, xQSEncryptionCustomerKeyMD5: nil)
    }
}
    
        

extension HeadObjectInput {
    /// Create empty `HeadObjectInput` instance.
    ///
    /// - returns: The new `HeadObjectInput` instance.
    @objc public static func empty() -> HeadObjectInput { 
        return HeadObjectInput(ifMatch: nil, ifModifiedSince: nil, ifNoneMatch: nil, ifUnmodifiedSince: nil, xQSEncryptionCustomerAlgorithm: nil, xQSEncryptionCustomerKey: nil, xQSEncryptionCustomerKeyMD5: nil)
    }
}
    
        

extension ImageProcessInput {
    /// Create empty `ImageProcessInput` instance.
    ///
    /// - returns: The new `ImageProcessInput` instance.
    @objc public static func empty() -> ImageProcessInput { 
        return ImageProcessInput(action: "", responseCacheControl: nil, responseContentDisposition: nil, responseContentEncoding: nil, responseContentLanguage: nil, responseContentType: nil, responseExpires: nil, ifModifiedSince: nil)
    }
}
    
        

extension InitiateMultipartUploadInput {
    /// Create empty `InitiateMultipartUploadInput` instance.
    ///
    /// - returns: The new `InitiateMultipartUploadInput` instance.
    @objc public static func empty() -> InitiateMultipartUploadInput { 
        return InitiateMultipartUploadInput(contentType: nil, xQSEncryptionCustomerAlgorithm: nil, xQSEncryptionCustomerKey: nil, xQSEncryptionCustomerKeyMD5: nil, xQSStorageClass: nil)
    }
}
    
        

extension ListMultipartInput {
    /// Create empty `ListMultipartInput` instance.
    ///
    /// - returns: The new `ListMultipartInput` instance.
    @objc public static func empty() -> ListMultipartInput { 
        return ListMultipartInput(limit: Int.min, partNumberMarker: Int.min, uploadID: "")
    }
}
    
        

extension OptionsObjectInput {
    /// Create empty `OptionsObjectInput` instance.
    ///
    /// - returns: The new `OptionsObjectInput` instance.
    @objc public static func empty() -> OptionsObjectInput { 
        return OptionsObjectInput(accessControlRequestHeaders: nil, accessControlRequestMethod: "", origin: "")
    }
}
    
        

extension PutObjectInput {
    /// Create empty `PutObjectInput` instance.
    ///
    /// - returns: The new `PutObjectInput` instance.
    @objc public static func empty() -> PutObjectInput { 
        return PutObjectInput(contentLength: Int.min, contentMD5: nil, contentType: nil, expect: nil, xQSCopySource: nil, xQSCopySourceEncryptionCustomerAlgorithm: nil, xQSCopySourceEncryptionCustomerKey: nil, xQSCopySourceEncryptionCustomerKeyMD5: nil, xQSCopySourceIfMatch: nil, xQSCopySourceIfModifiedSince: nil, xQSCopySourceIfNoneMatch: nil, xQSCopySourceIfUnmodifiedSince: nil, xQSEncryptionCustomerAlgorithm: nil, xQSEncryptionCustomerKey: nil, xQSEncryptionCustomerKeyMD5: nil, xQSFetchIfUnmodifiedSince: nil, xQSFetchSource: nil, xQSMoveSource: nil, xQSStorageClass: nil, bodyInputStream: nil)
    }
}
    
        

extension UploadMultipartInput {
    /// Create empty `UploadMultipartInput` instance.
    ///
    /// - returns: The new `UploadMultipartInput` instance.
    @objc public static func empty() -> UploadMultipartInput { 
        return UploadMultipartInput(partNumber: Int.min, uploadID: "", contentLength: Int.min, contentMD5: nil, xQSCopyRange: nil, xQSCopySource: nil, xQSCopySourceEncryptionCustomerAlgorithm: nil, xQSCopySourceEncryptionCustomerKey: nil, xQSCopySourceEncryptionCustomerKeyMD5: nil, xQSCopySourceIfMatch: nil, xQSCopySourceIfModifiedSince: nil, xQSCopySourceIfNoneMatch: nil, xQSCopySourceIfUnmodifiedSince: nil, xQSEncryptionCustomerAlgorithm: nil, xQSEncryptionCustomerKey: nil, xQSEncryptionCustomerKeyMD5: nil, bodyInputStream: nil)
    }
}
    