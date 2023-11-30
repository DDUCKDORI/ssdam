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
    @Dependency(\.screenRouter) var screenRouter
    @UIApplicationDelegateAdaptor var delegate: AppDelegate
    
    
    var body: some Scene {
        WindowGroup {
            screenRouter.start(.login)
        }
    }
}
