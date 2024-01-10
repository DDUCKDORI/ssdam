//
//  HeaderView.swift
//  Ssdam
//
//  Created by 김재민 on 2023/12/21.
//  Copyright © 2023 com.dduckdori. All rights reserved.
//

import SwiftUI
import ComposableArchitecture

struct HeaderReducer: Reducer {
    @Dependency(\.screenRouter) var screenRouter
    struct State: Equatable {
    }
    
    enum Action: Equatable {
        case settingTapped
    }
    
    var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case .settingTapped:
                screenRouter.routeTo(.setting)
                return .none
            }
        }
    }
}

struct HeaderView: View {
    let store: StoreOf<HeaderReducer>
    var body: some View {
        WithViewStore(self.store, observe: { $0 }) { viewStore in
            HStack {
                Image(.logo)
                Spacer()
                Button(action: {
                    viewStore.send(.settingTapped)
                }, label: {
                    Image(.setting)
                })
            }
            .padding(.horizontal, 30)
        }
    }
}
