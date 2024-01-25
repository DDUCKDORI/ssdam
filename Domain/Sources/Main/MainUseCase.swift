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
    func fetchQuestionByUser(id: String) async -> FetchQuestionEntity
    func fetchAnswer(id: String) async -> FetchAnswerEntity
    func fetchAllAnswers(id: String) async -> [FetchAnswerEntity]
    func fetchAnswerByDate(date: String, code: String) async -> AnswerByDateEntity
    func postAnswer(request: PostAnswerBody) async -> RequestAnswerEntity
    func modifyAnswer(request: PostAnswerBody) async -> RequestAnswerEntity
    func fetchCompletedDates(code: String) async -> [String]
}

public final class MainUseCaseImpl: MainUseCase {
    private let repository: MainRepository
    
    public init(repository: MainRepository) {
        self.repository = repository
    }
    
    public func fetchQuestionByUser(id: String) async -> FetchQuestionEntity {
        return await FetchQuestionEntity(repository.fetchQuestionByUser(id: id))
    }
    
    public func fetchAnswer(id: String) async -> FetchAnswerEntity {
        return await FetchAnswerEntity(repository.fetchAnswer(id: id))
    }
    
    public func fetchAllAnswers(id: String) async -> [FetchAnswerEntity] {
        return await repository.fetchAllAnswers(id: id).map { FetchAnswerEntity($0) }
    }
    
    public func fetchCompletedDates(code: String) async -> [String] {
        return await repository.fetchCompletedDates(code: code).map { $0.stringValue }
    }
    
    public func fetchAnswerByDate(date: String, code: String) async -> AnswerByDateEntity {
        return await AnswerByDateEntity(repository.fetchAnswerByDate(date: date, code: code))
    }
    
    public func postAnswer(request: PostAnswerBody) async -> RequestAnswerEntity {
        return await RequestAnswerEntity(repository.postAnswer(request: request))
    }
    
    public func modifyAnswer(request: PostAnswerBody) async -> RequestAnswerEntity {
        return await RequestAnswerEntity(repository.modifyAnswer(request: request))
    }
}

