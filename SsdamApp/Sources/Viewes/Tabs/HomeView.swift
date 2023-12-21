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
    let store: StoreOf<HomeReducer>
    var body: some View {
        WithViewStore(self.store, observe: { $0 }) { viewStore in
            ZStack {
                Image(.tileMint)
                    .resizable(resizingMode: .tile)
                VStack {
                    Text("NEW")
                        .ssdamLabel()
                        .padding(.bottom, 12)

                    Text("오늘부터 쓰담하며\n우리 가족의 목표는 무엇인가요?")
                        .font(.pHeadline2)
                        .multilineTextAlignment(.center)
                        .padding(.bottom, 30)
                    
                    Image(.characterMain)
                        .padding(.bottom, 12)
                    
                    Text("클릭 후 답변을 작성해주세요")
                        .font(.pCaption)
                        .foregroundStyle(Color(.mint50))
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
}

#Preview {
    HomeView(store: .init(initialState: HomeReducer.State(), reducer: {
        HomeReducer()
    }))
}
