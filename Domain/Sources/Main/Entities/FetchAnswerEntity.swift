//
//  AnswerGetEntity.swift
//  Domain
//
//  Created by 김재민 on 1/11/24.
//  Copyright © 2024 com.dduckdori. All rights reserved.
//

import SwiftyJSON

public struct FetchAnswerEntity: Equatable {
    public var result: String
    public var inviteCode: String
    public var memberId: Int
    public var nickname: String
    public var categoryId: Int
    public var questionId: Int
    public var ansContent: String
    public var createdAt: String
    
    public init(_ json: JSON) {
        self.result = json["result"].stringValue
        self.inviteCode = json["invite_cd"].stringValue
        self.memberId = json["mem_id"].intValue
        self.nickname = json["nick_nm"].stringValue
        self.categoryId = json["cate_id"].intValue
        self.questionId = json["qust_id"].intValue
        self.ansContent = json["ans_cn"].stringValue
        self.createdAt = json["ans_dtm"].stringValue
    }
}
