//
//  NumberOfFamilyEntity.swift
//  Domain
//
//  Created by 김재민 on 1/14/24.
//  Copyright © 2024 com.dduckdori. All rights reserved.
//

import Foundation
import SwiftyJSON

public struct NumberOfFamilyEntity: Equatable {
    public var result: String
    public var count: String
    
    public init(_ json: JSON) {
        self.result = json["result"].stringValue
        self.count = json["family_num"].stringValue
    }
}
