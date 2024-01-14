//
//  DateAnswerPayload.swift
//  Ssdam
//
//  Created by 김재민 on 1/14/24.
//  Copyright © 2024 com.dduckdori. All rights reserved.
//

import Foundation
import Domain

struct AnswerByDatePayload: Equatable {
    public var result : String
    public var categoryId : Int
    public var questionId : Int
    public var question : String
    public var inviteCode : String
    public var answerList : [AnswerList]
    
    init(result: String = "", categoryId: Int = -1, questionId: Int = -1, question: String = "", inviteCode: String = "", answerList: [AnswerList] = []) {
        self.result = result
        self.categoryId = categoryId
        self.questionId = questionId
        self.question = question
        self.inviteCode = inviteCode
        self.answerList = answerList
    }
    
    init(_ entity: AnswerByDateEntity) {
        self.result = entity.result
        self.categoryId = entity.categoryId
        self.questionId = entity.questionId
        self.question = entity.question
        self.inviteCode = entity.inviteCode
        self.answerList = entity.answerList.map { AnswerList($0) }
    }
}

struct AnswerList: Equatable {
    public var nickname: String
    public var answer: String
    public var createdAt: String
    
    init(_ entity: AnswerListEntity) {
        self.nickname = entity.nickname
        self.answer = entity.answer
        self.createdAt = entity.createdAt
    }
}
