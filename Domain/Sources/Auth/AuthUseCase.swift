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
}

public final class AuthUseCaseImpl: AuthUseCase {
    private let repository: AuthRepository

    public init(repository: AuthRepository) {
        self.repository = repository
    }
    
    public func issueAccessToken(_ code: String, _ token: String) async -> TokenEntity {
        return await TokenEntity(repository.issueAccessToken(code, token))
    }
}
