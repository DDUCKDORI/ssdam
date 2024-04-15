//
//  SettingView.swift
//  Ssdam
//
//  Created by 김재민 on 1/8/24.
//  Copyright © 2024 com.dduckdori. All rights reserved.
//

import SwiftUI
import ComposableArchitecture
import Utils
import Networking
import Domain
import MessageUI

enum SheetType: Equatable {
    case service
    case privacy
    case mail
    
    var urlString: String {
        switch self {
        case .service:
            return "https://www.notion.so/7e88ba8d37264bce94b29b225ae39a09?pvs=4"
        case .privacy:
            return "https://www.notion.so/ef8819a6ce3846bd8553d6464a9eda29?pvs=4"
        default:
            return ""
        }
    }
}

enum AlertActionType: Equatable {
    //    case disconnect
    case logout
    case withdraw
    case deleteUserInfo
    case issueAccessToken(String, String)
}

@Reducer
struct SettingReducer {
    @Dependency(\.screenRouter) var screenRouter
    @Dependency(\.authUseCase) var authUseCase
    struct State: Equatable {
        @PresentationState var alert: AlertState<AlertActionType>?
        @PresentationState var sheet: PresentationState<SheetType>?
        var accessToken: String = ""
    }
    
    enum Action {
        case alert(PresentationAction<AlertActionType>)
        case sheet(PresentationAction<SheetType>)
        case withdrawResponse(Result<WithdrawEntity, Error>)
        case issueAccessTokenResponse(Result<TokenEntity, Error>)
        case withdrawAction(WithdrawBody)
    }
    
    var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case let .alert(.presented(type)):
                switch type {
                    //                case .disconnect:
                    //                    state.alert = AlertState(
                    //                        title: TextState("가족 연결 해제"),
                    //                        message: TextState("모든 가족 구성원이 연결을 해제하면\n데이터가 삭제됩니다.\n연결을 해제하시겠어요?"),
                    //                        primaryButton: .default(TextState("연결 끊기"), action: .send(.none)),
                    //                        secondaryButton: .cancel(TextState("취소"))
                    //                    )
                case .logout:
                    state.alert = AlertState(
                        title: TextState("로그아웃 확인"),
                        message: TextState("로그아웃하시겠어요?"),
                        primaryButton: .default(TextState("로그아웃"), action: .send(.deleteUserInfo)),
                        secondaryButton: .cancel(TextState("취소"))
                    )
                case .withdraw:
                    state.alert = AlertState(
                        title: TextState("회원탈퇴 확인"),
                        message: TextState("회원을 탈퇴하면 모든\n데이터가 삭제됩니다.\n탈퇴하시겠어요?"),
                        primaryButton: .destructive(TextState("탈퇴하기"), action: .send(.issueAccessToken(Const.authorizationCode, Const.identityToken))),
                        secondaryButton: .cancel(TextState("취소"))
                    )
                case .deleteUserInfo:
                    UserDefaults.standard.removePersistentDomain(forName: Bundle.main.bundleIdentifier!)
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                        screenRouter.change(root: .launch)
                    }
                    return .none
                case let .issueAccessToken(code, token):
                    return .run { send in
                        let result = await Result{
                            let data = await authUseCase.issueAccessToken(code, token)
                            return data
                        }
                        await send(.issueAccessTokenResponse(result))
                    }
                    
                }
                return .none
            case .alert(.dismiss):
                state.alert = nil
                return .none
            case let .sheet(.presented(type)):
                state.sheet = PresentationState(wrappedValue: type)
                return .none
            case .sheet(.dismiss):
                state.sheet = nil
                return .none
            case let .issueAccessTokenResponse(.success(entity)):
                state.accessToken = entity.accessToken
                return .send(.withdrawAction(WithdrawBody(authorization_code: state.accessToken, invite_cd: Const.inviteCd, mem_id: Const.memId)))
            case let .issueAccessTokenResponse(.failure(error)):
                print(error.localizedDescription)
                return .none
            case let .withdrawAction(body):
                return .run { send in
                    let result = await Result {
                        let data = await authUseCase.withdraw(body: body)
                        return data
                    }
                    await send(.withdrawResponse(result))
                }
            case let .withdrawResponse(.success(entity)):
                if entity.result == "Success" {
                    UserDefaults.standard.removePersistentDomain(forName: Bundle.main.bundleIdentifier!)
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                        screenRouter.change(root: .login)
                    }
                    return .none
                }
                return .none
            case let .withdrawResponse(.failure(error)):
                print(error.localizedDescription)
                return .none
            }
        }
    }
}

struct SettingView: View {
    let store: StoreOf<SettingReducer>
    var body: some View {
        WithViewStore(self.store, observe: { $0 }) { viewStore in
            VStack {
                List {
                    Section {
                        Group {
                            Text("서비스 이용약관")
                                .onTapGesture {
                                    viewStore.send(.sheet(.presented(.service)))
                                }
                            Text("개인정보 처리방침")
                                .onTapGesture {
                                    viewStore.send(.sheet(.presented(.privacy)))
                                }
                            Text("이메일 문의")
                                .onTapGesture {
                                    if MFMailComposeViewController.canSendMail() {
                                        viewStore.send(.sheet(.presented(.mail)))
                                    }
                                    else {
                                        let url = URL(string: "mailto:ssdami9345@gmail.com")!
                                        UIApplication.shared.open(url)
                                    }
                                }
                        }
                    } header: {
                        Text("고객문의")
                            .font(.pHeadline2)
                            .foregroundStyle(.black)
                            .padding(.bottom, 13)
                    }
                    .font(.pButton4)
                    .foregroundStyle(Color(.gray60))
                    
                    Section {
                        Group {
                            //                            Text("가족 연결해제")
                            //                                .onTapGesture {
                            //                                    viewStore.send(.alert(.presented(.disconnect)))
                            //                                }
                            Text("로그아웃")
                                .onTapGesture {
                                    viewStore.send(.alert(.presented(.logout)))
                                }
                            Text("회원탈퇴")
                                .onTapGesture {
                                    viewStore.send(.alert(.presented(.withdraw)))
                                }
                        }
                        .font(.pButton4)
                        .foregroundStyle(Color(.gray60))
                    } header: {
                        Text("서비스 설정")
                            .font(.pHeadline2)
                            .foregroundStyle(.black)
                            .padding(.bottom, 13)
                    }
                    
                }
                .listStyle(.insetGrouped)
            }
            .sheet(store: self.store.scope(state: \.$sheet, action: \.sheet), onDismiss: { viewStore.send(.sheet(.dismiss)) }) { store in
                switch viewStore.sheet?.wrappedValue {
                case .service:
                    WebViewRepresentable(urlString: SheetType.service.urlString)
                case .privacy:
                    WebViewRepresentable(urlString: SheetType.privacy.urlString)
                case .mail:
                    MailComposeViewController()
                case .none:
                    EmptyView()
                }
            }
            .alert(store: self.store.scope(state: \.$alert, action: \.alert))
            .safeAreaInset(edge: .bottom) {
                Text("Designed by Shinhye")
                    .font(.caption)
                    .foregroundStyle(Color(.gray30))
            }
        }
    }
}

#Preview {
    SettingView(store: .init(initialState: SettingReducer.State(), reducer: {
        SettingReducer()
    }))
}
