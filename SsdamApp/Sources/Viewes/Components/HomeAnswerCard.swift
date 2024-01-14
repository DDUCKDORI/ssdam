//
//  HomeAnswerCard.swift
//  Ssdam
//
//  Created by 김재민 on 1/14/24.
//  Copyright © 2024 com.dduckdori. All rights reserved.
//

import SwiftUI
import ComposableArchitecture

struct HomeAnswerCardReducer: Reducer {
    struct State: Equatable {
        var isExpanded: Bool = false
        var payloads: [FetchAnswerPayload] = []
    }
    
    enum Action: Equatable {
        case expand
        case editAnswer
    }
    
    var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case .expand:
                state.isExpanded.toggle()
                return .none
            case .editAnswer:
                return .none
            }
        }
    }
}

struct HomeAnswerCard: View {
    let store: StoreOf<HomeAnswerCardReducer>
    var body: some View {
        WithViewStore(self.store, observe: { $0 }) { viewStore in
            ForEach(viewStore.payloads, id: \.self) { payload in
                VStack(spacing: 0) {
                    HStack {
                        Text("\(payload.memberId)의 답변")
                            .font(.pButton4)
                        Spacer()
                        HStack(spacing: 10) {
                            Text(!payload.answer.isEmpty ? "2023.12.10" : "")
                                .font(.pBody2)
                                .foregroundStyle(Color(.gray60))
                            Image(!payload.answer.isEmpty ? .checkmarkCircleMint : .checkmarkCircle)
                        }
                    }
                    .padding(.horizontal, 24)
                    .padding(.vertical, 17)
                    .background(!payload.answer.isEmpty ? Color(.mint20) : Color(.gray10))
                    .overlay(RoundedCorner(radius: 10, corners: viewStore.isExpanded ? [.topLeft, .topRight] : .allCorners)
                        .stroke(!payload.answer.isEmpty ? Color(.mint50) : Color(.gray20), lineWidth: 2)
                    )
                    
                    .onTapGesture {
                        if !payload.answer.isEmpty {
                            viewStore.send(.expand)
                        }
                    }
                    if viewStore.isExpanded {
                        Text(payload.answer)
                            .font(.pBody)
                            .padding(.vertical, 48)
                            .padding(.horizontal, 52)
                            .frame(maxWidth: .infinity)
                            .background(Color.white)
                            .overlay(RoundedCorner(radius: 10, corners: [.bottomLeft, .bottomRight])
                                .stroke(Color(.mint50), lineWidth: 2)
                            )
                            .transition(.move(edge: .top))
                            .onTapGesture {
                                viewStore.send(.editAnswer)
                            }
                    }
                }
            }
        }
    }
}

//#Preview {
//    HomeAnswerCard()
//}
