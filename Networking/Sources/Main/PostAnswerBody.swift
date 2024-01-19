//
//  PostQuestionRequest.swift
//  Networking
//
//  Created by 김재민 on 1/8/24.
//  Copyright © 2024 com.dduckdori. All rights reserved.
//

import Foundation

public struct PostAnswerBody: Encodable, Equatable {
    public var cateId: Int
    public var qustId: Int
    public var memId: Int
    public var inviteCd: String
    public var ansCn: String
    
   public init(cateId: Int = -1, qustId: Int = -1, memId: Int = -1, inviteCd: String = "", ansCn: String = "") {
        self.cateId = cateId
        self.qustId = qustId
        self.memId = memId
        self.inviteCd = inviteCd
        self.ansCn = ansCn
    }
    
    func toParam() -> [String: Any] {
        let param: [String: Any] = ["cate_id": self.cateId,
                                   "qust_id": self.qustId,
                                   "mem_id": self.memId,
                                   "invite_cd": self.inviteCd,
                                   "ans_cn": self.ansCn]
        return param
    }
}
