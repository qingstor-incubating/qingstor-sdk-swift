//
// QingStorTypesObjcBridge.swift
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

extension ACLModel {
    /// Create empty `ACLModel` instance.
    ///
    /// - returns: The new `ACLModel` instance.
    @objc public static func empty() -> ACLModel {
        return ACLModel(grantee: GranteeModel.empty(), permission: "")
    }
}

extension BucketModel {
    /// Create empty `BucketModel` instance.
    ///
    /// - returns: The new `BucketModel` instance.
    @objc public static func empty() -> BucketModel {
        return BucketModel(created: nil, location: nil, name: nil, url: nil)
    }
}

extension ConditionModel {
    /// Create empty `ConditionModel` instance.
    ///
    /// - returns: The new `ConditionModel` instance.
    @objc public static func empty() -> ConditionModel {
        return ConditionModel(ipAddress: nil, isNull: nil, notIPAddress: nil, stringLike: nil, stringNotLike: nil)
    }
}

extension CORSRuleModel {
    /// Create empty `CORSRuleModel` instance.
    ///
    /// - returns: The new `CORSRuleModel` instance.
    @objc public static func empty() -> CORSRuleModel {
        return CORSRuleModel(allowedHeaders: nil, allowedMethods: [], allowedOrigin: "", exposeHeaders: nil, maxAgeSeconds: 0)
    }
}

extension GranteeModel {
    /// Create empty `GranteeModel` instance.
    ///
    /// - returns: The new `GranteeModel` instance.
    @objc public static func empty() -> GranteeModel {
        return GranteeModel(id: nil, name: nil, type: "")
    }
}

extension IPAddressModel {
    /// Create empty `IPAddressModel` instance.
    ///
    /// - returns: The new `IPAddressModel` instance.
    @objc public static func empty() -> IPAddressModel {
        return IPAddressModel(sourceIP: nil)
    }
}

extension IsNullModel {
    /// Create empty `IsNullModel` instance.
    ///
    /// - returns: The new `IsNullModel` instance.
    @objc public static func empty() -> IsNullModel {
        return IsNullModel(referer: false)
    }
}

extension KeyModel {
    /// Create empty `KeyModel` instance.
    ///
    /// - returns: The new `KeyModel` instance.
    @objc public static func empty() -> KeyModel {
        return KeyModel(created: nil, encrypted: false, etag: nil, key: nil, mimeType: nil, modified: 0, size: 0)
    }
}

extension KeyDeleteErrorModel {
    /// Create empty `KeyDeleteErrorModel` instance.
    ///
    /// - returns: The new `KeyDeleteErrorModel` instance.
    @objc public static func empty() -> KeyDeleteErrorModel {
        return KeyDeleteErrorModel(code: nil, key: nil, message: nil)
    }
}

extension NotIPAddressModel {
    /// Create empty `NotIPAddressModel` instance.
    ///
    /// - returns: The new `NotIPAddressModel` instance.
    @objc public static func empty() -> NotIPAddressModel {
        return NotIPAddressModel(sourceIP: nil)
    }
}

extension ObjectPartModel {
    /// Create empty `ObjectPartModel` instance.
    ///
    /// - returns: The new `ObjectPartModel` instance.
    @objc public static func empty() -> ObjectPartModel {
        return ObjectPartModel(created: nil, etag: nil, partNumber: 0, size: 0)
    }
}

extension OwnerModel {
    /// Create empty `OwnerModel` instance.
    ///
    /// - returns: The new `OwnerModel` instance.
    @objc public static func empty() -> OwnerModel {
        return OwnerModel(id: nil, name: nil)
    }
}

extension StatementModel {
    /// Create empty `StatementModel` instance.
    ///
    /// - returns: The new `StatementModel` instance.
    @objc public static func empty() -> StatementModel {
        return StatementModel(action: [], condition: nil, effect: "", id: "", resource: nil, user: [])
    }
}

extension StringLikeModel {
    /// Create empty `StringLikeModel` instance.
    ///
    /// - returns: The new `StringLikeModel` instance.
    @objc public static func empty() -> StringLikeModel {
        return StringLikeModel(referer: nil)
    }
}

extension StringNotLikeModel {
    /// Create empty `StringNotLikeModel` instance.
    ///
    /// - returns: The new `StringNotLikeModel` instance.
    @objc public static func empty() -> StringNotLikeModel {
        return StringNotLikeModel(referer: nil)
    }
}

extension UploadsModel {
    /// Create empty `UploadsModel` instance.
    ///
    /// - returns: The new `UploadsModel` instance.
    @objc public static func empty() -> UploadsModel {
        return UploadsModel(created: nil, key: nil, uploadID: nil)
    }
}
