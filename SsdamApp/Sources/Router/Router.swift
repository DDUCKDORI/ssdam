//
//  RouterObject.swift
//  vkdoc
//
//  Created by Данил Ломаев on 15.04.2022.
//

import Foundation
import SwiftUI

enum ScreenRoute: ScreenProtocol {
    case login
    case navigator
    case fullScreen
    case sheetScreen
    
    var embedInNavView: Bool {
        switch self {
        case .login, .sheetScreen:
            return true
        case .navigator, .fullScreen:
            return false
        }
    }
}

class ScreenRouterFactory: RouterFactory {
    
    @ViewBuilder func makeBody(for screen: ScreenRoute) -> some View {
        switch screen {
        case .login:
            ContentView(store: .init(initialState: MainReducer.State(), reducer: {
                MainReducer()
            }))
        case .navigator:
            EmptyView()
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
}

protocol RouterObject: AnyObject {
    associatedtype Screen = ScreenProtocol
    associatedtype Body = View
    
    func start(_ screen: Screen) -> Body
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
    
    init(presentationType: PresentationType = .push, factory: Factory) {
        self.factory = factory
    }
}

extension Router {
    func start(_ rootScreen: ScreenType) -> some View {
        self.stack = [RouterContext(screen: rootScreen, presentationType: .push)]
        let bindingScreens = Binding(get: {
            return self.stack
        }, set: {
            self.stack = $0
        })
        
        return Routing(stack: bindingScreens) { screen in
            self.factory.makeBody(for: screen)
        }
        //        }
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
