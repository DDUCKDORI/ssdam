//
//  FetchAnswerPayload.swift
//  Ssdam
//
//  Created by 김재민 on 1/13/24.
//  Copyright © 2024 com.dduckdori. All rights reserved.
//

import Foundation
import Domain

struct FetchAnswerPayload: Equatable, Hashable {
    var result: String
    var invite_cd: String
    var memberId: Int
    var nickname: String
    var categoryId: Int
    var questionId: Int
    var answer: String
    var createdAt: String
    
    init(result: String = "", invite_cd: String = "", memberId: Int = -1, nickname: String = "", categoryId: Int = -1, questionId: Int = -1, answer: String = "", createdAt: String = "") {
        self.result = result
        self.invite_cd = invite_cd
        self.memberId = memberId
        self.nickname = nickname
        self.categoryId = categoryId
        self.questionId = questionId
        self.answer = answer
        self.createdAt = createdAt
    }
    
    init(_ entity: FetchAnswerEntity) {
        self.result = entity.result
        self.invite_cd = entity.inviteCode
        self.memberId = entity.memberId
        self.nickname = entity.nickname
        self.categoryId = entity.categoryId
        self.questionId = entity.questionId
        self.answer = entity.ansContent
        self.createdAt = entity.createdAt
    }
}
