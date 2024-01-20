//
//  AuthRepositoryImpl.swift
//  Data
//
//  Created by Jimmy on 2023/10/30.
//  Copyright © 2023 com.dduckdori. All rights reserved.
//

import Foundation
import Moya
import Utils

public enum AuthAPI {
    case issueAccessToken(String, String)
    case login([String: Any])
    case fetchNumberOfFamily(String)
    case join(FamilyJoinBody)
}

extension AuthAPI: BaseAPI, TargetType {
    public var baseURL: URL {
        self.apiURL
    }
    
    public var path: String {
        switch self {
        case .issueAccessToken:
            return "/apple/login/callback"
        case .login:
            return "/login"
        case let .fetchNumberOfFamily(code):
            return "/family/\(code)"
        case .join:
            return "/join"
        }
    }
    
    public var method: Moya.Method {
        switch self {
        case .fetchNumberOfFamily:
            return .get
        case .join:
            return .patch
        default:
            return .post
        }
    }
    
    public var task: Moya.Task {
        switch self {
        case .fetchNumberOfFamily:
            return .requestPlain
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
        case let .join(body):
            return body.toParam()
        default:
            return [:]
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
        case .fetchNumberOfFamily:
            return URLEncoding.default
        default:
            return JSONEncoding.default
        }
    }
}
