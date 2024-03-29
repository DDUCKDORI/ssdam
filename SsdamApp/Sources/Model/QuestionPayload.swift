//
//  QuestionPayload.swift
//  Ssdam
//
//  Created by 김재민 on 1/13/24.
//  Copyright © 2024 com.dduckdori. All rights reserved.
//

import Foundation
import Domain

struct QuestionPayload: Equatable {
    var result: String
    var memberId: Int
    var categoryId: Int
    var questionId: Int
    var quesContent: String
    var ansContent: String
    var questionCreatedAt: String
    var answerCreatedAt: String
    var isReplied: String
    var inviteCode: String
    var notAnswer: Int
    
    init(result: String = "", memberId: Int = -1, categoryId: Int = -1, questionId: Int = -1, quesContent: String = "", ansContent: String = "", questionCreatedAt: String = "", answerCreatedAt: String = "", isReplied: String = "", inviteCode: String = "", notAnswer: Int = -1) {
        self.result = result
        self.memberId = memberId
        self.categoryId = categoryId
        self.questionId = questionId
        self.quesContent = quesContent
        self.ansContent = ansContent
        self.questionCreatedAt = questionCreatedAt
        self.answerCreatedAt = answerCreatedAt
        self.isReplied = isReplied
        self.inviteCode = inviteCode
        self.notAnswer = notAnswer
    }
    
    init(_ entity: FetchQuestionEntity) {
        self.result = entity.result
        self.memberId = entity.memberId
        self.categoryId = entity.categoryId
        self.questionId = entity.questionId
        self.quesContent = entity.quesContent
        self.ansContent = entity.ansContent
        self.questionCreatedAt = entity.questionCreatedAt
        self.answerCreatedAt = entity.answerCreatedAt
        self.isReplied = entity.isReplied
        self.inviteCode = entity.inviteCode
        self.notAnswer = entity.notAnswer
    }
}
