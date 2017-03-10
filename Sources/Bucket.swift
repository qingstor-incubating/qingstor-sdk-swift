//
// Bucket.swift
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
import ObjectMapper

public extension QingStor {
    public func bucket(bucketName: String, zone: String? = nil) -> Bucket {
        return Bucket(context: self.context.rawCopy(), bucketName: bucketName, zone: zone ?? self.zone)
    }
}

public class Bucket: QingStorAPI {
    // delete: Delete a bucket.
    // Documentation URL: https://docs.qingcloud.com/qingstor/api/bucket/delete.html
    public func delete(input: DeleteBucketInput = DeleteBucketInput(), completion: @escaping RequestCompletion<DeleteBucketOutput>) {
        let (sender, error) = self.deleteSender(input: input)

        if let error = error {
            completion(nil, error)
            return
        }

        sender!.sendAPI(completion: completion)
    }

    // deleteSender create sender of delete.
    public func deleteSender(input: DeleteBucketInput = DeleteBucketInput()) -> (APISender?, Error?) {
        do {
            try self.setupContext(uriFormat: "/<bucket-name>")
        } catch {
            return (nil, error)
        }

        return APISender.qingStor(context: self.context, input: input, method: .delete)
    }

    // deleteCORS: Delete CORS information of the bucket.
    // Documentation URL: https://docs.qingcloud.com/qingstor/api/bucket/cors/delete_cors.html
    public func deleteCORS(input: DeleteBucketCORSInput = DeleteBucketCORSInput(), completion: @escaping RequestCompletion<DeleteBucketCORSOutput>) {
        let (sender, error) = self.deleteCORSSender(input: input)

        if let error = error {
            completion(nil, error)
            return
        }

        sender!.sendAPI(completion: completion)
    }

    // deleteCORSSender create sender of deleteCORS.
    public func deleteCORSSender(input: DeleteBucketCORSInput = DeleteBucketCORSInput()) -> (APISender?, Error?) {
        do {
            try self.setupContext(uriFormat: "/<bucket-name>?cors")
        } catch {
            return (nil, error)
        }

        return APISender.qingStor(context: self.context, input: input, method: .delete)
    }

    // deleteExternalMirror: Delete external mirror of the bucket.
    // Documentation URL: https://docs.qingcloud.com/qingstor/api/bucket/external_mirror/delete_external_mirror.html
    public func deleteExternalMirror(input: DeleteBucketExternalMirrorInput = DeleteBucketExternalMirrorInput(), completion: @escaping RequestCompletion<DeleteBucketExternalMirrorOutput>) {
        let (sender, error) = self.deleteExternalMirrorSender(input: input)

        if let error = error {
            completion(nil, error)
            return
        }

        sender!.sendAPI(completion: completion)
    }

    // deleteExternalMirrorSender create sender of deleteExternalMirror.
    public func deleteExternalMirrorSender(input: DeleteBucketExternalMirrorInput = DeleteBucketExternalMirrorInput()) -> (APISender?, Error?) {
        do {
            try self.setupContext(uriFormat: "/<bucket-name>?mirror")
        } catch {
            return (nil, error)
        }

        return APISender.qingStor(context: self.context, input: input, method: .delete)
    }

    // deletePolicy: Delete policy information of the bucket.
    // Documentation URL: https://docs.qingcloud.com/qingstor/api/bucket/policy/delete_policy.html
    public func deletePolicy(input: DeleteBucketPolicyInput = DeleteBucketPolicyInput(), completion: @escaping RequestCompletion<DeleteBucketPolicyOutput>) {
        let (sender, error) = self.deletePolicySender(input: input)

        if let error = error {
            completion(nil, error)
            return
        }

        sender!.sendAPI(completion: completion)
    }

    // deletePolicySender create sender of deletePolicy.
    public func deletePolicySender(input: DeleteBucketPolicyInput = DeleteBucketPolicyInput()) -> (APISender?, Error?) {
        do {
            try self.setupContext(uriFormat: "/<bucket-name>?policy")
        } catch {
            return (nil, error)
        }

        return APISender.qingStor(context: self.context, input: input, method: .delete)
    }

    // deleteMultipleObjects: Delete multiple objects from the bucket.
    // Documentation URL: https://docs.qingcloud.com/qingstor/api/bucket/delete_multiple.html
    public func deleteMultipleObjects(input: DeleteMultipleObjectsInput, completion: @escaping RequestCompletion<DeleteMultipleObjectsOutput>) {
        let (sender, error) = self.deleteMultipleObjectsSender(input: input)

        if let error = error {
            completion(nil, error)
            return
        }

        sender!.sendAPI(completion: completion)
    }

    // deleteMultipleObjectsSender create sender of deleteMultipleObjects.
    public func deleteMultipleObjectsSender(input: DeleteMultipleObjectsInput) -> (APISender?, Error?) {
        do {
            try self.setupContext(uriFormat: "/<bucket-name>?delete")
        } catch {
            return (nil, error)
        }

        return APISender.qingStor(context: self.context, input: input, method: .post)
    }

    // getACL: Get ACL information of the bucket.
    // Documentation URL: https://docs.qingcloud.com/qingstor/api/bucket/get_acl.html
    public func getACL(input: GetBucketACLInput = GetBucketACLInput(), completion: @escaping RequestCompletion<GetBucketACLOutput>) {
        let (sender, error) = self.getACLSender(input: input)

        if let error = error {
            completion(nil, error)
            return
        }

        sender!.sendAPI(completion: completion)
    }

    // getACLSender create sender of getACL.
    public func getACLSender(input: GetBucketACLInput = GetBucketACLInput()) -> (APISender?, Error?) {
        do {
            try self.setupContext(uriFormat: "/<bucket-name>?acl")
        } catch {
            return (nil, error)
        }

        return APISender.qingStor(context: self.context, input: input, method: .get)
    }

    // getCORS: Get CORS information of the bucket.
    // Documentation URL: https://docs.qingcloud.com/qingstor/api/bucket/cors/get_cors.html
    public func getCORS(input: GetBucketCORSInput = GetBucketCORSInput(), completion: @escaping RequestCompletion<GetBucketCORSOutput>) {
        let (sender, error) = self.getCORSSender(input: input)

        if let error = error {
            completion(nil, error)
            return
        }

        sender!.sendAPI(completion: completion)
    }

    // getCORSSender create sender of getCORS.
    public func getCORSSender(input: GetBucketCORSInput = GetBucketCORSInput()) -> (APISender?, Error?) {
        do {
            try self.setupContext(uriFormat: "/<bucket-name>?cors")
        } catch {
            return (nil, error)
        }

        return APISender.qingStor(context: self.context, input: input, method: .get)
    }

    // getExternalMirror: Get external mirror of the bucket.
    // Documentation URL: https://docs.qingcloud.com/qingstor/api/bucket/external_mirror/get_external_mirror.html
    public func getExternalMirror(input: GetBucketExternalMirrorInput = GetBucketExternalMirrorInput(), completion: @escaping RequestCompletion<GetBucketExternalMirrorOutput>) {
        let (sender, error) = self.getExternalMirrorSender(input: input)

        if let error = error {
            completion(nil, error)
            return
        }

        sender!.sendAPI(completion: completion)
    }

    // getExternalMirrorSender create sender of getExternalMirror.
    public func getExternalMirrorSender(input: GetBucketExternalMirrorInput = GetBucketExternalMirrorInput()) -> (APISender?, Error?) {
        do {
            try self.setupContext(uriFormat: "/<bucket-name>?mirror")
        } catch {
            return (nil, error)
        }

        return APISender.qingStor(context: self.context, input: input, method: .get)
    }

    // getPolicy: Get policy information of the bucket.
    // Documentation URL: https://https://docs.qingcloud.com/qingstor/api/bucket/policy/get_policy.html
    public func getPolicy(input: GetBucketPolicyInput = GetBucketPolicyInput(), completion: @escaping RequestCompletion<GetBucketPolicyOutput>) {
        let (sender, error) = self.getPolicySender(input: input)

        if let error = error {
            completion(nil, error)
            return
        }

        sender!.sendAPI(completion: completion)
    }

    // getPolicySender create sender of getPolicy.
    public func getPolicySender(input: GetBucketPolicyInput = GetBucketPolicyInput()) -> (APISender?, Error?) {
        do {
            try self.setupContext(uriFormat: "/<bucket-name>?policy")
        } catch {
            return (nil, error)
        }

        return APISender.qingStor(context: self.context, input: input, method: .get)
    }

    // getStatistics: Get statistics information of the bucket.
    // Documentation URL: https://docs.qingcloud.com/qingstor/api/bucket/get_stats.html
    public func getStatistics(input: GetBucketStatisticsInput = GetBucketStatisticsInput(), completion: @escaping RequestCompletion<GetBucketStatisticsOutput>) {
        let (sender, error) = self.getStatisticsSender(input: input)

        if let error = error {
            completion(nil, error)
            return
        }

        sender!.sendAPI(completion: completion)
    }

    // getStatisticsSender create sender of getStatistics.
    public func getStatisticsSender(input: GetBucketStatisticsInput = GetBucketStatisticsInput()) -> (APISender?, Error?) {
        do {
            try self.setupContext(uriFormat: "/<bucket-name>?stats")
        } catch {
            return (nil, error)
        }

        return APISender.qingStor(context: self.context, input: input, method: .get)
    }

    // head: Check whether the bucket exists and available.
    // Documentation URL: https://docs.qingcloud.com/qingstor/api/bucket/head.html
    public func head(input: HeadBucketInput = HeadBucketInput(), completion: @escaping RequestCompletion<HeadBucketOutput>) {
        let (sender, error) = self.headSender(input: input)

        if let error = error {
            completion(nil, error)
            return
        }

        sender!.sendAPI(completion: completion)
    }

    // headSender create sender of head.
    public func headSender(input: HeadBucketInput = HeadBucketInput()) -> (APISender?, Error?) {
        do {
            try self.setupContext(uriFormat: "/<bucket-name>")
        } catch {
            return (nil, error)
        }

        return APISender.qingStor(context: self.context, input: input, method: .head)
    }

    // listMultipartUploads: List multipart uploads in the bucket.
    // Documentation URL: https://docs.qingcloud.com/qingstor/api/bucket/list_multipart_uploads.html
    public func listMultipartUploads(input: ListMultipartUploadsInput, completion: @escaping RequestCompletion<ListMultipartUploadsOutput>) {
        let (sender, error) = self.listMultipartUploadsSender(input: input)

        if let error = error {
            completion(nil, error)
            return
        }

        sender!.sendAPI(completion: completion)
    }

    // listMultipartUploadsSender create sender of listMultipartUploads.
    public func listMultipartUploadsSender(input: ListMultipartUploadsInput) -> (APISender?, Error?) {
        do {
            try self.setupContext(uriFormat: "/<bucket-name>?uploads")
        } catch {
            return (nil, error)
        }

        return APISender.qingStor(context: self.context, input: input, method: .get)
    }

    // listObjects: Retrieve the object list in a bucket.
    // Documentation URL: https://docs.qingcloud.com/qingstor/api/bucket/get.html
    public func listObjects(input: ListObjectsInput, completion: @escaping RequestCompletion<ListObjectsOutput>) {
        let (sender, error) = self.listObjectsSender(input: input)

        if let error = error {
            completion(nil, error)
            return
        }

        sender!.sendAPI(completion: completion)
    }

    // listObjectsSender create sender of listObjects.
    public func listObjectsSender(input: ListObjectsInput) -> (APISender?, Error?) {
        do {
            try self.setupContext(uriFormat: "/<bucket-name>")
        } catch {
            return (nil, error)
        }

        return APISender.qingStor(context: self.context, input: input, method: .get)
    }

    // put: Create a new bucket.
    // Documentation URL: https://docs.qingcloud.com/qingstor/api/bucket/put.html
    public func put(input: PutBucketInput = PutBucketInput(), completion: @escaping RequestCompletion<PutBucketOutput>) {
        let (sender, error) = self.putSender(input: input)

        if let error = error {
            completion(nil, error)
            return
        }

        sender!.sendAPI(completion: completion)
    }

    // putSender create sender of put.
    public func putSender(input: PutBucketInput = PutBucketInput()) -> (APISender?, Error?) {
        do {
            try self.setupContext(uriFormat: "/<bucket-name>")
        } catch {
            return (nil, error)
        }

        return APISender.qingStor(context: self.context, input: input, method: .put)
    }

    // putACL: Set ACL information of the bucket.
    // Documentation URL: https://docs.qingcloud.com/qingstor/api/bucket/put_acl.html
    public func putACL(input: PutBucketACLInput, completion: @escaping RequestCompletion<PutBucketACLOutput>) {
        let (sender, error) = self.putACLSender(input: input)

        if let error = error {
            completion(nil, error)
            return
        }

        sender!.sendAPI(completion: completion)
    }

    // putACLSender create sender of putACL.
    public func putACLSender(input: PutBucketACLInput) -> (APISender?, Error?) {
        do {
            try self.setupContext(uriFormat: "/<bucket-name>?acl")
        } catch {
            return (nil, error)
        }

        return APISender.qingStor(context: self.context, input: input, method: .put)
    }

    // putCORS: Set CORS information of the bucket.
    // Documentation URL: https://docs.qingcloud.com/qingstor/api/bucket/cors/put_cors.html
    public func putCORS(input: PutBucketCORSInput, completion: @escaping RequestCompletion<PutBucketCORSOutput>) {
        let (sender, error) = self.putCORSSender(input: input)

        if let error = error {
            completion(nil, error)
            return
        }

        sender!.sendAPI(completion: completion)
    }

    // putCORSSender create sender of putCORS.
    public func putCORSSender(input: PutBucketCORSInput) -> (APISender?, Error?) {
        do {
            try self.setupContext(uriFormat: "/<bucket-name>?cors")
        } catch {
            return (nil, error)
        }

        return APISender.qingStor(context: self.context, input: input, method: .put)
    }

    // putExternalMirror: Set external mirror of the bucket.
    // Documentation URL: https://docs.qingcloud.com/qingstor/api/bucket/external_mirror/put_external_mirror.html
    public func putExternalMirror(input: PutBucketExternalMirrorInput, completion: @escaping RequestCompletion<PutBucketExternalMirrorOutput>) {
        let (sender, error) = self.putExternalMirrorSender(input: input)

        if let error = error {
            completion(nil, error)
            return
        }

        sender!.sendAPI(completion: completion)
    }

    // putExternalMirrorSender create sender of putExternalMirror.
    public func putExternalMirrorSender(input: PutBucketExternalMirrorInput) -> (APISender?, Error?) {
        do {
            try self.setupContext(uriFormat: "/<bucket-name>?mirror")
        } catch {
            return (nil, error)
        }

        return APISender.qingStor(context: self.context, input: input, method: .put)
    }

    // putPolicy: Set policy information of the bucket.
    // Documentation URL: https://docs.qingcloud.com/qingstor/api/bucket/policy/put_policy.html
    public func putPolicy(input: PutBucketPolicyInput, completion: @escaping RequestCompletion<PutBucketPolicyOutput>) {
        let (sender, error) = self.putPolicySender(input: input)

        if let error = error {
            completion(nil, error)
            return
        }

        sender!.sendAPI(completion: completion)
    }

    // putPolicySender create sender of putPolicy.
    public func putPolicySender(input: PutBucketPolicyInput) -> (APISender?, Error?) {
        do {
            try self.setupContext(uriFormat: "/<bucket-name>?policy")
        } catch {
            return (nil, error)
        }

        return APISender.qingStor(context: self.context, input: input, method: .put)
    }

    // abortMultipartUpload: Abort multipart upload.
    // Documentation URL: https://docs.qingcloud.com/qingstor/api/object/abort_multipart_upload.html
    public func abortMultipartUpload(objectKey: String, input: AbortMultipartUploadInput, completion: @escaping RequestCompletion<AbortMultipartUploadOutput>) {
        let (sender, error) = self.abortMultipartUploadSender(objectKey: objectKey, input: input)

        if let error = error {
            completion(nil, error)
            return
        }

        sender!.sendAPI(completion: completion)
    }

    // abortMultipartUploadSender create sender of abortMultipartUpload.
    public func abortMultipartUploadSender(objectKey: String, input: AbortMultipartUploadInput) -> (APISender?, Error?) {
        do {
            try self.setupContext(uriFormat: "/<bucket-name>/<object-key>", objectKey: objectKey)
        } catch {
            return (nil, error)
        }

        return APISender.qingStor(context: self.context, input: input, method: .delete)
    }

    // completeMultipartUpload: Complete multipart upload.
    // Documentation URL: https://docs.qingcloud.com/qingstor/api/object/complete_multipart_upload.html
    public func completeMultipartUpload(objectKey: String, input: CompleteMultipartUploadInput, completion: @escaping RequestCompletion<CompleteMultipartUploadOutput>) {
        let (sender, error) = self.completeMultipartUploadSender(objectKey: objectKey, input: input)

        if let error = error {
            completion(nil, error)
            return
        }

        sender!.sendAPI(completion: completion)
    }

    // completeMultipartUploadSender create sender of completeMultipartUpload.
    public func completeMultipartUploadSender(objectKey: String, input: CompleteMultipartUploadInput) -> (APISender?, Error?) {
        do {
            try self.setupContext(uriFormat: "/<bucket-name>/<object-key>", objectKey: objectKey)
        } catch {
            return (nil, error)
        }

        return APISender.qingStor(context: self.context, input: input, method: .post)
    }

    // deleteObject: Delete the object.
    // Documentation URL: https://docs.qingcloud.com/qingstor/api/object/delete.html
    public func deleteObject(objectKey: String, input: DeleteObjectInput = DeleteObjectInput(), completion: @escaping RequestCompletion<DeleteObjectOutput>) {
        let (sender, error) = self.deleteObjectSender(objectKey: objectKey, input: input)

        if let error = error {
            completion(nil, error)
            return
        }

        sender!.sendAPI(completion: completion)
    }

    // deleteObjectSender create sender of deleteObject.
    public func deleteObjectSender(objectKey: String, input: DeleteObjectInput = DeleteObjectInput()) -> (APISender?, Error?) {
        do {
            try self.setupContext(uriFormat: "/<bucket-name>/<object-key>", objectKey: objectKey)
        } catch {
            return (nil, error)
        }

        return APISender.qingStor(context: self.context, input: input, method: .delete)
    }

    // getObject: Retrieve the object.
    // Documentation URL: https://docs.qingcloud.com/qingstor/api/object/get.html
    public func getObject(objectKey: String, input: GetObjectInput, completion: @escaping RequestCompletion<GetObjectOutput>) {
        let (sender, error) = self.getObjectSender(objectKey: objectKey, input: input)

        if let error = error {
            completion(nil, error)
            return
        }

        sender!.sendAPI(completion: completion)
    }

    // getObjectSender create sender of getObject.
    public func getObjectSender(objectKey: String, input: GetObjectInput) -> (APISender?, Error?) {
        do {
            try self.setupContext(uriFormat: "/<bucket-name>/<object-key>", objectKey: objectKey)
        } catch {
            return (nil, error)
        }

        return APISender.qingStor(context: self.context, input: input, method: .get)
    }

    // headObject: Check whether the object exists and available.
    // Documentation URL: https://docs.qingcloud.com/qingstor/api/object/head.html
    public func headObject(objectKey: String, input: HeadObjectInput, completion: @escaping RequestCompletion<HeadObjectOutput>) {
        let (sender, error) = self.headObjectSender(objectKey: objectKey, input: input)

        if let error = error {
            completion(nil, error)
            return
        }

        sender!.sendAPI(completion: completion)
    }

    // headObjectSender create sender of headObject.
    public func headObjectSender(objectKey: String, input: HeadObjectInput) -> (APISender?, Error?) {
        do {
            try self.setupContext(uriFormat: "/<bucket-name>/<object-key>", objectKey: objectKey)
        } catch {
            return (nil, error)
        }

        return APISender.qingStor(context: self.context, input: input, method: .head)
    }

    // initiateMultipartUpload: Initial multipart upload on the object.
    // Documentation URL: https://docs.qingcloud.com/qingstor/api/object/initiate_multipart_upload.html
    public func initiateMultipartUpload(objectKey: String, input: InitiateMultipartUploadInput, completion: @escaping RequestCompletion<InitiateMultipartUploadOutput>) {
        let (sender, error) = self.initiateMultipartUploadSender(objectKey: objectKey, input: input)

        if let error = error {
            completion(nil, error)
            return
        }

        sender!.sendAPI(completion: completion)
    }

    // initiateMultipartUploadSender create sender of initiateMultipartUpload.
    public func initiateMultipartUploadSender(objectKey: String, input: InitiateMultipartUploadInput) -> (APISender?, Error?) {
        do {
            try self.setupContext(uriFormat: "/<bucket-name>/<object-key>?uploads", objectKey: objectKey)
        } catch {
            return (nil, error)
        }

        return APISender.qingStor(context: self.context, input: input, method: .post)
    }

    // listMultipart: List object parts.
    // Documentation URL: https://docs.qingcloud.com/qingstor/api/object/list_multipart.html
    public func listMultipart(objectKey: String, input: ListMultipartInput, completion: @escaping RequestCompletion<ListMultipartOutput>) {
        let (sender, error) = self.listMultipartSender(objectKey: objectKey, input: input)

        if let error = error {
            completion(nil, error)
            return
        }

        sender!.sendAPI(completion: completion)
    }

    // listMultipartSender create sender of listMultipart.
    public func listMultipartSender(objectKey: String, input: ListMultipartInput) -> (APISender?, Error?) {
        do {
            try self.setupContext(uriFormat: "/<bucket-name>/<object-key>", objectKey: objectKey)
        } catch {
            return (nil, error)
        }

        return APISender.qingStor(context: self.context, input: input, method: .get)
    }

    // optionsObject: Check whether the object accepts a origin with method and header.
    // Documentation URL: https://docs.qingcloud.com/qingstor/api/object/options.html
    public func optionsObject(objectKey: String, input: OptionsObjectInput, completion: @escaping RequestCompletion<OptionsObjectOutput>) {
        let (sender, error) = self.optionsObjectSender(objectKey: objectKey, input: input)

        if let error = error {
            completion(nil, error)
            return
        }

        sender!.sendAPI(completion: completion)
    }

    // optionsObjectSender create sender of optionsObject.
    public func optionsObjectSender(objectKey: String, input: OptionsObjectInput) -> (APISender?, Error?) {
        do {
            try self.setupContext(uriFormat: "/<bucket-name>/<object-key>", objectKey: objectKey)
        } catch {
            return (nil, error)
        }

        return APISender.qingStor(context: self.context, input: input, method: .options)
    }

    // putObject: Upload the object.
    // Documentation URL: https://docs.qingcloud.com/qingstor/api/object/put.html
    public func putObject(objectKey: String, input: PutObjectInput, completion: @escaping RequestCompletion<PutObjectOutput>) {
        let (sender, error) = self.putObjectSender(objectKey: objectKey, input: input)

        if let error = error {
            completion(nil, error)
            return
        }

        sender!.sendAPI(completion: completion)
    }

    // putObjectSender create sender of putObject.
    public func putObjectSender(objectKey: String, input: PutObjectInput) -> (APISender?, Error?) {
        do {
            try self.setupContext(uriFormat: "/<bucket-name>/<object-key>", objectKey: objectKey)
        } catch {
            return (nil, error)
        }

        return APISender.qingStor(context: self.context, input: input, method: .put)
    }

    // uploadMultipart: Upload object multipart.
    // Documentation URL: https://docs.qingcloud.com/qingstor/api/object/multipart/upload_multipart.html
    public func uploadMultipart(objectKey: String, input: UploadMultipartInput, completion: @escaping RequestCompletion<UploadMultipartOutput>) {
        let (sender, error) = self.uploadMultipartSender(objectKey: objectKey, input: input)

        if let error = error {
            completion(nil, error)
            return
        }

        sender!.sendAPI(completion: completion)
    }

    // uploadMultipartSender create sender of uploadMultipart.
    public func uploadMultipartSender(objectKey: String, input: UploadMultipartInput) -> (APISender?, Error?) {
        do {
            try self.setupContext(uriFormat: "/<bucket-name>/<object-key>", objectKey: objectKey)
        } catch {
            return (nil, error)
        }

        return APISender.qingStor(context: self.context, input: input, method: .put)
    }

}


public class DeleteBucketInput: QingStorInput { }

public class DeleteBucketOutput: QingStorOutput { }


public class DeleteBucketCORSInput: QingStorInput { }

public class DeleteBucketCORSOutput: QingStorOutput { }


public class DeleteBucketExternalMirrorInput: QingStorInput { }

public class DeleteBucketExternalMirrorOutput: QingStorOutput { }


public class DeleteBucketPolicyInput: QingStorInput { }

public class DeleteBucketPolicyOutput: QingStorOutput { }


public class DeleteMultipleObjectsInput: QingStorInput {
    // A list of keys to delete
    public var objects: [KeyModel]! // Required
    // Whether to return the list of deleted objects
    public var quiet: Bool? = nil

    override var headerProperties: [String] {
        return ["Content-MD5"]
    }

    override var bodyProperties: [String] {
        return ["objects", "quiet"]
    }

    public required init?(map: Map) {
        super.init(map: map)
    }

    public init(objects: [KeyModel], quiet: Bool? = nil) {
        super.init()

        self.objects = objects
        self.quiet = quiet
    }

    public override func mapping(map: Map) {
        super.mapping(map: map)

        objects <- map["objects"]
        quiet <- map["quiet"]
    }

    public override func toParameters() -> [String: Any] {
        var parameters = super.toParameters()
        parameters["Content-MD5"] = (try! JSONSerialization.data(withJSONObject: parameters)).md5().base64EncodedString()

        return parameters
    }

    public override func validate() -> Error? {
        if self.objects == nil {
            return APIError.parameterRequiredError(name: "objects", parentName: "DeleteMultipleObjectsInput")
        }

        if self.objects.count == 0 {
            return APIError.parameterRequiredError(name: "objects", parentName: "DeleteMultipleObjectsInput")
        }

        if let objects = self.objects {
            if objects.count > 0 {
                for property in objects {
                    if let error = property.validate() {
                        return error
                    }
                }
            }
        }

        return nil
    }
}

public class DeleteMultipleObjectsOutput: QingStorOutput {
    // List of deleted objects
    public var deleted: [KeyModel]? = nil
    // Error messages
    public var errors: [KeyDeleteErrorModel]? = nil

    public override func mapping(map: Map) {
        super.mapping(map: map)

        deleted <- map["deleted"]
        errors <- map["errors"]
    }
}


public class GetBucketACLInput: QingStorInput { }

public class GetBucketACLOutput: QingStorOutput {
    // Bucket ACL rules
    public var acl: [ACLModel]? = nil
    // Bucket owner
    public var owner: OwnerModel? = nil

    public override func mapping(map: Map) {
        super.mapping(map: map)

        acl <- map["acl"]
        owner <- map["owner"]
    }
}


public class GetBucketCORSInput: QingStorInput { }

public class GetBucketCORSOutput: QingStorOutput {
    // Bucket CORS rules
    public var corsRules: [CORSRuleModel]? = nil

    public override func mapping(map: Map) {
        super.mapping(map: map)

        corsRules <- map["cors_rules"]
    }
}


public class GetBucketExternalMirrorInput: QingStorInput { }

public class GetBucketExternalMirrorOutput: QingStorOutput {
    // Source site url
    public var sourceSite: String? = nil

    public override func mapping(map: Map) {
        super.mapping(map: map)

        sourceSite <- map["source_site"]
    }
}


public class GetBucketPolicyInput: QingStorInput { }

public class GetBucketPolicyOutput: QingStorOutput {
    // Bucket policy statement
    public var statement: [StatementModel]? = nil

    public override func mapping(map: Map) {
        super.mapping(map: map)

        statement <- map["statement"]
    }
}


public class GetBucketStatisticsInput: QingStorInput { }

public class GetBucketStatisticsOutput: QingStorOutput {
    // Objects count in the bucket
    public var count: Int? = nil
    // Bucket created time
    public var created: Date? = nil
    // QingCloud Zone ID
    public var location: String? = nil
    // Bucket name
    public var name: String? = nil
    // Bucket storage size
    public var size: Int? = nil
    // Bucket status
    // status's available values: active, suspended
    public var status: String? = nil
    // URL to access the bucket
    public var url: String? = nil

    public override func mapping(map: Map) {
        super.mapping(map: map)

        count <- map["count"]
        created <- (map["created"], ISO8601DateTransform())
        location <- map["location"]
        name <- map["name"]
        size <- map["size"]
        status <- map["status"]
        url <- map["url"]
    }
}


public class HeadBucketInput: QingStorInput { }

public class HeadBucketOutput: QingStorOutput { }


public class ListMultipartUploadsInput: QingStorInput {
    // Put all keys that share a common prefix into a list
    public var delimiter: String? = nil
    // Results count limit
    public var limit: Int? = nil
    // Limit results to keys that start at this marker
    public var marker: String? = nil
    // Limits results to keys that begin with the prefix
    public var prefix: String? = nil

    override var queryProperties: [String] {
        return ["delimiter", "limit", "marker", "prefix"]
    }

    public required init?(map: Map) {
        super.init(map: map)
    }

    public init(delimiter: String? = nil, limit: Int? = nil, marker: String? = nil, prefix: String? = nil) {
        super.init()

        self.delimiter = delimiter
        self.limit = limit
        self.marker = marker
        self.prefix = prefix
    }

    public override func mapping(map: Map) {
        super.mapping(map: map)

        delimiter <- map["delimiter"]
        limit <- map["limit"]
        marker <- map["marker"]
        prefix <- map["prefix"]
    }

    public override func validate() -> Error? {
        return nil
    }
}

public class ListMultipartUploadsOutput: QingStorOutput {
    // Other object keys that share common prefixes
    public var commonPrefixes: [String]? = nil
    // Delimiter that specified in request parameters
    public var delimiter: String? = nil
    // Limit that specified in request parameters
    public var limit: Int? = nil
    // Marker that specified in request parameters
    public var marker: String? = nil
    // Bucket name
    public var name: String? = nil
    // The last key in keys list
    public var nextMarker: String? = nil
    // Prefix that specified in request parameters
    public var prefix: String? = nil
    // Multipart uploads
    public var uploads: [UploadsModel]? = nil

    public override func mapping(map: Map) {
        super.mapping(map: map)

        commonPrefixes <- map["common_prefixes"]
        delimiter <- map["delimiter"]
        limit <- map["limit"]
        marker <- map["marker"]
        name <- map["name"]
        nextMarker <- map["next_marker"]
        prefix <- map["prefix"]
        uploads <- map["uploads"]
    }
}


public class ListObjectsInput: QingStorInput {
    // Put all keys that share a common prefix into a list
    public var delimiter: String? = nil
    // Results count limit
    public var limit: Int? = nil
    // Limit results to keys that start at this marker
    public var marker: String? = nil
    // Limits results to keys that begin with the prefix
    public var prefix: String? = nil

    override var queryProperties: [String] {
        return ["delimiter", "limit", "marker", "prefix"]
    }

    public required init?(map: Map) {
        super.init(map: map)
    }

    public init(delimiter: String? = nil, limit: Int? = nil, marker: String? = nil, prefix: String? = nil) {
        super.init()

        self.delimiter = delimiter
        self.limit = limit
        self.marker = marker
        self.prefix = prefix
    }

    public override func mapping(map: Map) {
        super.mapping(map: map)

        delimiter <- map["delimiter"]
        limit <- map["limit"]
        marker <- map["marker"]
        prefix <- map["prefix"]
    }

    public override func validate() -> Error? {
        return nil
    }
}

public class ListObjectsOutput: QingStorOutput {
    // Other object keys that share common prefixes
    public var commonPrefixes: [String]? = nil
    // Delimiter that specified in request parameters
    public var delimiter: String? = nil
    // Object keys
    public var keys: [KeyModel]? = nil
    // Limit that specified in request parameters
    public var limit: Int? = nil
    // Marker that specified in request parameters
    public var marker: String? = nil
    // Bucket name
    public var name: String? = nil
    // The last key in keys list
    public var nextMarker: String? = nil
    // Bucket owner
    public var owner: OwnerModel? = nil
    // Prefix that specified in request parameters
    public var prefix: String? = nil

    public override func mapping(map: Map) {
        super.mapping(map: map)

        commonPrefixes <- map["common_prefixes"]
        delimiter <- map["delimiter"]
        keys <- map["keys"]
        limit <- map["limit"]
        marker <- map["marker"]
        name <- map["name"]
        nextMarker <- map["next_marker"]
        owner <- map["owner"]
        prefix <- map["prefix"]
    }
}


public class PutBucketInput: QingStorInput { }

public class PutBucketOutput: QingStorOutput { }


public class PutBucketACLInput: QingStorInput {
    // Bucket ACL rules
    public var acl: [ACLModel]! // Required

    override var bodyProperties: [String] {
        return ["acl"]
    }

    public required init?(map: Map) {
        super.init(map: map)
    }

    public init(acl: [ACLModel]) {
        super.init()

        self.acl = acl
    }

    public override func mapping(map: Map) {
        super.mapping(map: map)

        acl <- map["acl"]
    }

    public override func validate() -> Error? {
        if self.acl == nil {
            return APIError.parameterRequiredError(name: "acl", parentName: "PutBucketACLInput")
        }

        if self.acl.count == 0 {
            return APIError.parameterRequiredError(name: "acl", parentName: "PutBucketACLInput")
        }

        if let acl = self.acl {
            if acl.count > 0 {
                for property in acl {
                    if let error = property.validate() {
                        return error
                    }
                }
            }
        }

        return nil
    }
}

public class PutBucketACLOutput: QingStorOutput { }


public class PutBucketCORSInput: QingStorInput {
    // Bucket CORS rules
    public var corsRules: [CORSRuleModel]! // Required

    override var bodyProperties: [String] {
        return ["cors_rules"]
    }

    public required init?(map: Map) {
        super.init(map: map)
    }

    public init(corsRules: [CORSRuleModel]) {
        super.init()

        self.corsRules = corsRules
    }

    public override func mapping(map: Map) {
        super.mapping(map: map)

        corsRules <- map["cors_rules"]
    }

    public override func validate() -> Error? {
        if self.corsRules == nil {
            return APIError.parameterRequiredError(name: "corsRules", parentName: "PutBucketCORSInput")
        }

        if self.corsRules.count == 0 {
            return APIError.parameterRequiredError(name: "corsRules", parentName: "PutBucketCORSInput")
        }

        if let corsRules = self.corsRules {
            if corsRules.count > 0 {
                for property in corsRules {
                    if let error = property.validate() {
                        return error
                    }
                }
            }
        }

        return nil
    }
}

public class PutBucketCORSOutput: QingStorOutput { }


public class PutBucketExternalMirrorInput: QingStorInput {
    // Source site url
    public var sourceSite: String! // Required

    override var bodyProperties: [String] {
        return ["source_site"]
    }

    public required init?(map: Map) {
        super.init(map: map)
    }

    public init(sourceSite: String) {
        super.init()

        self.sourceSite = sourceSite
    }

    public override func mapping(map: Map) {
        super.mapping(map: map)

        sourceSite <- map["source_site"]
    }

    public override func validate() -> Error? {
        if self.sourceSite == nil {
            return APIError.parameterRequiredError(name: "sourceSite", parentName: "PutBucketExternalMirrorInput")
        }

        return nil
    }
}

public class PutBucketExternalMirrorOutput: QingStorOutput { }


public class PutBucketPolicyInput: QingStorInput {
    // Bucket policy statement
    public var statement: [StatementModel]! // Required

    override var bodyProperties: [String] {
        return ["statement"]
    }

    public required init?(map: Map) {
        super.init(map: map)
    }

    public init(statement: [StatementModel]) {
        super.init()

        self.statement = statement
    }

    public override func mapping(map: Map) {
        super.mapping(map: map)

        statement <- map["statement"]
    }

    public override func validate() -> Error? {
        if self.statement == nil {
            return APIError.parameterRequiredError(name: "statement", parentName: "PutBucketPolicyInput")
        }

        if self.statement.count == 0 {
            return APIError.parameterRequiredError(name: "statement", parentName: "PutBucketPolicyInput")
        }

        if let statement = self.statement {
            if statement.count > 0 {
                for property in statement {
                    if let error = property.validate() {
                        return error
                    }
                }
            }
        }

        return nil
    }
}

public class PutBucketPolicyOutput: QingStorOutput { }


public class AbortMultipartUploadInput: QingStorInput {
    // Object multipart upload ID
    public var uploadID: String! // Required

    override var queryProperties: [String] {
        return ["upload_id"]
    }

    public required init?(map: Map) {
        super.init(map: map)
    }

    public init(uploadID: String) {
        super.init()

        self.uploadID = uploadID
    }

    public override func mapping(map: Map) {
        super.mapping(map: map)

        uploadID <- map["upload_id"]
    }

    public override func validate() -> Error? {
        if self.uploadID == nil {
            return APIError.parameterRequiredError(name: "uploadID", parentName: "AbortMultipartUploadInput")
        }

        return nil
    }
}

public class AbortMultipartUploadOutput: QingStorOutput { }


public class CompleteMultipartUploadInput: QingStorInput {
    // Object multipart upload ID
    public var uploadID: String! // Required
    // MD5sum of the object part
    public var etag: String? = nil
    // Encryption algorithm of the object
    public var xQSEncryptionCustomerAlgorithm: String? = nil
    // Encryption key of the object
    public var xQSEncryptionCustomerKey: String? = nil
    // MD5sum of encryption key
    public var xQSEncryptionCustomerKeyMD5: String? = nil
    // Object parts
    public var objectParts: [ObjectPartModel]? = nil

    override var queryProperties: [String] {
        return ["upload_id"]
    }

    override var headerProperties: [String] {
        return ["ETag", "X-QS-Encryption-Customer-Algorithm", "X-QS-Encryption-Customer-Key", "X-QS-Encryption-Customer-Key-MD5"]
    }

    override var bodyProperties: [String] {
        return ["object_parts"]
    }

    public required init?(map: Map) {
        super.init(map: map)
    }

    public init(uploadID: String, etag: String? = nil, xQSEncryptionCustomerAlgorithm: String? = nil, xQSEncryptionCustomerKey: String? = nil, xQSEncryptionCustomerKeyMD5: String? = nil, objectParts: [ObjectPartModel]? = nil) {
        super.init()

        self.uploadID = uploadID
        self.etag = etag
        self.xQSEncryptionCustomerAlgorithm = xQSEncryptionCustomerAlgorithm
        self.xQSEncryptionCustomerKey = xQSEncryptionCustomerKey
        self.xQSEncryptionCustomerKeyMD5 = xQSEncryptionCustomerKeyMD5
        self.objectParts = objectParts
    }

    public override func mapping(map: Map) {
        super.mapping(map: map)

        uploadID <- map["upload_id"]
        etag <- map["ETag"]
        xQSEncryptionCustomerAlgorithm <- map["X-QS-Encryption-Customer-Algorithm"]
        xQSEncryptionCustomerKey <- map["X-QS-Encryption-Customer-Key"]
        xQSEncryptionCustomerKeyMD5 <- map["X-QS-Encryption-Customer-Key-MD5"]
        objectParts <- map["object_parts"]
    }

    public override func validate() -> Error? {
        if self.uploadID == nil {
            return APIError.parameterRequiredError(name: "uploadID", parentName: "CompleteMultipartUploadInput")
        }

        if let objectParts = self.objectParts {
            if objectParts.count > 0 {
                for property in objectParts {
                    if let error = property.validate() {
                        return error
                    }
                }
            }
        }

        return nil
    }
}

public class CompleteMultipartUploadOutput: QingStorOutput { }


public class DeleteObjectInput: QingStorInput { }

public class DeleteObjectOutput: QingStorOutput { }


public class GetObjectInput: QingStorDownloadInput {
    // Specified the Cache-Control response header
    public var responseCacheControl: String? = nil
    // Specified the Content-Disposition response header
    public var responseContentDisposition: String? = nil
    // Specified the Content-Encoding response header
    public var responseContentEncoding: String? = nil
    // Specified the Content-Language response header
    public var responseContentLanguage: String? = nil
    // Specified the Content-Type response header
    public var responseContentType: String? = nil
    // Specified the Expires response header
    public var responseExpires: String? = nil
    // Check whether the ETag matches
    public var ifMatch: String? = nil
    // Check whether the object has been modified
    public var ifModifiedSince: Date? = nil
    // Check whether the ETag does not match
    public var ifNoneMatch: String? = nil
    // Check whether the object has not been modified
    public var ifUnmodifiedSince: Date? = nil
    // Specified range of the object
    public var range: String? = nil
    // Encryption algorithm of the object
    public var xQSEncryptionCustomerAlgorithm: String? = nil
    // Encryption key of the object
    public var xQSEncryptionCustomerKey: String? = nil
    // MD5sum of encryption key
    public var xQSEncryptionCustomerKeyMD5: String? = nil

    override var queryProperties: [String] {
        return ["response-cache-control", "response-content-disposition", "response-content-encoding", "response-content-language", "response-content-type", "response-expires"]
    }

    override var headerProperties: [String] {
        return ["If-Match", "If-Modified-Since", "If-None-Match", "If-Unmodified-Since", "Range", "X-QS-Encryption-Customer-Algorithm", "X-QS-Encryption-Customer-Key", "X-QS-Encryption-Customer-Key-MD5"]
    }

    public required init?(map: Map) {
        super.init(map: map)
    }

    public init(responseCacheControl: String? = nil, responseContentDisposition: String? = nil, responseContentEncoding: String? = nil, responseContentLanguage: String? = nil, responseContentType: String? = nil, responseExpires: String? = nil, ifMatch: String? = nil, ifModifiedSince: Date? = nil, ifNoneMatch: String? = nil, ifUnmodifiedSince: Date? = nil, range: String? = nil, xQSEncryptionCustomerAlgorithm: String? = nil, xQSEncryptionCustomerKey: String? = nil, xQSEncryptionCustomerKeyMD5: String? = nil) {
        super.init()

        self.responseCacheControl = responseCacheControl
        self.responseContentDisposition = responseContentDisposition
        self.responseContentEncoding = responseContentEncoding
        self.responseContentLanguage = responseContentLanguage
        self.responseContentType = responseContentType
        self.responseExpires = responseExpires
        self.ifMatch = ifMatch
        self.ifModifiedSince = ifModifiedSince
        self.ifNoneMatch = ifNoneMatch
        self.ifUnmodifiedSince = ifUnmodifiedSince
        self.range = range
        self.xQSEncryptionCustomerAlgorithm = xQSEncryptionCustomerAlgorithm
        self.xQSEncryptionCustomerKey = xQSEncryptionCustomerKey
        self.xQSEncryptionCustomerKeyMD5 = xQSEncryptionCustomerKeyMD5
    }

    public override func mapping(map: Map) {
        super.mapping(map: map)

        responseCacheControl <- map["response-cache-control"]
        responseContentDisposition <- map["response-content-disposition"]
        responseContentEncoding <- map["response-content-encoding"]
        responseContentLanguage <- map["response-content-language"]
        responseContentType <- map["response-content-type"]
        responseExpires <- map["response-expires"]
        ifMatch <- map["If-Match"]
        ifModifiedSince <- (map["If-Modified-Since"], RFC822DateTransform())
        ifNoneMatch <- map["If-None-Match"]
        ifUnmodifiedSince <- (map["If-Unmodified-Since"], RFC822DateTransform())
        range <- map["Range"]
        xQSEncryptionCustomerAlgorithm <- map["X-QS-Encryption-Customer-Algorithm"]
        xQSEncryptionCustomerKey <- map["X-QS-Encryption-Customer-Key"]
        xQSEncryptionCustomerKeyMD5 <- map["X-QS-Encryption-Customer-Key-MD5"]
    }

    public override func validate() -> Error? {
        return nil
    }
}

public class GetObjectOutput: QingStorDownloadOutput {
    // Range of response data content
    public var contentRange: String? = nil
    // MD5sum of the object
    public var etag: String? = nil
    // Encryption algorithm of the object
    public var xQSEncryptionCustomerAlgorithm: String? = nil

    public override func mapping(map: Map) {
        super.mapping(map: map)

        contentRange <- map["Content-Range"]
        etag <- map["ETag"]
        xQSEncryptionCustomerAlgorithm <- map["X-QS-Encryption-Customer-Algorithm"]
    }
}


public class HeadObjectInput: QingStorInput {
    // Check whether the ETag matches
    public var ifMatch: String? = nil
    // Check whether the object has been modified
    public var ifModifiedSince: Date? = nil
    // Check whether the ETag does not match
    public var ifNoneMatch: String? = nil
    // Check whether the object has not been modified
    public var ifUnmodifiedSince: Date? = nil
    // Encryption algorithm of the object
    public var xQSEncryptionCustomerAlgorithm: String? = nil
    // Encryption key of the object
    public var xQSEncryptionCustomerKey: String? = nil
    // MD5sum of encryption key
    public var xQSEncryptionCustomerKeyMD5: String? = nil

    override var headerProperties: [String] {
        return ["If-Match", "If-Modified-Since", "If-None-Match", "If-Unmodified-Since", "X-QS-Encryption-Customer-Algorithm", "X-QS-Encryption-Customer-Key", "X-QS-Encryption-Customer-Key-MD5"]
    }

    public required init?(map: Map) {
        super.init(map: map)
    }

    public init(ifMatch: String? = nil, ifModifiedSince: Date? = nil, ifNoneMatch: String? = nil, ifUnmodifiedSince: Date? = nil, xQSEncryptionCustomerAlgorithm: String? = nil, xQSEncryptionCustomerKey: String? = nil, xQSEncryptionCustomerKeyMD5: String? = nil) {
        super.init()

        self.ifMatch = ifMatch
        self.ifModifiedSince = ifModifiedSince
        self.ifNoneMatch = ifNoneMatch
        self.ifUnmodifiedSince = ifUnmodifiedSince
        self.xQSEncryptionCustomerAlgorithm = xQSEncryptionCustomerAlgorithm
        self.xQSEncryptionCustomerKey = xQSEncryptionCustomerKey
        self.xQSEncryptionCustomerKeyMD5 = xQSEncryptionCustomerKeyMD5
    }

    public override func mapping(map: Map) {
        super.mapping(map: map)

        ifMatch <- map["If-Match"]
        ifModifiedSince <- (map["If-Modified-Since"], RFC822DateTransform())
        ifNoneMatch <- map["If-None-Match"]
        ifUnmodifiedSince <- (map["If-Unmodified-Since"], RFC822DateTransform())
        xQSEncryptionCustomerAlgorithm <- map["X-QS-Encryption-Customer-Algorithm"]
        xQSEncryptionCustomerKey <- map["X-QS-Encryption-Customer-Key"]
        xQSEncryptionCustomerKeyMD5 <- map["X-QS-Encryption-Customer-Key-MD5"]
    }

    public override func validate() -> Error? {
        return nil
    }
}

public class HeadObjectOutput: QingStorOutput {
    // Object content length
    public var contentLength: Int? = nil
    // Object content type
    public var contentType: String? = nil
    // MD5sum of the object
    public var etag: String? = nil
    public var lastModified: Date? = nil
    // Encryption algorithm of the object
    public var xQSEncryptionCustomerAlgorithm: String? = nil

    public override func mapping(map: Map) {
        super.mapping(map: map)

        contentLength <- map["Content-Length"]
        contentType <- map["Content-Type"]
        etag <- map["ETag"]
        lastModified <- (map["Last-Modified"], RFC822DateTransform())
        xQSEncryptionCustomerAlgorithm <- map["X-QS-Encryption-Customer-Algorithm"]
    }
}


public class InitiateMultipartUploadInput: QingStorInput {
    // Object content type
    public var contentType: String? = nil
    // Encryption algorithm of the object
    public var xQSEncryptionCustomerAlgorithm: String? = nil
    // Encryption key of the object
    public var xQSEncryptionCustomerKey: String? = nil
    // MD5sum of encryption key
    public var xQSEncryptionCustomerKeyMD5: String? = nil

    override var headerProperties: [String] {
        return ["Content-Type", "X-QS-Encryption-Customer-Algorithm", "X-QS-Encryption-Customer-Key", "X-QS-Encryption-Customer-Key-MD5"]
    }

    public required init?(map: Map) {
        super.init(map: map)
    }

    public init(contentType: String? = nil, xQSEncryptionCustomerAlgorithm: String? = nil, xQSEncryptionCustomerKey: String? = nil, xQSEncryptionCustomerKeyMD5: String? = nil) {
        super.init()

        self.contentType = contentType
        self.xQSEncryptionCustomerAlgorithm = xQSEncryptionCustomerAlgorithm
        self.xQSEncryptionCustomerKey = xQSEncryptionCustomerKey
        self.xQSEncryptionCustomerKeyMD5 = xQSEncryptionCustomerKeyMD5
    }

    public override func mapping(map: Map) {
        super.mapping(map: map)

        contentType <- map["Content-Type"]
        xQSEncryptionCustomerAlgorithm <- map["X-QS-Encryption-Customer-Algorithm"]
        xQSEncryptionCustomerKey <- map["X-QS-Encryption-Customer-Key"]
        xQSEncryptionCustomerKeyMD5 <- map["X-QS-Encryption-Customer-Key-MD5"]
    }

    public override func validate() -> Error? {
        return nil
    }
}

public class InitiateMultipartUploadOutput: QingStorOutput {
    // Encryption algorithm of the object
    public var xQSEncryptionCustomerAlgorithm: String? = nil
    // Bucket name
    public var bucket: String? = nil
    // Object key
    public var key: String? = nil
    // Object multipart upload ID
    public var uploadID: String? = nil

    public override func mapping(map: Map) {
        super.mapping(map: map)

        xQSEncryptionCustomerAlgorithm <- map["X-QS-Encryption-Customer-Algorithm"]
        bucket <- map["bucket"]
        key <- map["key"]
        uploadID <- map["upload_id"]
    }
}


public class ListMultipartInput: QingStorInput {
    // Limit results count
    public var limit: Int? = nil
    // Object multipart upload part number
    public var partNumberMarker: Int? = nil
    // Object multipart upload ID
    public var uploadID: String! // Required

    override var queryProperties: [String] {
        return ["limit", "part_number_marker", "upload_id"]
    }

    public required init?(map: Map) {
        super.init(map: map)
    }

    public init(limit: Int? = nil, partNumberMarker: Int? = nil, uploadID: String) {
        super.init()

        self.limit = limit
        self.partNumberMarker = partNumberMarker
        self.uploadID = uploadID
    }

    public override func mapping(map: Map) {
        super.mapping(map: map)

        limit <- map["limit"]
        partNumberMarker <- map["part_number_marker"]
        uploadID <- map["upload_id"]
    }

    public override func validate() -> Error? {
        if self.uploadID == nil {
            return APIError.parameterRequiredError(name: "uploadID", parentName: "ListMultipartInput")
        }

        return nil
    }
}

public class ListMultipartOutput: QingStorOutput {
    // Object multipart count
    public var count: Int? = nil
    // Object parts
    public var objectParts: [ObjectPartModel]? = nil

    public override func mapping(map: Map) {
        super.mapping(map: map)

        count <- map["count"]
        objectParts <- map["object_parts"]
    }
}


public class OptionsObjectInput: QingStorInput {
    // Request headers
    public var accessControlRequestHeaders: String? = nil
    // Request method
    public var accessControlRequestMethod: String! // Required
    // Request origin
    public var origin: String! // Required

    override var headerProperties: [String] {
        return ["Access-Control-Request-Headers", "Access-Control-Request-Method", "Origin"]
    }

    public required init?(map: Map) {
        super.init(map: map)
    }

    public init(accessControlRequestHeaders: String? = nil, accessControlRequestMethod: String, origin: String) {
        super.init()

        self.accessControlRequestHeaders = accessControlRequestHeaders
        self.accessControlRequestMethod = accessControlRequestMethod
        self.origin = origin
    }

    public override func mapping(map: Map) {
        super.mapping(map: map)

        accessControlRequestHeaders <- map["Access-Control-Request-Headers"]
        accessControlRequestMethod <- map["Access-Control-Request-Method"]
        origin <- map["Origin"]
    }

    public override func validate() -> Error? {
        if self.accessControlRequestMethod == nil {
            return APIError.parameterRequiredError(name: "accessControlRequestMethod", parentName: "OptionsObjectInput")
        }

        if self.origin == nil {
            return APIError.parameterRequiredError(name: "origin", parentName: "OptionsObjectInput")
        }

        return nil
    }
}

public class OptionsObjectOutput: QingStorOutput {
    // Allowed headers
    public var accessControlAllowHeaders: String? = nil
    // Allowed methods
    public var accessControlAllowMethods: String? = nil
    // Allowed origin
    public var accessControlAllowOrigin: String? = nil
    // Expose headers
    public var accessControlExposeHeaders: String? = nil
    // Max age
    public var accessControlMaxAge: String? = nil

    public override func mapping(map: Map) {
        super.mapping(map: map)

        accessControlAllowHeaders <- map["Access-Control-Allow-Headers"]
        accessControlAllowMethods <- map["Access-Control-Allow-Methods"]
        accessControlAllowOrigin <- map["Access-Control-Allow-Origin"]
        accessControlExposeHeaders <- map["Access-Control-Expose-Headers"]
        accessControlMaxAge <- map["Access-Control-Max-Age"]
    }
}


public class PutObjectInput: QingStorInput {
    // Object content size
    public var contentLength: Int! // Required
    // Object MD5sum
    public var contentMD5: String? = nil
    // Object content type
    public var contentType: String? = nil
    // Used to indicate that particular server behaviors are required by the client
    public var expect: String? = nil
    // Copy source, format (/<bucket-name>/<object-key>)
    public var xQSCopySource: String? = nil
    // Encryption algorithm of the object
    public var xQSCopySourceEncryptionCustomerAlgorithm: String? = nil
    // Encryption key of the object
    public var xQSCopySourceEncryptionCustomerKey: String? = nil
    // MD5sum of encryption key
    public var xQSCopySourceEncryptionCustomerKeyMD5: String? = nil
    // Check whether the copy source matches
    public var xQSCopySourceIfMatch: String? = nil
    // Check whether the copy source has been modified
    public var xQSCopySourceIfModifiedSince: Date? = nil
    // Check whether the copy source does not match
    public var xQSCopySourceIfNoneMatch: String? = nil
    // Check whether the copy source has not been modified
    public var xQSCopySourceIfUnmodifiedSince: Date? = nil
    // Encryption algorithm of the object
    public var xQSEncryptionCustomerAlgorithm: String? = nil
    // Encryption key of the object
    public var xQSEncryptionCustomerKey: String? = nil
    // MD5sum of encryption key
    public var xQSEncryptionCustomerKeyMD5: String? = nil
    // Check whether fetch target object has not been modified
    public var xQSFetchIfUnmodifiedSince: Date? = nil
    // Fetch source, should be a valid url
    public var xQSFetchSource: String? = nil
    // Move source, format (/<bucket-name>/<object-key>)
    public var xQSMoveSource: String? = nil
    // The request body
    public var bodyInputStream: InputStream?

    override var headerProperties: [String] {
        return ["Content-Length", "Content-MD5", "Content-Type", "Expect", "X-QS-Copy-Source", "X-QS-Copy-Source-Encryption-Customer-Algorithm", "X-QS-Copy-Source-Encryption-Customer-Key", "X-QS-Copy-Source-Encryption-Customer-Key-MD5", "X-QS-Copy-Source-If-Match", "X-QS-Copy-Source-If-Modified-Since", "X-QS-Copy-Source-If-None-Match", "X-QS-Copy-Source-If-Unmodified-Since", "X-QS-Encryption-Customer-Algorithm", "X-QS-Encryption-Customer-Key", "X-QS-Encryption-Customer-Key-MD5", "X-QS-Fetch-If-Unmodified-Since", "X-QS-Fetch-Source", "X-QS-Move-Source"]
    }

    override var bodyProperties: [String] {
        return ["body"]
    }

    public required init?(map: Map) {
        super.init(map: map)
    }

    public init(contentLength: Int, contentMD5: String? = nil, contentType: String? = nil, expect: String? = nil, xQSCopySource: String? = nil, xQSCopySourceEncryptionCustomerAlgorithm: String? = nil, xQSCopySourceEncryptionCustomerKey: String? = nil, xQSCopySourceEncryptionCustomerKeyMD5: String? = nil, xQSCopySourceIfMatch: String? = nil, xQSCopySourceIfModifiedSince: Date? = nil, xQSCopySourceIfNoneMatch: String? = nil, xQSCopySourceIfUnmodifiedSince: Date? = nil, xQSEncryptionCustomerAlgorithm: String? = nil, xQSEncryptionCustomerKey: String? = nil, xQSEncryptionCustomerKeyMD5: String? = nil, xQSFetchIfUnmodifiedSince: Date? = nil, xQSFetchSource: String? = nil, xQSMoveSource: String? = nil, bodyInputStream: InputStream? = nil) {
        super.init()

        self.contentLength = contentLength
        self.contentMD5 = contentMD5
        self.contentType = contentType
        self.expect = expect
        self.xQSCopySource = xQSCopySource
        self.xQSCopySourceEncryptionCustomerAlgorithm = xQSCopySourceEncryptionCustomerAlgorithm
        self.xQSCopySourceEncryptionCustomerKey = xQSCopySourceEncryptionCustomerKey
        self.xQSCopySourceEncryptionCustomerKeyMD5 = xQSCopySourceEncryptionCustomerKeyMD5
        self.xQSCopySourceIfMatch = xQSCopySourceIfMatch
        self.xQSCopySourceIfModifiedSince = xQSCopySourceIfModifiedSince
        self.xQSCopySourceIfNoneMatch = xQSCopySourceIfNoneMatch
        self.xQSCopySourceIfUnmodifiedSince = xQSCopySourceIfUnmodifiedSince
        self.xQSEncryptionCustomerAlgorithm = xQSEncryptionCustomerAlgorithm
        self.xQSEncryptionCustomerKey = xQSEncryptionCustomerKey
        self.xQSEncryptionCustomerKeyMD5 = xQSEncryptionCustomerKeyMD5
        self.xQSFetchIfUnmodifiedSince = xQSFetchIfUnmodifiedSince
        self.xQSFetchSource = xQSFetchSource
        self.xQSMoveSource = xQSMoveSource
        self.bodyInputStream = bodyInputStream
    }

    public override func mapping(map: Map) {
        super.mapping(map: map)

        contentLength <- map["Content-Length"]
        contentMD5 <- map["Content-MD5"]
        contentType <- map["Content-Type"]
        expect <- map["Expect"]
        xQSCopySource <- map["X-QS-Copy-Source"]
        xQSCopySourceEncryptionCustomerAlgorithm <- map["X-QS-Copy-Source-Encryption-Customer-Algorithm"]
        xQSCopySourceEncryptionCustomerKey <- map["X-QS-Copy-Source-Encryption-Customer-Key"]
        xQSCopySourceEncryptionCustomerKeyMD5 <- map["X-QS-Copy-Source-Encryption-Customer-Key-MD5"]
        xQSCopySourceIfMatch <- map["X-QS-Copy-Source-If-Match"]
        xQSCopySourceIfModifiedSince <- (map["X-QS-Copy-Source-If-Modified-Since"], RFC822DateTransform())
        xQSCopySourceIfNoneMatch <- map["X-QS-Copy-Source-If-None-Match"]
        xQSCopySourceIfUnmodifiedSince <- (map["X-QS-Copy-Source-If-Unmodified-Since"], RFC822DateTransform())
        xQSEncryptionCustomerAlgorithm <- map["X-QS-Encryption-Customer-Algorithm"]
        xQSEncryptionCustomerKey <- map["X-QS-Encryption-Customer-Key"]
        xQSEncryptionCustomerKeyMD5 <- map["X-QS-Encryption-Customer-Key-MD5"]
        xQSFetchIfUnmodifiedSince <- (map["X-QS-Fetch-If-Unmodified-Since"], RFC822DateTransform())
        xQSFetchSource <- map["X-QS-Fetch-Source"]
        xQSMoveSource <- map["X-QS-Move-Source"]
    }

    public override func toParameters() -> [String: Any] {
        var parameters = super.toParameters()
        parameters["body"] = self.bodyInputStream

        return parameters
    }

    public override func validate() -> Error? {
        if self.contentLength == nil {
            return APIError.parameterRequiredError(name: "contentLength", parentName: "PutObjectInput")
        }

        return nil
    }
}

public class PutObjectOutput: QingStorOutput { }


public class UploadMultipartInput: QingStorInput {
    // Object multipart upload part number
    public var partNumber: Int = 0 // Required
    // Object multipart upload ID
    public var uploadID: String! // Required
    // Object multipart content length
    public var contentLength: Int? = nil
    // Object multipart content MD5sum
    public var contentMD5: String? = nil
    // Encryption algorithm of the object
    public var xQSEncryptionCustomerAlgorithm: String? = nil
    // Encryption key of the object
    public var xQSEncryptionCustomerKey: String? = nil
    // MD5sum of encryption key
    public var xQSEncryptionCustomerKeyMD5: String? = nil
    // The request body
    public var bodyInputStream: InputStream?

    override var queryProperties: [String] {
        return ["part_number", "upload_id"]
    }

    override var headerProperties: [String] {
        return ["Content-Length", "Content-MD5", "X-QS-Encryption-Customer-Algorithm", "X-QS-Encryption-Customer-Key", "X-QS-Encryption-Customer-Key-MD5"]
    }

    override var bodyProperties: [String] {
        return ["body"]
    }

    public required init?(map: Map) {
        super.init(map: map)
    }

    public init(partNumber: Int = 0, uploadID: String, contentLength: Int? = nil, contentMD5: String? = nil, xQSEncryptionCustomerAlgorithm: String? = nil, xQSEncryptionCustomerKey: String? = nil, xQSEncryptionCustomerKeyMD5: String? = nil, bodyInputStream: InputStream? = nil) {
        super.init()

        self.partNumber = partNumber
        self.uploadID = uploadID
        self.contentLength = contentLength
        self.contentMD5 = contentMD5
        self.xQSEncryptionCustomerAlgorithm = xQSEncryptionCustomerAlgorithm
        self.xQSEncryptionCustomerKey = xQSEncryptionCustomerKey
        self.xQSEncryptionCustomerKeyMD5 = xQSEncryptionCustomerKeyMD5
        self.bodyInputStream = bodyInputStream
    }

    public override func mapping(map: Map) {
        super.mapping(map: map)

        partNumber <- map["part_number"]
        uploadID <- map["upload_id"]
        contentLength <- map["Content-Length"]
        contentMD5 <- map["Content-MD5"]
        xQSEncryptionCustomerAlgorithm <- map["X-QS-Encryption-Customer-Algorithm"]
        xQSEncryptionCustomerKey <- map["X-QS-Encryption-Customer-Key"]
        xQSEncryptionCustomerKeyMD5 <- map["X-QS-Encryption-Customer-Key-MD5"]
    }

    public override func toParameters() -> [String: Any] {
        var parameters = super.toParameters()
        parameters["body"] = self.bodyInputStream

        return parameters
    }

    public override func validate() -> Error? {
        if self.uploadID == nil {
            return APIError.parameterRequiredError(name: "uploadID", parentName: "UploadMultipartInput")
        }

        return nil
    }
}

public class UploadMultipartOutput: QingStorOutput { }

