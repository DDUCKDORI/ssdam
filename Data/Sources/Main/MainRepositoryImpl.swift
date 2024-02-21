//
//  MainRepositoryImpl.swift
//  Data
//
//  Created by 김재민 on 1/11/24.
//  Copyright © 2024 com.dduckdori. All rights reserved.
//

import Combine
import Domain
import Networking
import SwiftyJSON

public final class MainRepositoryImpl: MainRepository {
    private let client: APIClient
    
    public init(client: APIClient) {
        self.client = client
    }
    public func fetchQuestionByUser(id: String) async -> JSON {
        let data = try? await client.request(router: MainAPI.fetchQuestionByUser(id))
            .map { try? JSON(data: $0.data) }
//            .mapError(\.backendError)
            .get()
        return data ?? ""
    }
    
    public func fetchAnswer(id: String) async -> JSON {
        let data = try? await client.request(router: MainAPI.fetchAnswer(id))
            .map { try? JSON(data: $0.data) }
//            .mapError(\.backendError)
            .get()
        return data ?? ""
    }
    
    public func fetchAllAnswers(id: String) async -> [JSON] {
        let data = try? await client.request(router: MainAPI.fetchAnswer(id))
            .map { try? JSON(data: $0.data).arrayValue }
//            .mapError(\.backendError)
            .get()
        return data ?? []
    }
    
    public func fetchCompletedDates(code: String) async -> [JSON] {
        let data = try? await client.request(router: MainAPI.fetchCompletedDates(code))
            .map { try? JSON(data: $0.data)["date"].arrayValue }
//            .mapError(\.backendError)
            .get()
        return data ?? []
    }
    
    public func fetchAnswerByDate(date: String, code: String) async -> JSON {
        let data = try? await client.request(router: MainAPI.fetchAnswerByDate(date, code))
            .map { try? JSON(data: $0.data) }
//            .mapError(\.backendError)
            .get()
        return data ?? ""
    }
    
    public func postAnswer(request: PostAnswerBody) async -> JSON {
        let data = try? await client.request(router: MainAPI.postQuestion(request))
            .map { try? JSON(data: $0.data) }
//            .mapError(\.backendError)
            .get()
        return data ?? ""
    }
    
    public func modifyAnswer(request: PostAnswerBody) async -> JSON {
        let data = try? await client.request(router: MainAPI.modifyAnswer(request))
            .map { try? JSON(data: $0.data) }
//            .mapError(\.backendError)
            .get()
        return data ?? ""
    }
}
