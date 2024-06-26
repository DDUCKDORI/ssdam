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

@Reducer
struct LaunchReducer {
    @Dependency(\.screenRouter) var screenRouter
    struct State: Equatable {
    }
    
    enum Action: Equatable {
        case onAppear
    }
    
    var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case .onAppear:
                if Const.isUser == "yes" {
                    screenRouter.change(root: .home)
                    return .none
                }
                screenRouter.change(root: .login)
                return .none
            }
        }
    }
}

struct LaunchView: View {
    let store: StoreOf<LaunchReducer>
    
    var body: some View {
        WithViewStore(self.store, observe:  { $0 } ) { viewStore in
            ZStack {
                Image(.tileMint)
                    .resizable(resizingMode: .tile)
                Image(.charactersSilhouette)
                    .offset(y: -60)
            }
            .ignoresSafeArea()
            .onAppear {
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                    viewStore.send(.onAppear)
                }
            }
        }
    }
}

#Preview {
    LaunchView(store: .init(initialState: LaunchReducer.State(), reducer: {
        LaunchReducer()
    }))
}
