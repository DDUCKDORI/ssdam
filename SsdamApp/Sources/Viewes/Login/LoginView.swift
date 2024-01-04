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
    @Dependency(\.authUseCase) var authUseCase
    struct State: Equatable {
        var tokenInfo: TokenPayload = .init()
    }
    
    enum Action: Equatable {
        case login(String, String)
        case loginResponse(TaskResult<TokenEntity>)
    }
    
    var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case let .login(code, token):
                return .run { send in
                    let result = await TaskResult{
                        let data = await authUseCase.issueAccessToken(code, token)
                        return data
                    }
                    await send(.loginResponse(result))
                }
            case .loginResponse(.success(let entity)):
                state.tokenInfo = TokenPayload(entity)
                return .none
            case .loginResponse(.failure(_)):
                return .none
            }
        }
    }
}

struct LoginView: View {
    @EnvironmentObject var screenRouter: ScreenRouter
    let store: StoreOf<LoginReducer>
    var body: some View {
        WithViewStore(self.store, observe: { $0 }) { viewStore in
            ZStack {
                Image(.tileMint)
                    .resizable(resizingMode: .tile)
                    .ignoresSafeArea()
                VStack {
                    Spacer()
                    Image(.characters)
                    Spacer()
                    SignInWithAppleButton(.signIn) { request in
                        request.requestedScopes = [.email]
                    } onCompletion: { result in
                        switch result {
                        case let .success(authResults):
                            switch authResults.credential{
                            case let appleIDCredential as ASAuthorizationAppleIDCredential:
                                let UserIdentifier = appleIDCredential.user
                                let email = appleIDCredential.email
                                let identityToken = String(data: appleIDCredential.identityToken!, encoding: .utf8)
                                let authorizationCode = String(data: appleIDCredential.authorizationCode!, encoding: .utf8)
                                
                                guard let code = authorizationCode, let token = identityToken else { return }
                                viewStore.send(.login(code, token))
                                
                            default:
                                break
                            }
//                            if viewStore.tokenInfo.isUser == "yes" {
//                                Const.accessToken = viewStore.tokenInfo.accessToken
//                                Const.refreshToken = viewStore.tokenInfo.refreshToken
                                screenRouter.change(.signUp)
//                            }
//                            else {
//                                screenRouter.change(.signUp)
//                            }
                        case let .failure(error):
                            print(error.localizedDescription)
                            print(error)
                        }
                    }
                    .frame(height: 56)
                    .padding(.bottom, 112)
                    .padding(.horizontal, 30)
                }
            }
        }
    }
}

//#Preview {
//    LoginView()
//}
