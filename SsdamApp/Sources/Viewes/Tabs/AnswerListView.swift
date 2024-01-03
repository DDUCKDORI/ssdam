//
//  AnswerListView.swift
//  Ssdam
//
//  Created by 김재민 on 2024/01/03.
//  Copyright © 2024 com.dduckdori. All rights reserved.
//

import SwiftUI
import ComposableArchitecture

struct AnswerListReducer: Reducer {
    struct State: Equatable {
        var isExpended: Bool = false
    }
    
    enum Action: Equatable {
        case showDetails
    }
    
    var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case .showDetails:
                state.isExpended.toggle()
                return .none
            }
        }
    }
}

struct AnswerListView: View {
    let store: StoreOf<AnswerListReducer>
    
    var body: some View {
        WithViewStore(self.store, observe: { $0 }) { viewStore in
            ZStack {
                Image(.tileYellow)
                    .resizable(resizingMode: .tile)
                ScrollView(showsIndicators: false) {
                    VStack(spacing: 0) {
                        Text("2023.12.12")
                            .ssdamLabel()
                            .padding(.bottom, 19)
                        Text("오늘부터 쓰담하며\n우리 가족의 목표는 무엇인가요?")
                            .font(.pHeadline2)
                            .multilineTextAlignment(.center)
                            .padding(.bottom, 26)
                        
                        VStack(spacing: 16) {
                            VStack(spacing: 0) {
                                HStack {
                                    Text("나의 답변")
                                        .font(.pButton4)
                                    Spacer()
                                    HStack(spacing: 10) {
                                        Text("2023.12.10")
                                            .font(.pBody2)
                                            .foregroundStyle(Color(.gray60))
                                        Image(.checkmarkCircleMint)
                                    }
                                }
                                .padding(.horizontal, 24)
                                .padding(.vertical, 17)
                                .background(Color(.mint20))
                                .overlay(RoundedCorner(radius: 10, corners: viewStore.isExpended ? [.topLeft, .topRight] : .allCorners)
                                    .stroke(Color(.mint50), lineWidth: 2)
                                )
                                .onTapGesture {
                                    viewStore.send(.showDetails)
                                }
                                if viewStore.isExpended {
                                    Text("하루도 빠지지 않고 쓰담 기록하기")
                                        .font(.pBody)
                                        .padding(.vertical, 48)
                                        .padding(.horizontal, 52)
                                        .frame(maxWidth: .infinity)
                                        .background(Color.white)
                                        .overlay(RoundedCorner(radius: 10, corners: [.bottomLeft, .bottomRight])
                                            .stroke(Color(.mint50), lineWidth: 2)
                                        )
                                        .transition(.move(edge: .top))
                                }
                            }
                            HStack {
                                Text("전주이씨 답변")
                                    .font(.pButton4)
                                    .foregroundStyle(Color(.gray20))
                                Spacer()
                                Image(.checkmarkCircle)
                            }
                            .padding(.horizontal, 24)
                            .padding(.vertical, 17)
                            .background(Color(.gray10))
                            .overlay(RoundedRectangle(cornerRadius: 10)
                                .stroke(Color(.gray20), lineWidth: 2)
                            )
                        }
                        .padding(.horizontal, 30)
                    }
                }
                .padding(.top, 142)
            }
            .ignoresSafeArea()
            .safeAreaInset(edge: .top) {
                HeaderView(store: .init(initialState: HeaderReducer.State(), reducer: {
                    HeaderReducer()
                }))
            }
        }
    }
}

#Preview {
    AnswerListView(store: .init(initialState: AnswerListReducer.State(), reducer: {
        AnswerListReducer()
    }))
}
