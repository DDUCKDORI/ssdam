//
//  AnswerPayload.swift
//  Ssdam
//
//  Created by 김재민 on 1/13/24.
//  Copyright © 2024 com.dduckdori. All rights reserved.
//

import Foundation
import Domain
import SwiftyJSON

struct RequestAnswerPayload: Equatable {
    var result : String
    var notAnswer : Int
    var completed : String
    
    init(result: String = "", notAnswer: Int = -1, completed: String = "") {
        self.result = result
        self.notAnswer = notAnswer
        self.completed = completed
    }
    
    init(_ entity: AnswerRequestEntity) {
        self.result = entity.result
        self.notAnswer = entity.notAnswer
        self.completed = entity.completed
    }
}
