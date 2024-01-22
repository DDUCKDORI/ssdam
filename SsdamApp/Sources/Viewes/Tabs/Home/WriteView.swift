//
//  WriteView.swift
//  Ssdam
//
//  Created by 김재민 on 2023/12/21.
//  Copyright © 2023 com.dduckdori. All rights reserved.
//

import SwiftUI
import ComposableArchitecture
import Domain
import Networking

struct WriteReducer: Reducer {
    @Dependency(\.screenRouter) var screenRouter
    struct State: Equatable {
        var question: String = ""
        var text: String = ""
        var date: String = ""
        @BindingState var focusedField: Bool = false
    }
    
    enum Action: BindableAction, Equatable {
        case textChanged(String)
        case textValidation(String)
        case answerButtonTapped
        case binding(BindingAction<State>)
    }
    
    var body: some ReducerOf<Self> {
        BindingReducer()
        Reduce { state, action in
            switch action {
            case let .textChanged(text):
                state.text = text
                return .none
            case let .textValidation(text):
                if isOnlyWhitespaceAndLineBreaks(text) {
                    state.text = ""
                }
                if text.count > 50 {
                    state.text = String(state.text.prefix(50))
                }
                return .none
            case .answerButtonTapped:
                return .none
            case .binding:
                return .none
            }
        }
    }
    
    private func isOnlyWhitespaceAndLineBreaks(_ text: String) -> Bool {
        return text.allSatisfy { $0.isWhitespace || $0.isNewline }
    }
}


struct WriteView: View {
    let store: StoreOf<WriteReducer>
    @FocusState var focusedField: Bool
    var body: some View {
        WithViewStore(self.store, observe: { $0 }) { viewStore in
            ZStack {
                Image(.tileMint)
                    .resizable(resizingMode: .tile)
                VStack(spacing: 0) {
                    Text(viewStore.date.convertToDotFormat(.dot))
                        .ssdamLabel()
                        .padding(.bottom, 19)
                    Text(viewStore.question)
                        .font(.pHeadline2)
                        .multilineTextAlignment(.center)
                        .padding(.bottom, 28)
                    
                    TextField("1~50자 이내 작성", text: viewStore.binding(get: \.text, send: { value in
                            .textChanged(value)
                    }), axis: .vertical)
                    .font(.pBody)
                    .padding(.horizontal, 52)
                    .padding(.vertical, 94)
                    .background()
                    .clipShape(RoundedRectangle(cornerRadius: 20))
                    .overlay( RoundedRectangle(cornerRadius: 20) .stroke(Color(.mint50), lineWidth: 2))
                    .padding(.horizontal, 30)
                    .multilineTextAlignment(.center)
                    .padding(.bottom, 28)
                    .focused($focusedField)
                    .onChange(of: viewStore.text){ newValue in
                        viewStore.send(.textValidation(newValue))
                    }
                    .bind(viewStore.$focusedField, to: self.$focusedField)
                    
                    Button(action: {
                            viewStore.send(.answerButtonTapped)
                    }, label: {
                        Text("답변하기")
                            .font(.pButton)
                            .foregroundStyle(viewStore.text.isEmpty ? Color(.gray20) : .white)
                            .padding(.vertical, 16)
                            .frame(maxWidth: .infinity)
                            .background(viewStore.text.isEmpty ? Color(.gray10) : Color(.mint50))
                            .clipShape(RoundedRectangle(cornerRadius: 100))
                            .padding(.horizontal, 80)
                    })
                    .disabled(viewStore.text.isEmpty ? true : false)
                    
                    Spacer()
                }
                .padding(.top, 142)
            }
            .ignoresSafeArea()
            .onTapGesture {
                self.focusedField = false
            }
        }
    }
}

#Preview {
    WriteView(store: .init(initialState: WriteReducer.State(), reducer: {
        WriteReducer()
    }))
}
