//
//  UserTypeView.swift
//  Ssdam
//
//  Created by 김재민 on 2023/11/16.
//  Copyright © 2023 com.dduckdori. All rights reserved.
//

import SwiftUI
import ComposableArchitecture

enum UserType {
    case parent
    case child
}

struct UserTypeReducer: Reducer {
    struct State: Equatable {
        var userType: UserType? = nil
    }
    
    enum Action: Equatable {
        case userTypeTapped(UserType)
    }
    
    var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case let .userTypeTapped(type):
                state.userType = type
                return .none
            }
        }
    }
}

struct UserTypeView: View {
    let store: StoreOf<UserTypeReducer>
    @Binding var page: Int
    var body: some View {
        WithViewStore(self.store, observe: { $0 }) { viewStore in
            VStack(spacing: 16) {
                Text("누구인지 선택해주세요")
                    .font(.pHeadline2)
                    .foregroundStyle(Color(.systemBlack))
                
                HStack {
                    Button(action: {
                        page += 1
//                        viewStore.send(.userTypeTapped(.parent))
                    }, label: {
                        Text("부모")
                            .selectableButton(viewStore.userType == .parent ? .constant(true) : .constant(false))
                    })
                    Button(action: {
                        viewStore.send(.userTypeTapped(.child))
                    }, label: {
                        Text("아이")
                            .selectableButton(viewStore.userType == .child ? .constant(true) : .constant(false))
                    })
                }
            }
            .padding(.horizontal, 30)
        }
    }
}

//#Preview {
//    UserTypeView(userType: .child, page: .constant(0))
//}
