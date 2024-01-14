//
//  AuthUseCase.swift
//  Domain
//
//  Created by Jimmy on 2023/10/30.
//  Copyright © 2023 com.dduckdori. All rights reserved.
//

import Combine
import SwiftyJSON
import Networking

public protocol AuthUseCase {
    func issueAccessToken(_ code: String, _ token: String) async -> TokenEntity
    func login(tokenInfo: [String: Any]) async -> TokenEntity
    func fetchNumberOfFamily(code: String) async -> NumberOfFamilyEntity
}

public final class AuthUseCaseImpl: AuthUseCase {
    private let repository: AuthRepository

    public init(repository: AuthRepository) {
        self.repository = repository
    }
    
    public func issueAccessToken(_ code: String, _ token: String) async -> TokenEntity {
        return await TokenEntity(repository.issueAccessToken(code, token))
    }
    
    public func login(tokenInfo: [String: Any]) async -> TokenEntity {
        return await TokenEntity(repository.login(tokenInfo: tokenInfo))
    }
    
    public func fetchNumberOfFamily(code: String) async -> NumberOfFamilyEntity {
        return await NumberOfFamilyEntity(repository.fetchNumberOfFamily(code: code))
    }
}
