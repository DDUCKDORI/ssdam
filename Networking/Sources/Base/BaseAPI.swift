//
//  BaseAPI.swift
//  Networking
//
//  Created by 김재민 on 1/9/24.
//  Copyright © 2024 com.dduckdori. All rights reserved.
//

import Foundation
import Utils
import Moya

public protocol BaseAPI: TargetType, AccessTokenAuthorizable {}

public extension BaseAPI {
    var apiURL: URL { URL(string: Bundle.main.infoDictionary!["BASE_URL"] as! String)! }
    
    var headers: [String: String]? {
        ["Content-Type": "application/json"]
    }
    
    var authorizationType: AuthorizationType? { .bearer }
    
    var validationType: ValidationType { .successCodes }
}
