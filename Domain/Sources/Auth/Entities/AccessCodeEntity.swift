//
//  AccessCodeEntity.swift
//  Domain
//
//  Created by Jimmy on 2023/10/30.
//  Copyright © 2023 com.dduckdori. All rights reserved.
//

import Foundation
import SwiftyJSON

public struct AccessCodeEntity {
    public var status: String
    public var accessToken: String

    public init(_ json: JSON) {
        self.status = json["status"].stringValue
        self.accessToken = json["data"]["token"].stringValue
    }
}
