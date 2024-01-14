//
//  AnswerByDateEntity.swift
//  Domain
//
//  Created by 김재민 on 1/14/24.
//  Copyright © 2024 com.dduckdori. All rights reserved.
//

import Foundation
import SwiftyJSON

public struct AnswerByDateEntity: Equatable {
    public var result : String
    public var categoryId : Int
    public var questionId : Int
    public var question : String
    public var inviteCode : String
    public var answerList : [AnswerListEntity]
    
    public init(_ json: JSON) {
        self.result = json["result"].stringValue
        self.categoryId = json["cate_id"].intValue
        self.questionId = json["qust_id"].intValue
        self.question = json["qust_cn"].stringValue
        self.inviteCode = json["invite_cd"].stringValue
        self.answerList = json["ans_list"].arrayValue.map { AnswerListEntity($0) }
    }
}

public struct AnswerListEntity: Equatable {
    public var nickname: String
    public var answer: String
    public var createdAt: String
    
    public init(_ json: JSON) {
        self.nickname = json["nick_nm"].stringValue
        self.answer = json["ans_cn"].stringValue
        self.createdAt = json["ans_dtm"].stringValue
    }
}
