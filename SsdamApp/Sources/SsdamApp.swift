//
//  SsdamApp.swift
//  Ssdam
//
//  Created by Jimmy on 2023/10/30.
//  Copyright © 2023 com.dduckdori. All rights reserved.
//

import SwiftUI
import FirebaseCore

@main
struct SsdamApp: App {
    init() {
        FirebaseApp.configure()
    }
    var body: some Scene {
        WindowGroup {
            ContentView(store: .init(initialState: MainReducer.State(), reducer: {
                MainReducer()
            }))
        }
    }
}
