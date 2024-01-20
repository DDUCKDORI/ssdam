//
//  LoginView.swift
//  Ssdam
//
//  Created by 김재민 on 2023/11/22.
//  Copyright © 2023 com.dduckdori. All rights reserved.
//

import SwiftUI
import AuthenticationServices
import ComposableArchitecture
import Domain
import Utils

struct LoginReducer: Reducer {
    @Dependency(\.screenRouter) var screenRouter
    @Dependency(\.authUseCase) var authUseCase
    struct State: Equatable {
        var tokenInfo: TokenPayload = .init()
    }
    
    enum Action: Equatable {
        case issueToken(String, String)
        case issueTokenResponse(TaskResult<TokenEntity>)
        case navigate
        case routeToHome
        case routeToSignup
        case setAuthorization
    }
    
    var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case let .issueToken(code, token):
                return .run { send in
                    let result = await TaskResult{
                        let data = await authUseCase.issueAccessToken(code, token)
                        return data
                    }
                    await send(.issueTokenResponse(result))
                }
            case let .issueTokenResponse(.success(entity)):
                state.tokenInfo = TokenPayload(entity)
                
                Const.accessToken = state.tokenInfo.accessToken
                Const.refreshToken = state.tokenInfo.refreshToken
                Const.isUser = state.tokenInfo.isUser
                Const.nickname = state.tokenInfo.nickname ?? ""
                Const.inviteCd = state.tokenInfo.inviteCd ?? ""
                Const.email = state.tokenInfo.email ?? ""
                Const.userType = state.tokenInfo.fmDvcd ?? ""
                Const.memId = state.tokenInfo.memId
                Const.memSub = state.tokenInfo.memSub
                
                return .send(.navigate)
            case let .issueTokenResponse(.failure(error)):
                print(error.localizedDescription)
                return .none
            case .navigate:
                if state.tokenInfo.isUser == "yes" {
                    return .send(.routeToHome)
                }
                return .send(.routeToSignup)
            case .routeToHome:
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                    screenRouter.change(root: .home)
                }
                return .none
            case .routeToSignup:
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                    screenRouter.change(root: .signUp)
                }
                return .none
            case .setAuthorization:
//                LocalNotificationHelper.shared.setAuthorization()
                return .none
            }
            
        }
    }
}

struct LoginView: View {
    let store: StoreOf<LoginReducer>
    var body: some View {
        WithViewStore(self.store, observe: { $0 }) { viewStore in
            ZStack {
                Image(.tileMint)
                    .resizable(resizingMode: .tile)
                Image(.charactersSilhouette)
                    .offset(y: -60)
                SignInWithAppleButton(.signIn) { request in
                    request.requestedScopes = [.email]
                } onCompletion: { result in
                    switch result {
                    case let .success(authResults):
                        switch authResults.credential{
                        case let appleIDCredential as ASAuthorizationAppleIDCredential:
                            //                            let UserIdentifier = appleIDCredential.user
                            let email = appleIDCredential.email
                            let identityToken = String(data: appleIDCredential.identityToken!, encoding: .utf8)
                            let authorizationCode = String(data: appleIDCredential.authorizationCode!, encoding: .utf8)
                            
                            guard let code = authorizationCode, let token = identityToken else { return }
                            print(code, token)
                            viewStore.send(.issueToken(code, token))
                            
                            break
                            
                        default:
                            break
                        }
                        
                    case let .failure(error):
                        print(error.localizedDescription)
                        print(error)
                    }
                }
                .frame(height: 56)
                .padding(.horizontal, 30)
                .offset(y: 238)
            }
            .ignoresSafeArea()
            .onAppear {
                viewStore.send(.setAuthorization)
            }
        }
    }
}

#Preview {
    LoginView(store: .init(initialState: LoginReducer.State(), reducer: {
        LoginReducer()
    }))
}
