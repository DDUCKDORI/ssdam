//
//  FamilyJoinEntity.swift
//  Domain
//
//  Created by 김재민 on 1/19/24.
//  Copyright © 2024 com.dduckdori. All rights reserved.
//

import Foundation
import SwiftyJSON

public struct FamilyJoinEntity: Equatable {
    public var result: String
    public var memId: Int
    
    public init(_ json: JSON) {
        self.result = json["result"].stringValue
        self.memId = json["memId"].intValue
    }
}
