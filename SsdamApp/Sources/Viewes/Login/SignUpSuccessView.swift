//
//  SignUpSuccessView.swift
//  Ssdam
//
//  Created by 김재민 on 2023/12/03.
//  Copyright © 2023 com.dduckdori. All rights reserved.
//

import SwiftUI
import ComposableArchitecture

@Reducer
struct SignUpSuccessReducer {
    @Dependency(\.screenRouter) var screenRouter
    struct State: Equatable {
        var titles: [String] = [
            "",
            "이제부터 가족과 질문에\n대한 생각을 기록할 수 있어요",
            "답변을 완료하면 매일 아침\n9시에 새로운 질문이 도착해요",
            "소중한 우리 가족의 기록을\n지금 남겨보세요 :)"
        ]
        var images: [ImageResource] = [.guide1, .guide2, .guide3, .guide4]
        var currentPage: Int = 0
        var nickname: String
        var welcomeMessage: AttributedString {
            var text: AttributedString = AttributedString(stringLiteral: "\(nickname)님 환영합니다")
            let nicknameRange = text.range(of: "\(nickname)")!
            let messageRange = text.range(of: "님 환영합니다")!
            text[nicknameRange].font = .pHeadline2
            text[messageRange].font = .pHeadline2
            
            text[nicknameRange].foregroundColor = Color(.mint50)
            text[messageRange].foregroundColor = Color(.systemBlack)
            
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
                if state.currentPage < 3 {
                    state.currentPage += 1
                    return .none
                }
                screenRouter.change(root: .home)
                return .none
            }
        }
    }
}

struct SignUpSuccessView: View {
    let store: StoreOf<SignUpSuccessReducer>
    var body: some View {
        WithViewStore(self.store, observe:  { $0 } ) { viewStore in
            ZStack {
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
                            .multilineTextAlignment(.center)
                    }
                }
                .offset(y: -205)
                
                PageControl(numberOfPages: viewStore.images.count, currentPage: viewStore.binding(get: \.currentPage, send: { value in
                    .pageChanged(value) }))
                .offset(y: 197)
                
                Button(action: {
                    store.send(.tapNextButton)
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
                .offset(y: 265)
            }
        }
    }
}

#Preview {
    SignUpSuccessView(store: .init(initialState: SignUpSuccessReducer.State(nickname: "jimmy"), reducer: {
        SignUpSuccessReducer()
    }))
}
