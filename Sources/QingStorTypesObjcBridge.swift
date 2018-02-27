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
    @objc public static func empty() -> ACLModel {
        return ACLModel(grantee: GranteeModel.empty(), permission: "")
    }
}

extension BucketModel {
    @objc public static func empty() -> BucketModel {
        return BucketModel(created: nil, location: nil, name: nil, url: nil)
    }
}

extension ConditionModel {
    @objc public static func empty() -> ConditionModel {
        return ConditionModel(ipAddress: nil, isNull: nil, notIPAddress: nil, stringLike: nil, stringNotLike: nil)
    }
}

extension CORSRuleModel {
    @objc public static func empty() -> CORSRuleModel {
        return CORSRuleModel(allowedHeaders: nil, allowedMethods: [], allowedOrigin: "", exposeHeaders: nil, maxAgeSeconds: 0)
    }
}

extension GranteeModel {
    @objc public static func empty() -> GranteeModel {
        return GranteeModel(id: nil, name: nil, type: "")
    }
}

extension IPAddressModel {
    @objc public static func empty() -> IPAddressModel {
        return IPAddressModel(sourceIP: nil)
    }
}

extension IsNullModel {
    @objc public static func empty() -> IsNullModel {
        return IsNullModel(referer: false)
    }
}

extension KeyModel {
    @objc public static func empty() -> KeyModel {
        return KeyModel(created: nil, encrypted: false, etag: nil, key: nil, mimeType: nil, modified: 0, size: 0)
    }
}

extension KeyDeleteErrorModel {
    @objc public static func empty() -> KeyDeleteErrorModel {
        return KeyDeleteErrorModel(code: nil, key: nil, message: nil)
    }
}

extension NotIPAddressModel {
    @objc public static func empty() -> NotIPAddressModel {
        return NotIPAddressModel(sourceIP: nil)
    }
}

extension ObjectPartModel {
    @objc public static func empty() -> ObjectPartModel {
        return ObjectPartModel(created: nil, etag: nil, partNumber: 0, size: 0)
    }
}

extension OwnerModel {
    @objc public static func empty() -> OwnerModel {
        return OwnerModel(id: nil, name: nil)
    }
}

extension StatementModel {
    @objc public static func empty() -> StatementModel {
        return StatementModel(action: [], condition: nil, effect: "", id: "", resource: nil, user: [])
    }
}

extension StringLikeModel {
    @objc public static func empty() -> StringLikeModel {
        return StringLikeModel(referer: nil)
    }
}

extension StringNotLikeModel {
    @objc public static func empty() -> StringNotLikeModel {
        return StringNotLikeModel(referer: nil)
    }
}

extension UploadsModel {
    @objc public static func empty() -> UploadsModel {
        return UploadsModel(created: nil, key: nil, uploadID: nil)
    }
}
