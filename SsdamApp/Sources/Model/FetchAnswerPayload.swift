//
//  FetchAnswerPayload.swift
//  Ssdam
//
//  Created by 김재민 on 1/13/24.
//  Copyright © 2024 com.dduckdori. All rights reserved.
//

import Foundation
import SwiftyJSON
import Domain

struct FetchAnswerPayload: Equatable, Hashable {
    var result: String
    var invite_cd: String
    var memberId: Int
    var categoryId: Int
    var questionId: Int
    var answer: String
    var createdAt: String
    
    init(result: String = "", invite_cd: String = "", memberId: Int = -1, categoryId: Int = -1, questionId: Int = -1, answer: String = "", createdAt: String = "") {
        self.result = result
        self.invite_cd = invite_cd
        self.memberId = memberId
        self.categoryId = categoryId
        self.questionId = questionId
        self.answer = answer
        self.createdAt = createdAt
    }
    
    init(_ entity: AnswerFetchEntity) {
        self.result = entity.result
        self.invite_cd = entity.inviteCode
        self.memberId = entity.memberId
        self.categoryId = entity.categoryId
        self.questionId = entity.questionId
        self.answer = entity.ansContent
        self.createdAt = entity.createdAt
    }
}
