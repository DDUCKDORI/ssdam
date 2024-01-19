//
//  FamilyJoinPayload.swift
//  Ssdam
//
//  Created by 김재민 on 1/19/24.
//  Copyright © 2024 com.dduckdori. All rights reserved.
//

import Foundation
import Domain

struct FamilyJoinPayload: Equatable, Hashable {
    public var result : String
    public var memId : Int
    
    init(result: String = "", memId: Int = -1) {
        self.result = result
        self.memId = memId
    }
    
    init(_ entity: FamilyJoinEntity) {
        self.result = entity.result
        self.memId = entity.memId
    }
}
