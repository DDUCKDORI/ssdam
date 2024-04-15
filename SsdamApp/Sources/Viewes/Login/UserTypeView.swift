//
//  UserTypeView.swift
//  Ssdam
//
//  Created by 김재민 on 2023/11/16.
//  Copyright © 2023 com.dduckdori. All rights reserved.
//

import SwiftUI
import ComposableArchitecture
import Utils

enum UserType {
    case parent
    case child
}

@Reducer
struct UserTypeReducer {
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
                
                // todo :: navigate after button color changed
                HStack {
                    Button(action: {
                        Const.userType = "01"
                        viewStore.send(.userTypeTapped(.parent))
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.25) {
                            page = 1
                        }

                    }, label: {
                        Text("부모")
                            .selectableButton(viewStore.userType == .parent ? .constant(true) : .constant(false))
                    })
                    Button(action: {
                        Const.userType = "02"
                        viewStore.send(.userTypeTapped(.child))
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.25) {
                            page = 1
                        }

                    }, label: {
                        Text("아이")
                            .selectableButton(viewStore.userType == .child ? .constant(true) : .constant(false))
                    })
                }
            }
            .padding(.horizontal, 30)
            Spacer()
        }
    }
}

//#Preview {
//    UserTypeView(userType: .child, page: .constant(0))
//}
