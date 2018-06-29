//
// QingStorTypes.swift
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

/// The AbortIncompleteMultipartUploadModel.
@objc(QSAbortIncompleteMultipartUploadModel)
public class AbortIncompleteMultipartUploadModel: BaseModel {
    /// days after initiation
    @objc public var daysAfterInitiation: Int = 0 // Required

    /// Initialize `AbortIncompleteMultipartUploadModel` with the specified `map`.
    public required init?(map: Map) {
        super.init(map: map)
    }

    /// Initialize `AbortIncompleteMultipartUploadModel` with the specified parameters.
    @objc public init(daysAfterInitiation: Int = 0) {
        super.init()
        
        self.daysAfterInitiation = daysAfterInitiation
    }

    /// Mapping process.
    public override func mapping(map: Map) {
        super.mapping(map: map)
        
        daysAfterInitiation <- map["days_after_initiation"]
    }

    /// Verify model data is valid.
    @objc public override func validate() -> Error? {
        return nil
    }
}


/// The ACLModel.
@objc(QSACLModel)
public class ACLModel: BaseModel {
    @objc public var grantee: GranteeModel! // Required
    /// Permission for this grantee
    /// permission's available values: READ, WRITE, FULL_CONTROL
    @objc public var permission: String! // Required

    /// Initialize `ACLModel` with the specified `map`.
    public required init?(map: Map) {
        super.init(map: map)
    }

    /// Initialize `ACLModel` with the specified parameters.
    @objc public init(grantee: GranteeModel, permission: String) {
        super.init()
        
        self.grantee = grantee
        self.permission = permission
    }

    /// Mapping process.
    public override func mapping(map: Map) {
        super.mapping(map: map)
        
        grantee <- map["grantee"]
        permission <- map["permission"]
    }

    /// Verify model data is valid.
    @objc public override func validate() -> Error? {
        if self.grantee == nil {
            return APIError.parameterRequiredError(name: "grantee", parentName: "ACL")
        }
        
        if let grantee = self.grantee {
            if let error = grantee.validate() {
                return error
            }
        }
        
        if self.permission == nil {
            return APIError.parameterRequiredError(name: "permission", parentName: "ACL")
        }
        
        if let permission = self.permission {
            let permissionValidValues: [String] = ["READ", "WRITE", "FULL_CONTROL"]
            let permissionParameterValue = "\(permission)"
            var permissionIsValid = false
            for value in permissionValidValues {
                if value == permissionParameterValue {
                    permissionIsValid = true
                    break
                }
            }
            if !permissionIsValid {
                return APIError.parameterValueNotAllowedError(name: "permission", value: permissionParameterValue, allowedValues: permissionValidValues)
            }
        }
                
        return nil
    }
}


/// The BucketModel.
@objc(QSBucketModel)
public class BucketModel: BaseModel {
    /// Created time of the bucket
    @objc public var created: Date? = nil
    /// QingCloud Zone ID
    @objc public var location: String? = nil
    /// Bucket name
    @objc public var name: String? = nil
    /// URL to access the bucket
    @objc public var url: String? = nil

    /// Initialize `BucketModel` with the specified `map`.
    public required init?(map: Map) {
        super.init(map: map)
    }

    /// Initialize `BucketModel` with the specified parameters.
    @objc public init(created: Date? = nil, location: String? = nil, name: String? = nil, url: String? = nil) {
        super.init()
        
        self.created = created
        self.location = location
        self.name = name
        self.url = url
    }

    /// Mapping process.
    public override func mapping(map: Map) {
        super.mapping(map: map)
        
        created <- (map["created"], ISO8601DateTransform())
        location <- map["location"]
        name <- map["name"]
        url <- map["url"]
    }

    /// Verify model data is valid.
    @objc public override func validate() -> Error? {
        return nil
    }
}


/// The CloudfuncArgsModel.
@objc(QSCloudfuncArgsModel)
public class CloudfuncArgsModel: BaseModel {
    @objc public var action: String! // Required
    @objc public var keyPrefix: String = "gen"
    @objc public var keySeprate: String = "_"
    @objc public var saveBucket: String? = nil

    /// Initialize `CloudfuncArgsModel` with the specified `map`.
    public required init?(map: Map) {
        super.init(map: map)
    }

    /// Initialize `CloudfuncArgsModel` with the specified parameters.
    @objc public init(action: String, keyPrefix: String = "gen", keySeprate: String = "_", saveBucket: String? = nil) {
        super.init()
        
        self.action = action
        self.keyPrefix = keyPrefix
        self.keySeprate = keySeprate
        self.saveBucket = saveBucket
    }

    /// Mapping process.
    public override func mapping(map: Map) {
        super.mapping(map: map)
        
        action <- map["action"]
        keyPrefix <- map["key_prefix"]
        keySeprate <- map["key_seprate"]
        saveBucket <- map["save_bucket"]
    }

    /// Verify model data is valid.
    @objc public override func validate() -> Error? {
        if self.action == nil {
            return APIError.parameterRequiredError(name: "action", parentName: "CloudfuncArgs")
        }
        
        return nil
    }
}


/// The ConditionModel.
@objc(QSConditionModel)
public class ConditionModel: BaseModel {
    @objc public var ipAddress: IPAddressModel? = nil
    @objc public var isNull: IsNullModel? = nil
    @objc public var notIPAddress: NotIPAddressModel? = nil
    @objc public var stringLike: StringLikeModel? = nil
    @objc public var stringNotLike: StringNotLikeModel? = nil

    /// Initialize `ConditionModel` with the specified `map`.
    public required init?(map: Map) {
        super.init(map: map)
    }

    /// Initialize `ConditionModel` with the specified parameters.
    @objc public init(ipAddress: IPAddressModel? = nil, isNull: IsNullModel? = nil, notIPAddress: NotIPAddressModel? = nil, stringLike: StringLikeModel? = nil, stringNotLike: StringNotLikeModel? = nil) {
        super.init()
        
        self.ipAddress = ipAddress
        self.isNull = isNull
        self.notIPAddress = notIPAddress
        self.stringLike = stringLike
        self.stringNotLike = stringNotLike
    }

    /// Mapping process.
    public override func mapping(map: Map) {
        super.mapping(map: map)
        
        ipAddress <- map["ip_address"]
        isNull <- map["is_null"]
        notIPAddress <- map["not_ip_address"]
        stringLike <- map["string_like"]
        stringNotLike <- map["string_not_like"]
    }

    /// Verify model data is valid.
    @objc public override func validate() -> Error? {
        if let ipAddress = self.ipAddress {
            if let error = ipAddress.validate() {
                return error
            }
        }
        
        if let isNull = self.isNull {
            if let error = isNull.validate() {
                return error
            }
        }
        
        if let notIPAddress = self.notIPAddress {
            if let error = notIPAddress.validate() {
                return error
            }
        }
        
        if let stringLike = self.stringLike {
            if let error = stringLike.validate() {
                return error
            }
        }
        
        if let stringNotLike = self.stringNotLike {
            if let error = stringNotLike.validate() {
                return error
            }
        }
        
        return nil
    }
}


/// The CORSRuleModel.
@objc(QSCORSRuleModel)
public class CORSRuleModel: BaseModel {
    /// Allowed headers
    @objc public var allowedHeaders: [String]? = nil
    /// Allowed methods
    @objc public var allowedMethods: [String]! // Required
    /// Allowed origin
    @objc public var allowedOrigin: String! // Required
    /// Expose headers
    @objc public var exposeHeaders: [String]? = nil
    /// Max age seconds
    @objc public var maxAgeSeconds: Int = 0

    /// Initialize `CORSRuleModel` with the specified `map`.
    public required init?(map: Map) {
        super.init(map: map)
    }

    /// Initialize `CORSRuleModel` with the specified parameters.
    @objc public init(allowedHeaders: [String]? = nil, allowedMethods: [String], allowedOrigin: String, exposeHeaders: [String]? = nil, maxAgeSeconds: Int = 0) {
        super.init()
        
        self.allowedHeaders = allowedHeaders
        self.allowedMethods = allowedMethods
        self.allowedOrigin = allowedOrigin
        self.exposeHeaders = exposeHeaders
        self.maxAgeSeconds = maxAgeSeconds
    }

    /// Mapping process.
    public override func mapping(map: Map) {
        super.mapping(map: map)
        
        allowedHeaders <- map["allowed_headers"]
        allowedMethods <- map["allowed_methods"]
        allowedOrigin <- map["allowed_origin"]
        exposeHeaders <- map["expose_headers"]
        maxAgeSeconds <- map["max_age_seconds"]
    }

    /// Verify model data is valid.
    @objc public override func validate() -> Error? {
        if self.allowedMethods == nil {
            return APIError.parameterRequiredError(name: "allowedMethods", parentName: "CORSRule")
        }
        
        if self.allowedMethods.count == 0 {
            return APIError.parameterRequiredError(name: "allowedMethods", parentName: "CORSRule")
        }
            
        if self.allowedOrigin == nil {
            return APIError.parameterRequiredError(name: "allowedOrigin", parentName: "CORSRule")
        }
        
        return nil
    }
}


/// The ExpirationModel.
@objc(QSExpirationModel)
public class ExpirationModel: BaseModel {
    /// days
    @objc public var days: Int = 0

    /// Initialize `ExpirationModel` with the specified `map`.
    public required init?(map: Map) {
        super.init(map: map)
    }

    /// Initialize `ExpirationModel` with the specified parameters.
    @objc public init(days: Int = 0) {
        super.init()
        
        self.days = days
    }

    /// Mapping process.
    public override func mapping(map: Map) {
        super.mapping(map: map)
        
        days <- map["days"]
    }

    /// Verify model data is valid.
    @objc public override func validate() -> Error? {
        return nil
    }
}


/// The FilterModel.
@objc(QSFilterModel)
public class FilterModel: BaseModel {
    /// Prefix matching
    @objc public var prefix: String! // Required

    /// Initialize `FilterModel` with the specified `map`.
    public required init?(map: Map) {
        super.init(map: map)
    }

    /// Initialize `FilterModel` with the specified parameters.
    @objc public init(prefix: String) {
        super.init()
        
        self.prefix = prefix
    }

    /// Mapping process.
    public override func mapping(map: Map) {
        super.mapping(map: map)
        
        prefix <- map["prefix"]
    }

    /// Verify model data is valid.
    @objc public override func validate() -> Error? {
        if self.prefix == nil {
            return APIError.parameterRequiredError(name: "prefix", parentName: "Filter")
        }
        
        return nil
    }
}


/// The GranteeModel.
@objc(QSGranteeModel)
public class GranteeModel: BaseModel {
    /// Grantee user ID
    @objc public var id: String? = nil
    /// Grantee group name
    @objc public var name: String? = nil
    /// Grantee type
    /// type's available values: user, group
    @objc public var type: String! // Required

    /// Initialize `GranteeModel` with the specified `map`.
    public required init?(map: Map) {
        super.init(map: map)
    }

    /// Initialize `GranteeModel` with the specified parameters.
    @objc public init(id: String? = nil, name: String? = nil, type: String) {
        super.init()
        
        self.id = id
        self.name = name
        self.type = type
    }

    /// Mapping process.
    public override func mapping(map: Map) {
        super.mapping(map: map)
        
        id <- map["id"]
        name <- map["name"]
        type <- map["type"]
    }

    /// Verify model data is valid.
    @objc public override func validate() -> Error? {
        if self.type == nil {
            return APIError.parameterRequiredError(name: "type", parentName: "Grantee")
        }
        
        if let type = self.type {
            let typeValidValues: [String] = ["user", "group"]
            let typeParameterValue = "\(type)"
            var typeIsValid = false
            for value in typeValidValues {
                if value == typeParameterValue {
                    typeIsValid = true
                    break
                }
            }
            if !typeIsValid {
                return APIError.parameterValueNotAllowedError(name: "type", value: typeParameterValue, allowedValues: typeValidValues)
            }
        }
                
        return nil
    }
}


/// The IPAddressModel.
@objc(QSIPAddressModel)
public class IPAddressModel: BaseModel {
    /// Source IP
    @objc public var sourceIP: [String]? = nil

    /// Initialize `IPAddressModel` with the specified `map`.
    public required init?(map: Map) {
        super.init(map: map)
    }

    /// Initialize `IPAddressModel` with the specified parameters.
    @objc public init(sourceIP: [String]? = nil) {
        super.init()
        
        self.sourceIP = sourceIP
    }

    /// Mapping process.
    public override func mapping(map: Map) {
        super.mapping(map: map)
        
        sourceIP <- map["source_ip"]
    }

    /// Verify model data is valid.
    @objc public override func validate() -> Error? {
        return nil
    }
}


/// The IsNullModel.
@objc(QSIsNullModel)
public class IsNullModel: BaseModel {
    /// Refer url
    @objc public var referer: Bool = false

    /// Initialize `IsNullModel` with the specified `map`.
    public required init?(map: Map) {
        super.init(map: map)
    }

    /// Initialize `IsNullModel` with the specified parameters.
    @objc public init(referer: Bool = false) {
        super.init()
        
        self.referer = referer
    }

    /// Mapping process.
    public override func mapping(map: Map) {
        super.mapping(map: map)
        
        referer <- map["Referer"]
    }

    /// Verify model data is valid.
    @objc public override func validate() -> Error? {
        return nil
    }
}


/// The KeyModel.
@objc(QSKeyModel)
public class KeyModel: BaseModel {
    /// Object created time
    @objc public var created: Date? = nil
    /// Whether this key is encrypted
    @objc public var encrypted: Bool = false
    /// MD5sum of the object
    @objc public var etag: String? = nil
    /// Object key
    @objc public var key: String? = nil
    /// MIME type of the object
    @objc public var mimeType: String? = nil
    /// Last modified time in unix time format
    @objc public var modified: Int = 0
    /// Object content size
    @objc public var size: Int = 0

    /// Initialize `KeyModel` with the specified `map`.
    public required init?(map: Map) {
        super.init(map: map)
    }

    /// Initialize `KeyModel` with the specified parameters.
    @objc public init(created: Date? = nil, encrypted: Bool = false, etag: String? = nil, key: String? = nil, mimeType: String? = nil, modified: Int = 0, size: Int = 0) {
        super.init()
        
        self.created = created
        self.encrypted = encrypted
        self.etag = etag
        self.key = key
        self.mimeType = mimeType
        self.modified = modified
        self.size = size
    }

    /// Mapping process.
    public override func mapping(map: Map) {
        super.mapping(map: map)
        
        created <- (map["created"], ISO8601DateTransform())
        encrypted <- map["encrypted"]
        etag <- map["etag"]
        key <- map["key"]
        mimeType <- map["mime_type"]
        modified <- map["modified"]
        size <- map["size"]
    }

    /// Verify model data is valid.
    @objc public override func validate() -> Error? {
        return nil
    }
}


/// The KeyDeleteErrorModel.
@objc(QSKeyDeleteErrorModel)
public class KeyDeleteErrorModel: BaseModel {
    /// Error code
    @objc public var code: String? = nil
    /// Object key
    @objc public var key: String? = nil
    /// Error message
    @objc public var message: String? = nil

    /// Initialize `KeyDeleteErrorModel` with the specified `map`.
    public required init?(map: Map) {
        super.init(map: map)
    }

    /// Initialize `KeyDeleteErrorModel` with the specified parameters.
    @objc public init(code: String? = nil, key: String? = nil, message: String? = nil) {
        super.init()
        
        self.code = code
        self.key = key
        self.message = message
    }

    /// Mapping process.
    public override func mapping(map: Map) {
        super.mapping(map: map)
        
        code <- map["code"]
        key <- map["key"]
        message <- map["message"]
    }

    /// Verify model data is valid.
    @objc public override func validate() -> Error? {
        return nil
    }
}


/// The NotIPAddressModel.
@objc(QSNotIPAddressModel)
public class NotIPAddressModel: BaseModel {
    /// Source IP
    @objc public var sourceIP: [String]? = nil

    /// Initialize `NotIPAddressModel` with the specified `map`.
    public required init?(map: Map) {
        super.init(map: map)
    }

    /// Initialize `NotIPAddressModel` with the specified parameters.
    @objc public init(sourceIP: [String]? = nil) {
        super.init()
        
        self.sourceIP = sourceIP
    }

    /// Mapping process.
    public override func mapping(map: Map) {
        super.mapping(map: map)
        
        sourceIP <- map["source_ip"]
    }

    /// Verify model data is valid.
    @objc public override func validate() -> Error? {
        return nil
    }
}


/// The NotificationsModel.
@objc(QSNotificationsModel)
public class NotificationsModel: BaseModel {
    /// Event processing service
    /// cloudfunc's available values: create_object, delete_object, abort_multipart
    @objc public var cloudfunc: String! // Required
    @objc public var cloudfuncArgs: CloudfuncArgsModel? = nil
    /// event types
    @objc public var eventTypes: [String]! // Required
    /// notification id
    @objc public var id: String! // Required
    /// notify url
    @objc public var notifyURL: String? = nil
    /// Object name matching rule
    @objc public var objectFilters: String? = nil

    /// Initialize `NotificationsModel` with the specified `map`.
    public required init?(map: Map) {
        super.init(map: map)
    }

    /// Initialize `NotificationsModel` with the specified parameters.
    @objc public init(cloudfunc: String, cloudfuncArgs: CloudfuncArgsModel? = nil, eventTypes: [String], id: String, notifyURL: String? = nil, objectFilters: String? = nil) {
        super.init()
        
        self.cloudfunc = cloudfunc
        self.cloudfuncArgs = cloudfuncArgs
        self.eventTypes = eventTypes
        self.id = id
        self.notifyURL = notifyURL
        self.objectFilters = objectFilters
    }

    /// Mapping process.
    public override func mapping(map: Map) {
        super.mapping(map: map)
        
        cloudfunc <- map["cloudfunc"]
        cloudfuncArgs <- map["cloudfunc_args"]
        eventTypes <- map["event_types"]
        id <- map["id"]
        notifyURL <- map["notify_url"]
        objectFilters <- map["object_filters"]
    }

    /// Verify model data is valid.
    @objc public override func validate() -> Error? {
        if self.cloudfunc == nil {
            return APIError.parameterRequiredError(name: "cloudfunc", parentName: "Notifications")
        }
        
        if let cloudfunc = self.cloudfunc {
            let cloudfuncValidValues: [String] = ["create_object", "delete_object", "abort_multipart"]
            let cloudfuncParameterValue = "\(cloudfunc)"
            var cloudfuncIsValid = false
            for value in cloudfuncValidValues {
                if value == cloudfuncParameterValue {
                    cloudfuncIsValid = true
                    break
                }
            }
            if !cloudfuncIsValid {
                return APIError.parameterValueNotAllowedError(name: "cloudfunc", value: cloudfuncParameterValue, allowedValues: cloudfuncValidValues)
            }
        }
                
        if let cloudfuncArgs = self.cloudfuncArgs {
            if let error = cloudfuncArgs.validate() {
                return error
            }
        }
        
        if self.eventTypes == nil {
            return APIError.parameterRequiredError(name: "eventTypes", parentName: "Notifications")
        }
        
        if self.eventTypes.count == 0 {
            return APIError.parameterRequiredError(name: "eventTypes", parentName: "Notifications")
        }
            
        if self.id == nil {
            return APIError.parameterRequiredError(name: "id", parentName: "Notifications")
        }
        
        return nil
    }
}


/// The ObjectPartModel.
@objc(QSObjectPartModel)
public class ObjectPartModel: BaseModel {
    /// Object part created time
    @objc public var created: Date? = nil
    /// MD5sum of the object part
    @objc public var etag: String? = nil
    /// Object part number
    @objc public var partNumber: Int = 0 // Required
    /// Object part size
    @objc public var size: Int = 0

    /// Initialize `ObjectPartModel` with the specified `map`.
    public required init?(map: Map) {
        super.init(map: map)
    }

    /// Initialize `ObjectPartModel` with the specified parameters.
    @objc public init(created: Date? = nil, etag: String? = nil, partNumber: Int = 0, size: Int = 0) {
        super.init()
        
        self.created = created
        self.etag = etag
        self.partNumber = partNumber
        self.size = size
    }

    /// Mapping process.
    public override func mapping(map: Map) {
        super.mapping(map: map)
        
        created <- (map["created"], ISO8601DateTransform())
        etag <- map["etag"]
        partNumber <- map["part_number"]
        size <- map["size"]
    }

    /// Verify model data is valid.
    @objc public override func validate() -> Error? {
        return nil
    }
}


/// The OwnerModel.
@objc(QSOwnerModel)
public class OwnerModel: BaseModel {
    /// User ID
    @objc public var id: String? = nil
    /// Username
    @objc public var name: String? = nil

    /// Initialize `OwnerModel` with the specified `map`.
    public required init?(map: Map) {
        super.init(map: map)
    }

    /// Initialize `OwnerModel` with the specified parameters.
    @objc public init(id: String? = nil, name: String? = nil) {
        super.init()
        
        self.id = id
        self.name = name
    }

    /// Mapping process.
    public override func mapping(map: Map) {
        super.mapping(map: map)
        
        id <- map["id"]
        name <- map["name"]
    }

    /// Verify model data is valid.
    @objc public override func validate() -> Error? {
        return nil
    }
}


/// The RuleModel.
@objc(QSRuleModel)
public class RuleModel: BaseModel {
    @objc public var abortIncompleteMultipartUpload: AbortIncompleteMultipartUploadModel? = nil
    @objc public var expiration: ExpirationModel? = nil
    @objc public var filter: FilterModel! // Required
    /// rule id
    @objc public var id: String! // Required
    /// rule status
    /// status's available values: enabled, disabled
    @objc public var status: String! // Required
    @objc public var transition: TransitionModel? = nil

    /// Initialize `RuleModel` with the specified `map`.
    public required init?(map: Map) {
        super.init(map: map)
    }

    /// Initialize `RuleModel` with the specified parameters.
    @objc public init(abortIncompleteMultipartUpload: AbortIncompleteMultipartUploadModel? = nil, expiration: ExpirationModel? = nil, filter: FilterModel, id: String, status: String, transition: TransitionModel? = nil) {
        super.init()
        
        self.abortIncompleteMultipartUpload = abortIncompleteMultipartUpload
        self.expiration = expiration
        self.filter = filter
        self.id = id
        self.status = status
        self.transition = transition
    }

    /// Mapping process.
    public override func mapping(map: Map) {
        super.mapping(map: map)
        
        abortIncompleteMultipartUpload <- map["abort_incomplete_multipart_upload"]
        expiration <- map["expiration"]
        filter <- map["filter"]
        id <- map["id"]
        status <- map["status"]
        transition <- map["transition"]
    }

    /// Verify model data is valid.
    @objc public override func validate() -> Error? {
        if let abortIncompleteMultipartUpload = self.abortIncompleteMultipartUpload {
            if let error = abortIncompleteMultipartUpload.validate() {
                return error
            }
        }
        
        if let expiration = self.expiration {
            if let error = expiration.validate() {
                return error
            }
        }
        
        if self.filter == nil {
            return APIError.parameterRequiredError(name: "filter", parentName: "Rule")
        }
        
        if let filter = self.filter {
            if let error = filter.validate() {
                return error
            }
        }
        
        if self.id == nil {
            return APIError.parameterRequiredError(name: "id", parentName: "Rule")
        }
        
        if self.status == nil {
            return APIError.parameterRequiredError(name: "status", parentName: "Rule")
        }
        
        if let status = self.status {
            let statusValidValues: [String] = ["enabled", "disabled"]
            let statusParameterValue = "\(status)"
            var statusIsValid = false
            for value in statusValidValues {
                if value == statusParameterValue {
                    statusIsValid = true
                    break
                }
            }
            if !statusIsValid {
                return APIError.parameterValueNotAllowedError(name: "status", value: statusParameterValue, allowedValues: statusValidValues)
            }
        }
                
        if let transition = self.transition {
            if let error = transition.validate() {
                return error
            }
        }
        
        return nil
    }
}


/// The StatementModel.
@objc(QSStatementModel)
public class StatementModel: BaseModel {
    /// QingStor API methods
    @objc public var action: [String]! // Required
    @objc public var condition: ConditionModel? = nil
    /// Statement effect
    /// effect's available values: allow, deny
    @objc public var effect: String! // Required
    /// Bucket policy id, must be unique
    @objc public var id: String! // Required
    /// The resources to apply bucket policy
    @objc public var resource: [String]? = nil
    /// The user to apply bucket policy
    @objc public var user: [String]! // Required

    /// Initialize `StatementModel` with the specified `map`.
    public required init?(map: Map) {
        super.init(map: map)
    }

    /// Initialize `StatementModel` with the specified parameters.
    @objc public init(action: [String], condition: ConditionModel? = nil, effect: String, id: String, resource: [String]? = nil, user: [String]) {
        super.init()
        
        self.action = action
        self.condition = condition
        self.effect = effect
        self.id = id
        self.resource = resource
        self.user = user
    }

    /// Mapping process.
    public override func mapping(map: Map) {
        super.mapping(map: map)
        
        action <- map["action"]
        condition <- map["condition"]
        effect <- map["effect"]
        id <- map["id"]
        resource <- map["resource"]
        user <- map["user"]
    }

    /// Verify model data is valid.
    @objc public override func validate() -> Error? {
        if self.action == nil {
            return APIError.parameterRequiredError(name: "action", parentName: "Statement")
        }
        
        if self.action.count == 0 {
            return APIError.parameterRequiredError(name: "action", parentName: "Statement")
        }
            
        if let condition = self.condition {
            if let error = condition.validate() {
                return error
            }
        }
        
        if self.effect == nil {
            return APIError.parameterRequiredError(name: "effect", parentName: "Statement")
        }
        
        if let effect = self.effect {
            let effectValidValues: [String] = ["allow", "deny"]
            let effectParameterValue = "\(effect)"
            var effectIsValid = false
            for value in effectValidValues {
                if value == effectParameterValue {
                    effectIsValid = true
                    break
                }
            }
            if !effectIsValid {
                return APIError.parameterValueNotAllowedError(name: "effect", value: effectParameterValue, allowedValues: effectValidValues)
            }
        }
                
        if self.id == nil {
            return APIError.parameterRequiredError(name: "id", parentName: "Statement")
        }
        
        if self.user == nil {
            return APIError.parameterRequiredError(name: "user", parentName: "Statement")
        }
        
        if self.user.count == 0 {
            return APIError.parameterRequiredError(name: "user", parentName: "Statement")
        }
            
        return nil
    }
}


/// The StringLikeModel.
@objc(QSStringLikeModel)
public class StringLikeModel: BaseModel {
    /// Refer url
    @objc public var referer: [String]? = nil

    /// Initialize `StringLikeModel` with the specified `map`.
    public required init?(map: Map) {
        super.init(map: map)
    }

    /// Initialize `StringLikeModel` with the specified parameters.
    @objc public init(referer: [String]? = nil) {
        super.init()
        
        self.referer = referer
    }

    /// Mapping process.
    public override func mapping(map: Map) {
        super.mapping(map: map)
        
        referer <- map["Referer"]
    }

    /// Verify model data is valid.
    @objc public override func validate() -> Error? {
        return nil
    }
}


/// The StringNotLikeModel.
@objc(QSStringNotLikeModel)
public class StringNotLikeModel: BaseModel {
    /// Refer url
    @objc public var referer: [String]? = nil

    /// Initialize `StringNotLikeModel` with the specified `map`.
    public required init?(map: Map) {
        super.init(map: map)
    }

    /// Initialize `StringNotLikeModel` with the specified parameters.
    @objc public init(referer: [String]? = nil) {
        super.init()
        
        self.referer = referer
    }

    /// Mapping process.
    public override func mapping(map: Map) {
        super.mapping(map: map)
        
        referer <- map["Referer"]
    }

    /// Verify model data is valid.
    @objc public override func validate() -> Error? {
        return nil
    }
}


/// The TransitionModel.
@objc(QSTransitionModel)
public class TransitionModel: BaseModel {
    /// days
    @objc public var days: Int = 0
    /// storage class
    @objc public var storageClass: Int = 0 // Required

    /// Initialize `TransitionModel` with the specified `map`.
    public required init?(map: Map) {
        super.init(map: map)
    }

    /// Initialize `TransitionModel` with the specified parameters.
    @objc public init(days: Int = 0, storageClass: Int = 0) {
        super.init()
        
        self.days = days
        self.storageClass = storageClass
    }

    /// Mapping process.
    public override func mapping(map: Map) {
        super.mapping(map: map)
        
        days <- map["days"]
        storageClass <- map["storage_class"]
    }

    /// Verify model data is valid.
    @objc public override func validate() -> Error? {
        return nil
    }
}


/// The UploadsModel.
@objc(QSUploadsModel)
public class UploadsModel: BaseModel {
    /// Object part created time
    @objc public var created: Date? = nil
    /// Object key
    @objc public var key: String? = nil
    /// Object upload id
    @objc public var uploadID: String? = nil

    /// Initialize `UploadsModel` with the specified `map`.
    public required init?(map: Map) {
        super.init(map: map)
    }

    /// Initialize `UploadsModel` with the specified parameters.
    @objc public init(created: Date? = nil, key: String? = nil, uploadID: String? = nil) {
        super.init()
        
        self.created = created
        self.key = key
        self.uploadID = uploadID
    }

    /// Mapping process.
    public override func mapping(map: Map) {
        super.mapping(map: map)
        
        created <- (map["created"], ISO8601DateTransform())
        key <- map["key"]
        uploadID <- map["upload_id"]
    }

    /// Verify model data is valid.
    @objc public override func validate() -> Error? {
        return nil
    }
}
