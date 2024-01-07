//
//  LaunchView.swift
//  Ssdam
//
//  Created by 김재민 on 2023/12/31.
//  Copyright © 2023 com.dduckdori. All rights reserved.
//

import SwiftUI
import ComposableArchitecture
import Utils

struct LaunchReducer: Reducer {
    struct State: Equatable {
        var text: String = ""
    }
    
    enum Action: Equatable {
        case onAppear
    }
    
    var body: some ReducerOf<Self> {
        Reduce { state, action in
            return .none
        }
    }
}

struct LaunchView: View {
    @EnvironmentObject var screenRouter: ScreenRouter
    let store: StoreOf<LaunchReducer>
    
    var body: some View {
        ZStack(alignment: .top) {
            Image(.tileMint)
                .resizable(resizingMode: .tile)
        }
        .ignoresSafeArea()
        .safeAreaInset(edge: .top) {
            Image(.charactersSilhouette)
                .offset(y: 285)
        }
        .onAppear {
            if !Const.refreshToken.isEmpty {
                screenRouter.change(.home)
                return
            }
            screenRouter.change(.login)
        }
    }
}

#Preview {
    LaunchView(store: .init(initialState: LaunchReducer.State(), reducer: {
        LaunchReducer()
    }))
}
