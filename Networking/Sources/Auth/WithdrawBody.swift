//
//  WithdrawBody.swift
//  Networking
//
//  Created by 김재민 on 1/24/24.
//  Copyright © 2024 com.dduckdori. All rights reserved.
//

import Foundation

public struct WithdrawBody: Equatable, Encodable {
    public var invite_cd: String
    public var mem_id: String
    
    public init(invite_cd: String, mem_id: String) {
        self.invite_cd = invite_cd
        self.mem_id = mem_id
    }
    
    func toParam() -> [String: Any] {
        guard let jsonData = try? JSONEncoder().encode(self),
              let param = try? JSONSerialization.jsonObject(with: jsonData) as? [String: Any]
        else { return [:] }
        
        return param
    }

}
