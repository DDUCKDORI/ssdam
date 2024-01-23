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
import Domain
import Utils
import Networking

public enum HomeViewType {
    case question
    case list
}

struct HomeReducer: Reducer {
    @Dependency(\.screenRouter) var screenRouter
    @Dependency(\.mainUseCase) var mainUseCase
    struct State: Equatable {
        var writeState = WriteReducer.State()
        var listState: AnswerListReducer.State = .init()
        var viewType: HomeViewType = .question
        var questionPayload: QuestionPayload = .init()
        var answerPayload: RequestAnswerPayload = .init()
        @PresentationState var isPresented: PresentationState<Bool>?
    }
    
    enum Action: Equatable {
        case settingTapped
        case viewTypeChanged
        case writeAction(WriteReducer.Action)
        case listAction(AnswerListReducer.Action)
        case presentSheet(PresentationAction<Bool>)
        case fetchQuestion(String)
        case makeQuestionPayload(TaskResult<FetchQuestionEntity>)
        case requestAnswer(PostAnswerBody)
        case requestAnswerResponse(TaskResult<RequestAnswerEntity>)
        case setAuthorization
    }
    var body: some ReducerOf<Self> {
        Scope(state: \.writeState, action: /Action.writeAction) {
            WriteReducer()
        }
        Scope(state: \.listState, action: /Action.listAction) {
            AnswerListReducer()
        }
        Reduce { state, action in
            switch action {
            case .settingTapped:
                screenRouter.routeTo(.setting)
                return .none
            case let .fetchQuestion(id):
                return .run { send in
                    let result = await TaskResult {
                        let data = await mainUseCase.fetchQuestionByUser(id: id)
                        return data
                    }
                    await send(.makeQuestionPayload(result))
                }
            case let .makeQuestionPayload(.success(entity)):
                state.questionPayload = QuestionPayload(entity)
                if state.questionPayload.isReplied == "True" {
                    return .send(.viewTypeChanged)
                }
                Const.isModalPresented = false
                return .send(.setAuthorization)
            case let .makeQuestionPayload(.failure(error)):
                print(error.localizedDescription)
                return .none
            case .writeAction(.answerButtonTapped):
                let body = PostAnswerBody(
                    cateId: state.questionPayload.categoryId,
                    qustId: state.questionPayload.questionId,
                    memId: Const.memId,
                    inviteCd: Const.inviteCd,
                    ansCn: state.writeState.text)
                return .send(.requestAnswer(body))
            case let .requestAnswer(body):
                return .run { send in
                    let result = await TaskResult {
                        let data = await mainUseCase.postAnswer(request: body)
                        return data
                    }
                    await send(.requestAnswerResponse(result))
                }
            case let .requestAnswerResponse(.success(data)):
                state.answerPayload = RequestAnswerPayload(data)
                screenRouter.dismiss()
                return .send(.viewTypeChanged)
            case let .requestAnswerResponse(.failure(error)):
                print(error.localizedDescription)
                return .none
            case .viewTypeChanged:
                state.viewType = .list
                return .none
            case .presentSheet(.presented(true)):
                state.writeState.question = state.questionPayload.quesContent
                state.writeState.date = state.questionPayload.questionCreatedAt
                state.isPresented = PresentationState(wrappedValue: true)
                return .none
            case .presentSheet(.dismiss):
                state.isPresented = nil
                return .none
            case .setAuthorization:
//                LocalNotificationHelper.shared.setAuthorization()
                return .none
            default:
                return .none
            }
        }
    }
}

struct HomeView: View {
    let store: StoreOf<HomeReducer>
    var body: some View {
        WithViewStore(self.store, observe: { $0 }) { viewStore in
            ZStack {
                if viewStore.viewType == .question {
                    MainQuestionView(viewStore: viewStore)
                        .onTapGesture {
                            viewStore.send(.presentSheet(.presented(true)))
                        }
                    
                } else {
                    AnswerListView(store: self.store.scope(state: \.listState, action: HomeReducer.Action.listAction))
                }
            }
            .ignoresSafeArea()
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
            .fullScreenCover(store: self.store.scope(state: \.$isPresented, action: HomeReducer.Action.presentSheet), onDismiss: { viewStore.send(.presentSheet(.dismiss)) }) { store in
                WriteView(store: self.store.scope(state: \.writeState, action: HomeReducer.Action.writeAction))
            }
            .onAppear {
                viewStore.send(.fetchQuestion("\(Const.inviteCd)_\(Const.memId)"))
            }
        }
    }
    
    @ViewBuilder
    private func MainQuestionView(viewStore: ViewStoreOf<HomeReducer>) -> some View {
        ZStack {
            Image(.tileMint)
                .resizable(resizingMode: .tile)
            VStack(spacing: 0) {
                Text("NEW")
                    .ssdamLabel()
                    .padding(.bottom, 12)
                
                Text(viewStore.questionPayload.quesContent)
                    .font(.pHeadline2)
                    .multilineTextAlignment(.center)
                    .padding(.bottom, 30)
                    .padding(.horizontal, 62)
                
                Image(.characterMain)
                    .padding(.bottom, 12)
            }
        }
    }
}

#Preview {
    HomeView(store: .init(initialState: HomeReducer.State(), reducer: {
        HomeReducer()
    }))
}
