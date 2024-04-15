//
//  SignupView.swift
//  Ssdam
//
//  Created by 김재민 on 2023/11/26.
//  Copyright © 2023 com.dduckdori. All rights reserved.
//

import SwiftUI
import ComposableArchitecture

@Reducer
struct SignupReducer {
    struct State: Equatable {
        var userType: UserTypeReducer.State = .init()
        var nickname: NicknameReducer.State = .init()
        var page: Int = 0
    }
    
    enum Action {
        case userType(UserTypeReducer.Action)
        case nickname(NicknameReducer.Action)
        case pageChanged
    }
    
    var body: some ReducerOf<Self> {
        Scope(state: \.userType, action: /Action.userType) {
            UserTypeReducer()
        }
        Scope(state: \.nickname, action: /Action.nickname) {
            NicknameReducer()
        }
        Reduce { state, action in
            switch action {
            case .pageChanged:
                state.page = 1
                return .none
            default:
                return .none
            }
        }
    }
    
}

struct SignupView: View {
    let store: StoreOf<SignupReducer>
    var body: some View {
        WithViewStore(self.store, observe: { $0 }) { viewStore in
            VStack {
                Spacer()
                HStack(spacing: 8) {
                    ForEach(0 ..< 2, id: \.self) { index in
                        Color(index <= viewStore.page ? .mint50 : .gray20)
                            .frame(maxWidth: .infinity, maxHeight: 10)
                    }
                    Color(viewStore.nickname.isValid ? .mint50 : .gray20)
                        .frame(maxWidth: .infinity, maxHeight: 10)
                }
                .padding(.horizontal, 30)
                Spacer()
                PageViewController(pages: [
                    AnyView(UserTypeView(store: self.store.scope(state: \.userType, action: \.userType), page: viewStore.binding(get: \.page, send: .pageChanged))),
                    AnyView(NicknameView(store: self.store.scope(state: \.nickname, action: \.nickname)))
                ], currentPage: viewStore.binding(get: \.page, send: .pageChanged), swipeable: false)
                .frame(maxHeight: 525)
                Spacer()
            }
            .ignoresSafeArea(.keyboard)
        }
    }
}

#Preview {
    SignupView(store: .init(initialState: SignupReducer.State(), reducer: {
        SignupReducer()
    }))
}
