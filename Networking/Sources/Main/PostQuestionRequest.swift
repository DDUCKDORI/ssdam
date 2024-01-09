//
//  PostQuestionRequest.swift
//  Networking
//
//  Created by 김재민 on 1/8/24.
//  Copyright © 2024 com.dduckdori. All rights reserved.
//

import Foundation

public struct PostQuestionRequest: Encodable {
    public var cateId: Int
    public var qustId: Int
    public var memId: Int
    public var inviteCd: String
    public var ansCn: String
    
    func toParam() -> [String: Any] {
        guard let jsonData = try? JSONEncoder().encode(self),
              let param = try? JSONSerialization.jsonObject(with: jsonData) as? [String: Any]
        else { return [:] }
        return param
    }
}
