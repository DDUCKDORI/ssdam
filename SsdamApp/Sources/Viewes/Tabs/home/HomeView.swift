//
//  HomeView.swift
//  Ssdam
//
//  Created by 김재민 on 2023/12/20.
//  Copyright © 2023 com.dduckdori. All rights reserved.
//

import Foundation
import SwiftUI
import ComposableArchitecture

enum HomeViewType {
    case question
    case list
}

struct HomeReducer: Reducer {
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

struct HomeView: View {
    @EnvironmentObject var screenRouter: ScreenRouter
    @State var viewType: HomeViewType = .question
    let store: StoreOf<HomeReducer>
    var body: some View {
        WithViewStore(self.store, observe: { $0 }) { viewStore in
            ZStack {
                if viewType == .question {
                    MainQuestionView()
                    
                } else {
                    AnswerListView(store: .init(initialState: AnswerListReducer.State(), reducer: {
                        AnswerListReducer()
                    }))
                }
            }
            .ignoresSafeArea()
            .safeAreaInset(edge: .top) {
                HeaderView(store: .init(initialState: HeaderReducer.State(), reducer: {
                    HeaderReducer()
                }))
            }
        }
    }
    
    @ViewBuilder
    private func MainQuestionView() -> some View {
        ZStack {
            Image(.tileMint)
                .resizable(resizingMode: .tile)
            VStack(spacing: 0) {
                Text("NEW")
                    .ssdamLabel()
                    .padding(.bottom, 12)
                
                Text("오늘부터 쓰담하며\n우리 가족의 목표는 무엇인가요?")
                    .font(.pHeadline2)
                    .multilineTextAlignment(.center)
                    .padding(.bottom, 30)
                
                Image(.characterMain)
                    .padding(.bottom, 12)
                    .onTapGesture {
                        screenRouter.presentFullScreen(.write($viewType))
                    }
            }
        }
    }
}

#Preview {
    HomeView(store: .init(initialState: HomeReducer.State(), reducer: {
        HomeReducer()
    }))
}
