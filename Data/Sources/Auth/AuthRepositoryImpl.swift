//
//  AuthRepositoryImpl.swift
//  Data
//
//  Created by Jimmy on 2023/10/30.
//  Copyright © 2023 com.dduckdori. All rights reserved.
//

import Combine
import Domain
import Networking
import SwiftyJSON

public final class AuthRepositoryImpl: AuthRepository {
    private let client: APIClient
    
    public init(client: APIClient) {
        self.client = client
    }
    
    public func issueAccessToken(_ code: String, _ token: String) async -> JSON {
        let data = try? await client.request(router: AuthAPI.issueAccessToken(code, token))
            .map { try? JSON(data: $0.data) }
            .mapError(\.backendError)
            .get()
        return data ?? ""
    }
    
    public func login(tokenInfo: [String: Any]) async -> JSON {
        let data = try? await client.request(router: AuthAPI.login(tokenInfo))
            .map { try? JSON(data: $0.data) }
            .mapError(\.backendError)
            .get()
        return data ?? ""
    }
}
