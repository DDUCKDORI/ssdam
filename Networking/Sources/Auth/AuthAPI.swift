//
//  AuthRepositoryImpl.swift
//  Data
//
//  Created by Jimmy on 2023/10/30.
//  Copyright © 2023 com.dduckdori. All rights reserved.
//

import Foundation
import Moya

public enum AuthAPI {
    case issueAccessToken(String, String)
    case login([String: Any])
}

extension AuthAPI: TargetType, BaseAPI {
    public var baseURL: URL {
        return self.apiURL
    }
    
    public var path: String {
        switch self {
        case .issueAccessToken:
            return "/apple/login/callback"
        case . login:
            return "/login"
        }
    }
    
    public var method: Moya.Method {
        switch self {
        default:
            return .post
        }
    }
    
    public var task: Moya.Task {
        switch self {
        default:
            return .requestParameters(parameters: parameter, encoding: encoding)
        }
    }
    
    public var parameter: [String: Any] {
        switch self {
        case let .issueAccessToken(code, token):
            return ["code": code, "id_token": token]
        case let .login(tokenInfo):
            guard let jsonData = try? JSONSerialization.data(withJSONObject: tokenInfo, options: []) else {
                return [:]
            }
            return tokenInfo
        }
    }
    
    public var headers: [String: String]? {
        switch self {
        default:
            return ["Content-type": "application/json"]
        }
    }
    
    public var encoding: ParameterEncoding {
        switch self {
        default:
            return JSONEncoding.default
        }
    }
}
