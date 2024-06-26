//
//  NicknameView.swift
//  Ssdam
//
//  Created by 김재민 on 2023/11/18.
//  Copyright © 2023 com.dduckdori. All rights reserved.
//

import SwiftUI
import ComposableArchitecture
import Domain
import Utils

@Reducer
struct NicknameReducer {
    @Dependency(\.screenRouter) var screenRouter
    @Dependency(\.authUseCase) var authUseCase
    struct State: Equatable {
        var nickname: String = ""
        var isValid: Bool = false
        var serviceAgreement: Bool = false
        var privacyAgreement: Bool = false
        @PresentationState var sheet: PresentationState<SheetType>?
        @BindingState var focusedField: Bool = false
    }
    
    enum Action: BindableAction {
        case nicknameChanged(String)
        case nicknameValidation(String)
        case agreeAllToggled(Bool)
        case serviceAgreementToggled(Bool)
        case privacyAgreementToggled(Bool)
        case login([String: String])
        case loginResponse(Result<TokenEntity, Error>)
        case sheet(PresentationAction<SheetType>)
        case binding(BindingAction<State>)
    }
    
    var body: some ReducerOf<Self> {
        BindingReducer()
        Reduce { state, action in
            switch action {
            case let .nicknameChanged(newValue):
                state.nickname = newValue
                return .none
            case let .nicknameValidation(newValue):
                if newValue.count > 10 {
                    state.nickname.removeLast()
                    return .none
                }
                if newValue.count > 1 {
                    state.isValid = true
                    return .none
                }
                state.isValid = false
                return .none
            case let .agreeAllToggled(isOn):
                state.serviceAgreement = isOn
                state.privacyAgreement = isOn
                return .none
            case let .serviceAgreementToggled(isOn):
                state.serviceAgreement = isOn
                return .none
            case let .privacyAgreementToggled(isOn):
                state.privacyAgreement = isOn
                return .none
            case let .login(body):
                return .run { send in
                    let result = await Result {
                        let data = await authUseCase.login(tokenInfo: body)
                        return data
                    }
                    await send(.loginResponse(result))
                }
            case let .loginResponse(.success(entity)):
                Const.nickname = state.nickname
                Const.inviteCd = entity.inviteCd
                Const.memId = entity.memId
                screenRouter.routeTo(.signUpSuccess(state.nickname))
                return .none
            case .loginResponse(.failure(_)):
                return .none
            case let .sheet(.presented(type)):
                state.sheet = PresentationState(wrappedValue: type)
                return .none
            case .sheet(.dismiss):
                state.sheet = nil
                return .none
            case .binding:
                return .none
            }
        }
    }
}

struct NicknameView: View {
    let store: StoreOf<NicknameReducer>
    @FocusState var focusedField: Bool
    
    var body: some View {
        WithViewStore(self.store, observe: { $0 }) { viewStore in
            ZStack(alignment: .top) {
                Color.white
                VStack(spacing: 16) {
                    viewStore.isValid ?
                    Text("멋진 닉네임이네요 :)")
                        .font(.pHeadline2)
                        .foregroundStyle(Color(.systemBlack))
                    :
                    Text("사용할 닉네임을 입력해주세요")
                        .font(.pHeadline2)
                        .foregroundStyle(Color(.systemBlack))
                    
                    ZStack(alignment: .trailing) {
                        TextField("1~10자 이내 작성", text: viewStore.binding(get: \.nickname, send: { value in
                                .nicknameChanged(value)
                        }))
                        .font(.pButton)
                        .foregroundStyle(Color(.systemBlack))
                        .padding(.vertical, 16)
                        .multilineTextAlignment(.center)
                        .overlay(RoundedRectangle(cornerRadius: 10).stroke(Color(.mint50), lineWidth: 2))
                        .focused($focusedField)
                        .onChange(of: viewStore.nickname){ newValue in
                            viewStore.send(.nicknameValidation(newValue))
                            
                        }
                        .bind(viewStore.$focusedField, to: self.$focusedField)
                        
                        if viewStore.isValid {
                            Image(.checkmarkCircleMint)
                                .padding(.vertical, 16)
                                .padding(.horizontal, 24)
                        }
                    }
                    if viewStore.nickname.count > 0, !viewStore.isValid {
                        Text("*닉네임을 다시 입력해주세요")
                            .font(.pCaption)
                            .foregroundStyle(Color(.systemRed))
                            .padding(.vertical, 12)
                    }
                    if viewStore.isValid {
                        HStack {
                            Text("모두 동의합니다")
                                .font(.pButton4)
                                .foregroundStyle(viewStore.serviceAgreement && viewStore.privacyAgreement ? Color(.systemBlack) : Color(.gray20))
                            Spacer()
                            Image(viewStore.serviceAgreement && viewStore.privacyAgreement ? .checkmarkCircleMint : .checkmarkCircle )
                        }
                        .padding(.vertical, 16)
                        .padding(.horizontal, 24)
                        .background(Color(.gray10))
                        .clipShape(RoundedRectangle(cornerRadius: 10))
                        .onTapGesture {
                            if !viewStore.serviceAgreement || !viewStore.privacyAgreement {
                                viewStore.send(.agreeAllToggled(true))
                                return
                            }
                            viewStore.send(.agreeAllToggled(false))
                        }
                        
                        HStack {
                            Text("(필수) 서비스 이용약관")
                                .font(.pBody)
                                .foregroundStyle(Color(.systemBlack))
                                .underline()
                            Spacer()
                            Image(viewStore.serviceAgreement ? .checkmarkCircleFill : .checkmarkCircle )
                                .onTapGesture {
                                    viewStore.send(.serviceAgreementToggled(viewStore.serviceAgreement))
                                }
                        }
                        .padding(.vertical, -3)
                        .padding(.horizontal, 24)
                        .onTapGesture {
                            viewStore.send(.sheet(.presented(.service)))
                        }
                        
                        HStack {
                            Text("(필수) 개인정보 처리방침")
                                .font(.pBody)
                                .foregroundStyle(Color(.systemBlack))
                                .underline()
                            Spacer()
                            Image(viewStore.privacyAgreement ? .checkmarkCircleFill : .checkmarkCircle )
                                .onTapGesture {
                                    viewStore.send(.privacyAgreementToggled(viewStore.serviceAgreement))
                                }
                        }
                        .padding(.horizontal, 24)
                        .padding(.bottom, 106)
                        .onTapGesture {
                            viewStore.send(.sheet(.presented(.privacy)))
                        }
                    }
                    
                    if viewStore.isValid, viewStore.serviceAgreement, viewStore.privacyAgreement {
                        Button {
                            viewStore.send(.login(["exists_yn" : Const.isUser,
                                                   "access_token" : Const.accessToken,
                                                   "refresh_token" : Const.refreshToken,
                                                   "invite_cd" : Const.inviteCd,
                                                   "fm_dvcd" : Const.userType,
                                                   "nick_nm" : viewStore.nickname,
                                                   "email": Const.email,
                                                   "mem_sub": Const.memSub]))
                        } label: {
                            Text("가입하기")
                                .font(.pButton2)
                                .foregroundStyle(.white)
                                .padding(.vertical, 16)
                                .padding(.horizontal, 76)
                                .background(Color(.mint50))
                                .clipShape(RoundedRectangle(cornerRadius: 100))
                        }
                    }
                }
                .padding(.horizontal, 30)
            }
            .onTapGesture {
                self.focusedField = false
            }
            .sheet(store: self.store.scope(state: \.$sheet, action: \.sheet), onDismiss: { viewStore.send(.sheet(.dismiss)) }) { store in
                switch viewStore.sheet?.wrappedValue {
                case .service:
                    WebViewRepresentable(urlString: SheetType.service.urlString)
                case .privacy:
                    WebViewRepresentable(urlString: SheetType.privacy.urlString)
                default:
                    EmptyView()
                }
            }
        }
    }
}

//#Preview {
//    NicknameView()
//}
