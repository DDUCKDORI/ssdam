//
//  RouterObject.swift
//  vkdoc
//
//  Created by Данил Ломаев on 15.04.2022.
//

import Foundation
import SwiftUI

enum ScreenRoute: ScreenProtocol {
    var title: String {
        switch self {
        case .signUp:
            return "회원가입"
        default:
            return ""
        }
    }
    
    case login
    case signUp
    case signUpSuccess(String)
    case home
    case fullScreen
    case sheetScreen
    
    var embedInNavView: Bool {
        switch self {
        case .login, .sheetScreen, .home:
            return true
        case .signUp, .signUpSuccess, .fullScreen:
            return false
        }
    }
}

class ScreenRouterFactory: RouterFactory {
    
    @ViewBuilder func makeBody(for screen: ScreenRoute) -> some View {
        switch screen {
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
        case .fullScreen:
            EmptyView()
        case .sheetScreen:
            EmptyView()
        }
    }
}

typealias ScreenRouter = Router<ScreenRoute, ScreenRouterFactory>

enum PresentationType {
    case push
    case full
    case modal
}

protocol ScreenProtocol {
    var embedInNavView: Bool { get }
    var title: String { get }
}

protocol RouterObject: AnyObject {
    associatedtype Screen = ScreenProtocol
    associatedtype Body = View
    
    func start() -> Body
    func navigateTo(_ screen: Screen)
    func presentSheet(_ screen: Screen)
    func presentFullScreen(_ screen: Screen)
    func dismissLast()
    func popToRoot()
}

struct RouterContext<ScreenType: ScreenProtocol> {
    let screen: ScreenType
    let presentationType: PresentationType
}

class Router<ScreenType, Factory: RouterFactory>: ObservableObject, RouterObject where Factory.Screen == ScreenType {
    
    @Published private var stack: [RouterContext<ScreenType>] = []
    var factory: Factory
    
    init(rootScreen: ScreenType, presentationType: PresentationType = .push, factory: Factory) {
        self.stack = [RouterContext(screen: rootScreen, presentationType: .push)]
        self.factory = factory
    }
}

extension Router {
    func start() -> some View {
        let bindingScreens = Binding(get: {
            return self.stack
        }, set: {
            self.stack = $0
        })
        
        return Routing(stack: bindingScreens) { screen in
            self.factory.makeBody(for: screen)
        }
    }
    
    func change(_ screen: ScreenType) {
        self.stack = [RouterContext(screen: screen, presentationType: .push)]
    }
    
    func presentSheet(_ screen: ScreenType) {
        self.stack.append(RouterContext(screen: screen, presentationType: .modal))
    }
    
    func dismissLast() {
        self.stack.removeLast()
    }
    
    func navigateTo(_ screen: ScreenType) {
        self.stack.append(RouterContext(screen: screen, presentationType: .push))
    }
    
    func presentFullScreen(_ screen: ScreenType) {
        self.stack.append(RouterContext(screen: screen, presentationType: .full))
    }
    
    func popToRoot() {
        self.stack.removeLast(self.stack.count - 1)
    }
}
