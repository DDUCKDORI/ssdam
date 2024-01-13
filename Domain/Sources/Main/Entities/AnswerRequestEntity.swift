//
//  AnswerRequestEntity.swift
//  Domain
//
//  Created by 김재민 on 1/11/24.
//  Copyright © 2024 com.dduckdori. All rights reserved.
//

import SwiftyJSON

public struct AnswerRequestEntity: Equatable {
    public var result: String
    public var notAnswer: Int
    public var completed: String
    
    public init(_ json: JSON) {
        self.result = json["result"].stringValue
        self.notAnswer = json["non_ans_num"].intValue
        self.completed = json["all_ans_yn"].stringValue
    }
}
