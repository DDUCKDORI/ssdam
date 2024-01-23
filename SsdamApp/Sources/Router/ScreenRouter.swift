//
//  ScreenRouter.swift
//  Ssdam
//
//  Created by 김재민 on 1/9/24.
//  Copyright © 2024 com.dduckdori. All rights reserved.
//

import Foundation
import UIKit
import SwiftUI
import ComposableArchitecture

public typealias ScreenRouter = Router<ScreenRoute, ScreenRouterFactory>

public enum ScreenRoute: ScreenProtocol {
    case launch
    case login
    case signUp
    case signUpSuccess(String)
    case home
    case fullScreen
    case sheetScreen
    case setting
    
   public var isHiddenNavigation: Bool {
        switch self {
        case .launch, .login, .signUp, .signUpSuccess:
            return true
        default:
            return false
        }
    }
    
   public var title: String {
        switch self {
        default:
            return ""
        }
    }
}

public final class ScreenRouterFactory: RouterFactory {
    @ViewBuilder public func makeBody(for screen: ScreenRoute) -> some View {
        switch screen {
        case .launch:
            LaunchView(store: .init(initialState: LaunchReducer.State(), reducer: {
                LaunchReducer()
            }))
        case .login:
            LoginView(store: .init(initialState: LoginReducer.State(), reducer: {
                LoginReducer()
            }))
        case .signUp:
            SignupView(store: .init(initialState: SignupReducer.State(), reducer: {
                SignupReducer()
            }))
        case let .signUpSuccess(nickname):
            SignUpSuccessView(store: .init(initialState: SignUpSuccessReducer.State(nickname: nickname), reducer: {
                SignUpSuccessReducer()
            }))
        case .home:
            TabRouterView(store: .init(initialState: TabRouterReducer.State(), reducer: {
                TabRouterReducer()
            }))
            .ignoresSafeArea(.keyboard, edges: .bottom)
        case .fullScreen:
            Text("Full Screen")
        case .setting:
            SettingView(store: .init(initialState: SettingReducer.State(), reducer: {
                SettingReducer()
            }))
        case .sheetScreen:
            EmptyView()
        }
    }
    
    public func makeViewController(for screen: ScreenRoute) -> UIViewController {
        UIHostingController(rootView: makeBody(for: screen))
    }
}
