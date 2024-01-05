//
//  TokenEntity.swift
//  Domain
//
//  Created by 김재민 on 2024/01/03.
//  Copyright © 2024 com.dduckdori. All rights reserved.
//

import Foundation
import SwiftyJSON

public struct TokenEntity: Equatable {
    public var isUser: String
    public var accessToken: String
    public var refreshToken: String
    public var inviteCd: String
    public var memId: Int
    public var fmDvcd: String
    public var nickname: String
    public var email: String
    public var memSub: String
    
    public init(_ json: JSON) {
        self.isUser = json["exists_yn"].stringValue
        self.accessToken = json["access_token"].stringValue
        self.refreshToken = json["refresh_token"].stringValue
        self.inviteCd = json["invite_cd"].stringValue
        self.memId = json["mem_id"].intValue
        self.fmDvcd = json["fm_dvcd"].stringValue
        self.nickname = json["nick_nm"].stringValue
        self.email = json["email"].stringValue
        self.memSub = json["mem_sub"].stringValue
    }
}
