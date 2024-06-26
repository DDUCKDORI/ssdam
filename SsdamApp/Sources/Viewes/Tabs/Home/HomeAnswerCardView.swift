//
//  HomeAnswerCard.swift
//  Ssdam
//
//  Created by 김재민 on 1/14/24.
//  Copyright © 2024 com.dduckdori. All rights reserved.
//

import SwiftUI
import ComposableArchitecture
import Utils

@Reducer
struct HomeAnswerCardReducer {
    struct State: Equatable {
        var payloads: [FetchAnswerPayload] = []
        var expands: [Bool] = []
    }
    
    enum Action: Equatable {
        case expand(Int)
        case editAnswer
    }
    
    var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case let .expand(index):
                state.expands[index].toggle()
                return .none
            case .editAnswer:
                return .none
            }
        }
    }
}

struct HomeAnswerCardView: View {
    let store: StoreOf<HomeAnswerCardReducer>
    var body: some View {
        WithViewStore(self.store, observe: { $0 }) { viewStore in
            ForEach(0 ..< viewStore.payloads.count, id: \.self) { index in
                VStack(spacing: 0) {
                    HStack {
                        Text("\(viewStore.payloads[index].nickname.withAttributed())의 답변")
                            .font(.pButton4)
                        Spacer()
                        HStack(spacing: 10) {
                            Text(!viewStore.payloads[index].answer.isEmpty ? viewStore.payloads[index].createdAt.convertToDotFormat(.dot) : "")
                                .font(.pBody2)
                                .foregroundStyle(Color(.gray60))
                            Image(!viewStore.payloads[index].answer.isEmpty ? .checkmarkCircleMint : .checkmarkCircle)
                        }
                    }
                    .padding(.horizontal, 24)
                    .padding(.vertical, 17)
                    .background(!viewStore.payloads[index].answer.isEmpty ? Color(.mint20) : Color(.gray10))
                    .overlay(RoundedCorner(radius: 10, corners: viewStore.expands[index] ? [.topLeft, .topRight] : .allCorners)
                        .stroke(!viewStore.payloads[index].answer.isEmpty ? Color(.mint50) : Color(.gray20), lineWidth: 2)
                    )
                    
                    .onTapGesture {
                        if !viewStore.payloads[index].answer.isEmpty {
                            viewStore.send(.expand(index))
                        }
                    }
                    if viewStore.expands[index] == true {
                        Text(viewStore.payloads[index].answer)
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
                                if viewStore.payloads[index].memberId == Const.memId {
                                    viewStore.send(.editAnswer)
                                }
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
