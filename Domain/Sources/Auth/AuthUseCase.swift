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
    func fetchAccessCode(_ phoneNumber: String) -> AnyPublisher<AccessCodeEntity, BackendError>
}

public final class AuthUseCaseImpl: AuthUseCase {
    private let repository: AuthRepository

    public init(repository: AuthRepository) {
        self.repository = repository
    }

    public func fetchAccessCode(_ phoneNumber: String) -> AnyPublisher<AccessCodeEntity, BackendError> {
        repository.fetchAccessCode(phoneNumber: phoneNumber)
            .map { AccessCodeEntity($0) }
            .eraseToAnyPublisher()
    }
}
