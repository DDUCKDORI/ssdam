//
//  WriteView.swift
//  Ssdam
//
//  Created by 김재민 on 2023/12/21.
//  Copyright © 2023 com.dduckdori. All rights reserved.
//

import SwiftUI
import ComposableArchitecture

struct WriteReducer: Reducer {
    struct State: Equatable {
        var text: String = ""
    }
    
    enum Action: Equatable {
        case textChanged(String)
        case textValidation(String)
    }
    
    var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case let .textChanged(text):
                state.text = text
                return .none
            case let .textValidation(text):
                if text.count > 50 {
                    state.text.removeLast()
                }
                return .none
            default:
                return .none
            }
        }
    }
}


struct WriteView: View {
    @EnvironmentObject var screenRouter: ScreenRouter
    @Binding var viewType: HomeViewType
    let store: StoreOf<WriteReducer>
    var body: some View {
        WithViewStore(self.store, observe: { $0 }) { viewStore in
            ZStack {
                Image(.tileYellow)
                    .resizable(resizingMode: .tile)
                VStack(spacing: 0) {
                    Text("2023.12.12")
                        .ssdamLabel()
                        .padding(.bottom, 19)
                    Text("오늘부터 쓰담하며\n우리 가족의 목표는 무엇인가요?")
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
                    .onChange(of: viewStore.text){ _, newValue in
                        viewStore.send(.textValidation(newValue))
                    }
                    
                    Button(action: {
                        viewType = .list
                        screenRouter.dismissLast()
                    }, label: {
                        Text("답변하기")
                            .font(.pButton)
                            .foregroundStyle(.white)
                            .padding(.vertical, 16)
                            .frame(maxWidth: .infinity)
                            .background(Color(.mint50))
                            .clipShape(RoundedRectangle(cornerRadius: 100))
                            .padding(.horizontal, 80)
                    })
                    
                    Spacer()
                }
                .padding(.top, 142)
            }
            .ignoresSafeArea()
        }
    }
}

#Preview {
    WriteView(viewType: .constant(.question), store: .init(initialState: WriteReducer.State(), reducer: {
        WriteReducer()
    }))
}
