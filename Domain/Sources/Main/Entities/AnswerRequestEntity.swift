//
//  AnswerRequestEntity.swift
//  Domain
//
//  Created by 김재민 on 1/11/24.
//  Copyright © 2024 com.dduckdori. All rights reserved.
//

import SwiftyJSON

public struct AnswerRequestEntity {
    public var categoryId: Int
    public var questionId: Int
    public var memberId: Int
    public var inviteCode: String
    public var ansContent: String
    
    public init(_ json: JSON) {
        self.categoryId = json["cate_id"].intValue
        self.questionId = json["qust_id"].intValue
        self.memberId = json["mem_id"].intValue
        self.inviteCode = json["invite_cd"].stringValue
        self.ansContent = json["ans_cn"].stringValue
    }
}
