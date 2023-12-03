//
//  SsdamApp.swift
//  Ssdam
//
//  Created by Jimmy on 2023/10/30.
//  Copyright © 2023 com.dduckdori. All rights reserved.
//

import SwiftUI
import ComposableArchitecture

@main
struct SsdamApp: App {
    let screenRouter = ScreenRouter(rootScreen: .login, factory: .init())
    @UIApplicationDelegateAdaptor var delegate: AppDelegate
    
    
    var body: some Scene {
        WindowGroup {
            MainView(store: .init(initialState: MainReducer.State(), reducer: {
                MainReducer()
            }))
            .environmentObject(screenRouter)
        }
    }
}
