//
//  QuestionGetEntity.swift
//  Domain
//
//  Created by 김재민 on 1/11/24.
//  Copyright © 2024 com.dduckdori. All rights reserved.
//

import SwiftyJSON

public struct FetchQuestionEntity: Equatable {
    public var result: String
    public var memberId: Int
    public var categoryId: Int
    public var questionId: Int
    public var quesContent: String
    public var ansContent: String
    public var questionCreatedAt: String
    public var answerCreatedAt: String
    public var isReplied: String
    public var inviteCode: String
    public var notAnswer: Int
    
    public init(_ json: JSON) {
        self.result = json["result"].stringValue
        self.memberId = json["mem_id"].intValue
        self.categoryId = json["cate_id"].intValue
        self.questionId = json["qust_id"].intValue
        self.quesContent = json["qust_cn"].stringValue
        self.ansContent = json["ans_cn"].stringValue
        self.questionCreatedAt = json["qus_dtm"].stringValue
        self.answerCreatedAt = json["ans_dtm"].stringValue
        self.isReplied = json["rpy_yn"].stringValue
        self.inviteCode = json["invite_cd"].stringValue
        self.notAnswer = json["non_ans_num"].intValue
    }
}
