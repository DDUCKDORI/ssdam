//
//  FamilyJoinBody.swift
//  Networking
//
//  Created by 김재민 on 1/19/24.
//  Copyright © 2024 com.dduckdori. All rights reserved.
//

import Foundation

public struct FamilyJoinBody: Encodable, Equatable {
    public var newCode: String
    public var oldCode: String
    public var memId: Int
    
    public init(newCode: String, oldCode: String, memId: Int) {
        self.newCode = newCode
        self.oldCode = oldCode
        self.memId = memId
    }
    
    func toParam() -> [String: Any] {
        guard let jsonData = try? JSONEncoder().encode(self),
              let param = try? JSONSerialization.jsonObject(with: jsonData) as? [String: Any]
        else { return [:] }
        
        return param
    }
}
