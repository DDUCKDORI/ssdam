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

    public func fetchAccessCode(phoneNumber: String) -> AnyPublisher<JSON, BackendError> {
        client.request(router: AuthAPI.fetchAccessCode(phoneNumber: phoneNumber))
            .compactMap { try? JSON(data: $0.data)["data"] }
            .mapError(\.backendError)
            .eraseToAnyPublisher()
    }
}
