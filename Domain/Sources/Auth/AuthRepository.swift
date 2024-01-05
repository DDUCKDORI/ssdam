//
//  AuthRepositoryImpl.swift
//  Data
//
//  Created by Jimmy on 2023/10/30.
//  Copyright © 2023 com.dduckdori. All rights reserved.
//

import Combine
import Foundation
import Networking
import SwiftyJSON

public protocol AuthRepository: AnyObject {
    func issueAccessToken(_ code: String, _ token: String) async -> JSON
    func login(tokenInfo: [String: Any]) async -> JSON
}
