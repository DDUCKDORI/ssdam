//
//  TokenPayload.swift
//  Ssdam
//
//  Created by 김재민 on 2024/01/03.
//  Copyright © 2024 com.dduckdori. All rights reserved.
//

import Foundation
import Domain

struct TokenPayload: Equatable {
    var isUser: String
    var accessToken: String
    var refreshToken: String
    var inviteCd: String?
    var memId: Int
    var fmDvcd: String?
    var nickname: String?
    var email: String
    var memSub: String
    
    init(isUser: String = "", accessToken: String = "", refreshToken: String = "", inviteCd: String? = nil, memId: Int = -1, fmDvcd: String? = nil, nickname: String? = nil, email: String = "", memSub: String = "") {
        self.isUser = isUser
        self.accessToken = accessToken
        self.refreshToken = refreshToken
        self.inviteCd = inviteCd
        self.memId = memId
        self.fmDvcd = fmDvcd
        self.nickname = nickname
        self.email = email
        self.memSub = memSub
    }
    
    init(_ entity: TokenEntity) {
        self.isUser = entity.isUser
        self.accessToken = entity.accessToken
        self.refreshToken = entity.refreshToken
        self.inviteCd = entity.inviteCd
        self.memId = entity.memId
        self.fmDvcd = entity.fmDvcd
        self.nickname = entity.nickname
        self.email = entity.email
        self.memSub = entity.memSub
    }
}


