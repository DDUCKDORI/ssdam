//
//  TokenInfo.swift
//  Domain
//
//  Created by 김재민 on 2023/12/08.
//  Copyright © 2023 com.dduckdori. All rights reserved.
//

import Foundation

public struct TokenInfo: Decodable {
    let accessToken: String
    let refreshToken: String
}