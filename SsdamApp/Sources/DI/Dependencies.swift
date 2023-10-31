//
//  Dependencies.swift
//  Ssdam
//
//  Created by Jimmy on 2023/10/31.
//  Copyright © 2023 com.dduckdori. All rights reserved.
//

import ComposableArchitecture
import Data
import Domain
import Foundation

extension AuthUseCaseImpl: DependencyKey {
    public static var liveValue: AuthUseCaseImpl {
        AuthUseCaseImpl(repository: AuthRepositoryImpl(client: .init()))
    }
}

extension DependencyValues {
    var authUseCase: AuthUseCaseImpl {
        get { self[AuthUseCaseImpl.self] }
        set { self[AuthUseCaseImpl.self] = newValue }
    }
}
