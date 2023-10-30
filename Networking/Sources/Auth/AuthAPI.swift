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
    case fetchAccessCode(phoneNumber: String)
}

extension AuthAPI: TargetType {
    public var baseURL: URL {
        switch self {
        case .fetchAccessCode:
            return URL(string: "")!
        }
    }

    public var path: String {
        switch self {
        case .fetchAccessCode:
            return "user/access-code/send-issuance-message"
        }
    }

    public var method: Moya.Method {
        .post
    }

    public var task: Moya.Task {
        switch self {
        default: return .requestParameters(parameters: parameter, encoding: encoding)
        }
    }

    public var parameter: [String: Any] {
        switch self {
        case .fetchAccessCode(let phoneNumber): return ["phoneNumber": phoneNumber]
        }
    }

    public var headers: [String: String]? {
        return ["Content-type": "application/json"]
    }

    public var encoding: ParameterEncoding {
        JSONEncoding.default
    }
}
