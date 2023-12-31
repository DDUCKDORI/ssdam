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
    struct State: Equatable {
    }
    
    enum Action: Equatable {
    }
    
    var body: some ReducerOf<Self> {
        Reduce { state, action in
            return .none
        }
    }
}

struct HeaderView: View {
    @EnvironmentObject var screenRouter: ScreenRouter
    let store: StoreOf<HeaderReducer>
    var body: some View {
        WithViewStore(self.store, observe: { $0 }) { viewStore in
            HStack {
                Image(.logo)
                Spacer()
                Button(action: {
                    screenRouter.navigateTo(.setting)
                }, label: {
                    Image(.setting)
                })
            }
            .padding(.horizontal, 30)
        }
    }
}
