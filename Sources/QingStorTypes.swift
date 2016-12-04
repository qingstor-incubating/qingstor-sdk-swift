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

public class ACLModel: BaseModel {
    public var grantee: GranteeModel! // Required
    // Permission for this grantee
    // permission's available values: READ, WRITE, FULL_CONTROL
    public var permission: String! // Required

    public required init?(map: Map) {
        super.init(map: map)
    }

    public init(grantee: GranteeModel, permission: String) {
        super.init()

        self.grantee = grantee
        self.permission = permission
    }

    public override func mapping(map: Map) {
        super.mapping(map: map)

        grantee <- map["grantee"]
        permission <- map["permission"]
    }

    public override func validate() -> Error? {
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


public class BucketModel: BaseModel {
    // Created time of the bucket
    public var created: Date? = nil
    // QingCloud Zone ID
    public var location: String? = nil
    // Bucket name
    public var name: String? = nil
    // URL to access the bucket
    public var url: String? = nil

    public required init?(map: Map) {
        super.init(map: map)
    }

    public init(created: Date? = nil, location: String? = nil, name: String? = nil, url: String? = nil) {
        super.init()

        self.created = created
        self.location = location
        self.name = name
        self.url = url
    }

    public override func mapping(map: Map) {
        super.mapping(map: map)

        created <- (map["created"], ISO8601DateTransform())
        location <- map["location"]
        name <- map["name"]
        url <- map["url"]
    }

    public override func validate() -> Error? {
        return nil
    }
}


public class ConditionModel: BaseModel {
    public var isNull: IsNullModel? = nil
    public var stringLike: StringLikeModel? = nil
    public var stringNotLike: StringNotLikeModel? = nil

    public required init?(map: Map) {
        super.init(map: map)
    }

    public init(isNull: IsNullModel? = nil, stringLike: StringLikeModel? = nil, stringNotLike: StringNotLikeModel? = nil) {
        super.init()

        self.isNull = isNull
        self.stringLike = stringLike
        self.stringNotLike = stringNotLike
    }

    public override func mapping(map: Map) {
        super.mapping(map: map)

        isNull <- map["is_null"]
        stringLike <- map["string_like"]
        stringNotLike <- map["string_not_like"]
    }

    public override func validate() -> Error? {
        if let isNull = self.isNull {
            if let error = isNull.validate() {
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


public class CORSRuleModel: BaseModel {
    // Allowed headers
    public var allowedHeaders: [String]? = nil
    // Allowed methods
    public var allowedMethods: [String]! // Required
    // Allowed origin
    public var allowedOrigin: String! // Required
    // Expose headers
    public var exposeHeaders: [String]? = nil
    // Max age seconds
    public var maxAgeSeconds: Int? = nil

    public required init?(map: Map) {
        super.init(map: map)
    }

    public init(allowedHeaders: [String]? = nil, allowedMethods: [String], allowedOrigin: String, exposeHeaders: [String]? = nil, maxAgeSeconds: Int? = nil) {
        super.init()

        self.allowedHeaders = allowedHeaders
        self.allowedMethods = allowedMethods
        self.allowedOrigin = allowedOrigin
        self.exposeHeaders = exposeHeaders
        self.maxAgeSeconds = maxAgeSeconds
    }

    public override func mapping(map: Map) {
        super.mapping(map: map)

        allowedHeaders <- map["allowed_headers"]
        allowedMethods <- map["allowed_methods"]
        allowedOrigin <- map["allowed_origin"]
        exposeHeaders <- map["expose_headers"]
        maxAgeSeconds <- map["max_age_seconds"]
    }

    public override func validate() -> Error? {
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


public class GranteeModel: BaseModel {
    // Grantee user ID
    public var id: String? = nil
    // Grantee group name
    public var name: String? = nil
    // Grantee type
    // type's available values: user, group
    public var type: String! // Required

    public required init?(map: Map) {
        super.init(map: map)
    }

    public init(id: String? = nil, name: String? = nil, type: String) {
        super.init()

        self.id = id
        self.name = name
        self.type = type
    }

    public override func mapping(map: Map) {
        super.mapping(map: map)

        id <- map["id"]
        name <- map["name"]
        type <- map["type"]
    }

    public override func validate() -> Error? {
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


public class IsNullModel: BaseModel {
    // Refer url
    public var referer: Bool? = nil

    public required init?(map: Map) {
        super.init(map: map)
    }

    public init(referer: Bool? = nil) {
        super.init()

        self.referer = referer
    }

    public override func mapping(map: Map) {
        super.mapping(map: map)

        referer <- map["Referer"]
    }

    public override func validate() -> Error? {
        return nil
    }
}


public class KeyModel: BaseModel {
    // Object created time
    public var created: Date? = nil
    // MD5sum of the object
    public var etag: String? = nil
    // Object key
    public var key: String? = nil
    // MIME type of the object
    public var mimeType: String? = nil
    // Last modified time in unix time format
    public var modified: Int? = nil
    // Object content size
    public var size: Int? = nil

    public required init?(map: Map) {
        super.init(map: map)
    }

    public init(created: Date? = nil, etag: String? = nil, key: String? = nil, mimeType: String? = nil, modified: Int? = nil, size: Int? = nil) {
        super.init()

        self.created = created
        self.etag = etag
        self.key = key
        self.mimeType = mimeType
        self.modified = modified
        self.size = size
    }

    public override func mapping(map: Map) {
        super.mapping(map: map)

        created <- (map["created"], ISO8601DateTransform())
        etag <- map["etag"]
        key <- map["key"]
        mimeType <- map["mime_type"]
        modified <- map["modified"]
        size <- map["size"]
    }

    public override func validate() -> Error? {
        return nil
    }
}


public class KeyDeleteErrorModel: BaseModel {
    // Error code
    public var code: String? = nil
    // Object key
    public var key: String? = nil
    // Error message
    public var message: String? = nil

    public required init?(map: Map) {
        super.init(map: map)
    }

    public init(code: String? = nil, key: String? = nil, message: String? = nil) {
        super.init()

        self.code = code
        self.key = key
        self.message = message
    }

    public override func mapping(map: Map) {
        super.mapping(map: map)

        code <- map["code"]
        key <- map["key"]
        message <- map["message"]
    }

    public override func validate() -> Error? {
        return nil
    }
}


public class ObjectPartModel: BaseModel {
    // Object part created time
    public var created: Date? = nil
    // MD5sum of the object part
    public var etag: String? = nil
    // Object part number
    public var partNumber: Int = 0 // Required
    // Object part size
    public var size: Int? = nil

    public required init?(map: Map) {
        super.init(map: map)
    }

    public init(created: Date? = nil, etag: String? = nil, partNumber: Int = 0, size: Int? = nil) {
        super.init()

        self.created = created
        self.etag = etag
        self.partNumber = partNumber
        self.size = size
    }

    public override func mapping(map: Map) {
        super.mapping(map: map)

        created <- (map["created"], ISO8601DateTransform())
        etag <- map["etag"]
        partNumber <- map["part_number"]
        size <- map["size"]
    }

    public override func validate() -> Error? {
        return nil
    }
}


public class OwnerModel: BaseModel {
    // User ID
    public var id: String? = nil
    // Username
    public var name: String? = nil

    public required init?(map: Map) {
        super.init(map: map)
    }

    public init(id: String? = nil, name: String? = nil) {
        super.init()

        self.id = id
        self.name = name
    }

    public override func mapping(map: Map) {
        super.mapping(map: map)

        id <- map["id"]
        name <- map["name"]
    }

    public override func validate() -> Error? {
        return nil
    }
}


public class StatementModel: BaseModel {
    // QingStor API methods
    public var action: [String]! // Required
    public var condition: ConditionModel? = nil
    // Statement effect
    // effect's available values: allow, deny
    public var effect: String! // Required
    // Bucket policy id, must be unique
    public var id: String! // Required
    // The resources to apply bucket policy
    public var resource: [String]! // Required
    // The user to apply bucket policy
    public var user: [String]! // Required

    public required init?(map: Map) {
        super.init(map: map)
    }

    public init(action: [String], condition: ConditionModel? = nil, effect: String, id: String, resource: [String], user: [String]) {
        super.init()

        self.action = action
        self.condition = condition
        self.effect = effect
        self.id = id
        self.resource = resource
        self.user = user
    }

    public override func mapping(map: Map) {
        super.mapping(map: map)

        action <- map["action"]
        condition <- map["condition"]
        effect <- map["effect"]
        id <- map["id"]
        resource <- map["resource"]
        user <- map["user"]
    }

    public override func validate() -> Error? {
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

        if self.resource == nil {
            return APIError.parameterRequiredError(name: "resource", parentName: "Statement")
        }

        if self.resource.count == 0 {
            return APIError.parameterRequiredError(name: "resource", parentName: "Statement")
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


public class StringLikeModel: BaseModel {
    // Refer url
    public var referer: [String]? = nil

    public required init?(map: Map) {
        super.init(map: map)
    }

    public init(referer: [String]? = nil) {
        super.init()

        self.referer = referer
    }

    public override func mapping(map: Map) {
        super.mapping(map: map)

        referer <- map["Referer"]
    }

    public override func validate() -> Error? {
        return nil
    }
}


public class StringNotLikeModel: BaseModel {
    // Refer url
    public var referer: [String]? = nil

    public required init?(map: Map) {
        super.init(map: map)
    }

    public init(referer: [String]? = nil) {
        super.init()

        self.referer = referer
    }

    public override func mapping(map: Map) {
        super.mapping(map: map)

        referer <- map["Referer"]
    }

    public override func validate() -> Error? {
        return nil
    }
}
