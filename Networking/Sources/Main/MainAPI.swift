//
//  MainAPI.swift
//  Networking
//
//  Created by 김재민 on 1/8/24.
//  Copyright © 2024 com.dduckdori. All rights reserved.
//

import Foundation
import Moya

public enum MainAPI {
    case fetchQuestionByUser(String)
    case fetchAnswer(String)
    case postQuestion(PostQuestionRequest)
    case modifyAnswer(PostQuestionRequest)
    case fetchAnswerByDate(String, String)
    case fetchMember(String)
    
}

extension MainAPI: BaseAPI, TargetType {
    public var baseURL: URL {
        self.apiURL
    }
    
    public var path: String {
        switch self {
        case let .fetchQuestionByUser(id):
            return "/ssdam/question/\(id)"
        case let .fetchAnswer(id):
            return "/ssdam/answer/\(id)"
        case .postQuestion(_):
            return "/ssdam/answer"
        case .modifyAnswer(_):
            return "/ssdam/answer"
        case let .fetchAnswerByDate(date, code):
            return "/ssdam/question/\(date)/\(code)"
        case let .fetchMember(code):
            return "/ssdam/family/\(code)"
        }
    }
    
    public var method: Moya.Method {
        switch self {
        case .postQuestion:
            return .post
        case . modifyAnswer:
            return .patch
        default:
            return .get
        }
    }
    
    public var task: Moya.Task {
        switch self {
        case let .postQuestion(request):
            return .requestParameters(parameters: request.toParam(), encoding: encoding)
        case let .modifyAnswer(request):
            return .requestParameters(parameters: request.toParam(), encoding: encoding)
        default:
            return .requestPlain
        }
    }
    
    public var encoding: ParameterEncoding {
        switch self {
        case .postQuestion, .modifyAnswer:
            return JSONEncoding.default
        default: return URLEncoding.default
        }
    }
}
