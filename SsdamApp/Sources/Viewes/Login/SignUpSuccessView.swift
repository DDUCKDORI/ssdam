//
//  SignUpSuccessView.swift
//  Ssdam
//
//  Created by 김재민 on 2023/12/03.
//  Copyright © 2023 com.dduckdori. All rights reserved.
//

import SwiftUI
import ComposableArchitecture

struct SignUpSuccessReducer: Reducer {
    
    struct State: Equatable {
        var titles: [String] = [
            "",
            "이제부터 가족과 질문에\n대한 생각을 기록할 수 있어요",
            "답변을 완료하면 매일 아침\n9시에 새로운 질문이 도착해요",
            "소중한 우리 가족의 기록을 지금 남겨보세요 :)"
        ]
        var images: [ImageResource] = [.guide1, .guide2, .guide3, .guide4]
        var currentPage: Int = 0
        var nickname: String
        var welcomeMessage: AttributedString {
            var text: AttributedString = AttributedString(stringLiteral: "\(nickname)님 환영합니다")
            let nicknameRange = text.range(of: "\(nickname)")!
            text[nicknameRange].font = .pHeadline2
            text[nicknameRange].foregroundColor = Color(.mint50)
            
            return text
        }
    }
    
    enum Action: Equatable {
        case pageChanged(Int)
        case tapNextButton
    }
    
    var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case let .pageChanged(page):
                state.currentPage = page
                return .none
            case .tapNextButton:
                state.currentPage += 1
                return .none
            }
        }
    }
}

struct SignUpSuccessView: View {
    @EnvironmentObject var screenRouter: ScreenRouter
    let store: StoreOf<SignUpSuccessReducer>
    var body: some View {
        WithViewStore(self.store, observe:  { $0 } ) { viewStore in
            ZStack {
                Color(.yellow50)
                    .ignoresSafeArea()
                PageViewController(pages: viewStore.images.map { Image($0) }, currentPage: viewStore.binding(get: \.currentPage, send: { value in
                        .pageChanged(value)
                }))
                Group {
                    if viewStore.currentPage == 0 {
                        Text(viewStore.welcomeMessage)
                    }
                    else {
                        Text(viewStore.titles[viewStore.currentPage])
                            .font(.pHeadline2)
                    }
                }
                .offset(y: -228)
                
                PageControl(numberOfPages: viewStore.images.count, currentPage: viewStore.binding(get: \.currentPage, send: { value in
                    .pageChanged(value) }))
                .offset(y: 210)
                
                Button(action: {
                    if viewStore.currentPage < 3 { 
                        store.send(.tapNextButton)
                        return
                    }
                    screenRouter.change(.home)
                }, label: {
                    Text(viewStore.currentPage < 3 ? "다음" : "시작하기")
                        .font(.pButton)
                        .foregroundStyle(.white)
                        .padding(.vertical, 16)
                        .frame(maxWidth: .infinity)
                        .background(Color(.mint50))
                        .clipShape(RoundedRectangle(cornerRadius: 100))
                        .padding(.horizontal, 80)
                })
                .offset(y: 280)
            }
        }
    }
}

#Preview {
    SignUpSuccessView(store: .init(initialState: SignUpSuccessReducer.State(nickname: "jimmy"), reducer: {
        SignUpSuccessReducer()
    }))
}
