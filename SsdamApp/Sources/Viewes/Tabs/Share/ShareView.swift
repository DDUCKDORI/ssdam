//
//  ShareView.swift
//  Ssdam
//
//  Created by 김재민 on 1/10/24.
//  Copyright © 2024 com.dduckdori. All rights reserved.
//

import SwiftUI
import ComposableArchitecture
import Domain
import Utils

struct ShareReducer: Reducer {
    @Dependency(\.screenRouter) var screenRouter
    @Dependency(\.authUseCase) var authUseCase
    struct State: Equatable {
        var code: String = ""
        var isValid: Bool = false
        var toastState: ToastReducer.State = .init()
        var NumberOfFamily: String = ""
    }
    
    enum Action: Equatable {
        case codeChanged(String)
        case codeValidation(String)
        case settingTapped
        case toast(ToastReducer.Action)
        case fetchNumberOfFamily(String)
        case fetchNumberOfFamilyResponse(TaskResult<NumberOfFamilyEntity>)
    }
    
    var body: some ReducerOf<Self> {
        Scope(state: \.toastState, action: /Action.toast) {
            ToastReducer()
        }
        Reduce { state, action in
            switch action {
            case let .codeChanged(newValue):
                state.code = newValue
                return .none
            case let .codeValidation(newValue):
                if newValue.count > 10 {
                    state.code.removeLast()
                    return .none
                }
                if newValue.count > 1 {
                    state.isValid = true
                    return .send(.toast(.toastPresented(.presented(true))))
                }
                state.isValid = false
                return .none
            case .settingTapped:
                screenRouter.routeTo(.setting)
                return .none
            case .toast(.toastPresented(.presented(_))):
                state.toastState.isPresented?.wrappedValue = true
                return .none
            case .toast(.toastPresented(.dismiss)):
                return .none
            case let .fetchNumberOfFamily(code):
                return .run { send in
                    let result = await TaskResult {
                        let data = await authUseCase.fetchNumberOfFamily(code: code)
                        return data
                    }
                    await send(.fetchNumberOfFamilyResponse(result))
                }
            case let .fetchNumberOfFamilyResponse(.success(entity)):
                state.NumberOfFamily = entity.count
                return .none
            case let .fetchNumberOfFamilyResponse(.failure(error)):
                print(error.localizedDescription)
                return .none
            }
        }
    }
}

struct ShareView: View {
    let store: StoreOf<ShareReducer>
    var body: some View {
        WithViewStore(self.store, observe: { $0 }) { viewStore in
            VStack {
                Text(Const.nickname.withAttributed(.pHeadline2))
                    .font(.pHeadline2)
                    .padding(.bottom, 92)
                
                ZStack {
                    Image(.ssmee)
                        .offset(y: -60)
                    VStack(spacing: 5) {
                        Text("연결된 가족")
                            .font(.pBody2)
                        Text("\(viewStore.NumberOfFamily)명")
                            .font(.pHeadline2)
                    }
                    .padding(.vertical, 36)
                    .frame(maxWidth: .infinity)
                    .background(Color(.gray10))
                    .cornerRadius(10)
                }
                
                ZStack(alignment: .trailing) {
                    TextField("초대코드 입력하기", text: viewStore.binding(get: \.code, send: { value in
                            .codeChanged(value)
                    }))
                    .font(.pButton)
                    .foregroundStyle(Color(.systemBlack))
                    .padding(.vertical, 16)
                    .multilineTextAlignment(.center)
                    .overlay(RoundedRectangle(cornerRadius: 10).stroke(Color(.mint50), lineWidth: 2))
                    .onChange(of: viewStore.code){ _, newValue in
                        viewStore.send(.codeValidation(newValue))
                        
                    }
                    if viewStore.isValid {
                        Image(.checkmarkCircleMint)
                            .padding(.vertical, 16)
                            .padding(.horizontal, 24)
                    }
                }
                Text("*인증코드를 다시 확인해주세요")
                    .font(.pCaption)
                    .foregroundStyle(Color(.systemRed))
                    .padding(.vertical, 12)
                    .opacity(viewStore.code.count > 0 && !viewStore.isValid ? 1 : 0)
                
                ShareLink(item: viewStore.code) {
                    Text("내 초대코드 복사하기")
                        .font(.pBody)
                        .underline()
                        .foregroundStyle(Color(.gray80))
                }
                .padding(.top, 21)
            }
            .padding(.horizontal, 30)
            .toolbar(content: {
                ToolbarItem(placement: .navigationBarLeading) {
                    Image(.logo)
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: {
                        viewStore.send(.settingTapped)
                    }, label: {
                        Image(.setting)
                    })
                }
            })
            .onAppear {
                viewStore.send(.fetchNumberOfFamily(Const.inviteCd))
            }
            .toast(self.store.scope(state: \.toastState, action: ShareReducer.Action.toast)) {
                Text("가족 연결이 완료되었습니다 🎉")
                    .foregroundStyle(Color.white)
                    .padding(.vertical, 17)
                    .frame(maxWidth: .infinity)
                    .background(Color.black)
                    .clipShape(RoundedRectangle(cornerRadius: 10))
                    .padding(.horizontal, 30)
            }
        }
        
    }
}

#Preview {
    ShareView(store: .init(initialState: ShareReducer.State(), reducer: {
        ShareReducer()
    }))
}
