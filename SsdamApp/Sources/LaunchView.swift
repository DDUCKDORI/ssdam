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
    @Dependency(\.screenRouter) var screenRouter
    struct State: Equatable {
        //        var text: String = ""
    }
    
    enum Action: Equatable {
        case onAppear
    }
    
    var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case .onAppear:
                if !Const.refreshToken.isEmpty {
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
            ZStack(alignment: .top) {
                Image(.tileMint)
                    .resizable(resizingMode: .tile)
                Image(.charactersSilhouette)
                    .offset(y: 296)
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
