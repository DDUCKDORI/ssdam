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
    public static var previewValue: AuthUseCaseImpl {
        AuthUseCaseImpl(repository: AuthRepositoryImpl(client: .init()))
    }
}

extension Router: DependencyKey {
    public static var liveValue: ScreenRouter {
        ScreenRouter(factory: .init())
    }
    public static var previewValue: ScreenRouter {
        ScreenRouter(factory: .init())
    }
}

extension MainUseCaseImpl: DependencyKey {
    public static var liveValue: MainUseCaseImpl {
        MainUseCaseImpl(repository: MainRepositoryImpl(client: .init()))
    }
    public static var previewValue: MainUseCaseImpl {
        MainUseCaseImpl(repository: MainRepositoryImpl(client: .init()))
    }
}

extension PurchaseManager: DependencyKey {
    public static var liveValue: PurchaseManager { .shared }
    public static var previewValue: PurchaseManager { .shared }
}


extension DependencyValues {
    var screenRouter: ScreenRouter {
        get { self[ScreenRouter.self] }
        set { self[ScreenRouter.self] = newValue}
    }
    
    var authUseCase: AuthUseCaseImpl {
        get { self[AuthUseCaseImpl.self] }
        set { self[AuthUseCaseImpl.self] = newValue }
    }
    
    var mainUseCase: MainUseCaseImpl {
        get { self[MainUseCaseImpl.self] }
        set { self[MainUseCaseImpl.self] = newValue }
    }
    
    var purchaseManager: PurchaseManager {
        get {self[PurchaseManager.self] }
        set {self[PurchaseManager.self] = newValue }
    }
}
