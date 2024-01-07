//
//  TokenInfo.swift
//  Domain
//
//  Created by 김재민 on 2023/12/08.
//  Copyright © 2023 com.dduckdori. All rights reserved.
//

import Foundation

public struct TokenInfo: Decodable {
    public var isUser: String
    public var accessToken: String
    public var refreshToken: String
    public var inviteCd: String?
    public var memId: Int
    public var fmDvcd: String?
    public var nickname: String?
    public var email: String?
    public var memSub: String
    
    public init(isUser: String = "", accessToken: String = "", refreshToken: String = "", inviteCd: String? = nil, memId: Int = -1, fmDvcd: String? = nil, nickname: String? = nil, email: String? = nil, memSub: String = "") {
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
    
}
