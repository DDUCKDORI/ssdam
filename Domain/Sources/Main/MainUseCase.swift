//
//  MainUseCase.swift
//  Domain
//
//  Created by 김재민 on 1/11/24.
//  Copyright © 2024 com.dduckdori. All rights reserved.
//

import SwiftyJSON
import Networking

public protocol MainUseCase {
    func fetchQuestionByUser(id: String) async -> QuestionFetchEntity
    func fetchAnswer(id: String) async -> AnswerFetchEntity
    func postQuestion(request: PostQuestionRequest) async -> AnswerRequestEntity
    func modifyAnswer(request: PostQuestionRequest) async -> AnswerRequestEntity
}

public final class MainUseCaseImpl: MainUseCase {
    private let repository: MainRepository
    
    public init(repository: MainRepository) {
        self.repository = repository
    }
    
    public func fetchQuestionByUser(id: String) async -> QuestionFetchEntity {
        return await QuestionFetchEntity(repository.fetchQuestionByUser(id: id))
    }
    
    public func fetchAnswer(id: String) async -> AnswerFetchEntity {
        return await AnswerFetchEntity(repository.fetchAnswer(id: id))
    }
    
    public func postQuestion(request: PostQuestionRequest) async -> AnswerRequestEntity {
        return await AnswerRequestEntity(repository.postQuestion(request: request))
    }
    
    public func modifyAnswer(request: PostQuestionRequest) async -> AnswerRequestEntity {
        return await AnswerRequestEntity(repository.modifyAnswer(request: request))
    }
}

