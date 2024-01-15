//
//  AnswerListView.swift
//  Ssdam
//
//  Created by 김재민 on 2024/01/03.
//  Copyright © 2024 com.dduckdori. All rights reserved.
//

import SwiftUI
import ComposableArchitecture
import Domain
import Utils
import Networking

struct AnswerListReducer: Reducer {
    @Dependency(\.screenRouter) var screenRouter
    @Dependency(\.mainUseCase) var mainUseCase
    struct State: Equatable {
        var questionPayload: QuestionPayload = .init()
        var writeState = WriteReducer.State()
        var cardState = HomeAnswerCardReducer.State()
        var answerPayload: RequestAnswerPayload = .init()
        @PresentationState var isPresented: PresentationState<Bool>?
    }
    
    enum Action: Equatable {
        case fetchAnswer(String)
        case answerReponse(TaskResult<[FetchAnswerEntity]>)
        case fetchQuestion(String)
        case makeQuestionPayload(TaskResult<FetchQuestionEntity>)
        case writeAction(WriteReducer.Action)
        case requestAnswer(PostAnswerBody)
        case requestAnswerResponse(TaskResult<RequestAnswerEntity>)
        case presentSheet(PresentationAction<Bool>)
        case cardAction(HomeAnswerCardReducer.Action)
        case setToggles
    }
    
    var body: some ReducerOf<Self> {
        Scope(state: \.writeState, action: /Action.writeAction) {
            WriteReducer()
        }
        Scope(state: \.cardState, action: /Action.cardAction) {
            HomeAnswerCardReducer()
        }
        Reduce { state, action in
            switch action {
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
                return .send(.fetchAnswer("\(state.questionPayload.categoryId)_\(state.questionPayload.questionId)_\(Const.inviteCd)"))
            case let .makeQuestionPayload(.failure(error)):
                print(error.localizedDescription)
                return .none
            case let .fetchAnswer(id):
                return .run { send in
                    let result = await TaskResult {
                        let data = await mainUseCase.fetchAllAnswers(id: id)
                        return data
                    }
                    await send(.answerReponse(result))
                }
            case let .answerReponse(.success(entity)):
                state.cardState.payloads = entity.map { FetchAnswerPayload($0) }
                return .send(.setToggles)
            case .setToggles:
                state.cardState.expands = Array(repeating: false, count: state.cardState.payloads.count)
                if state.cardState.payloads.count > 0 {
                    state.cardState.expands[0] = true
                }
                return .none
            case let .answerReponse(.failure(error)):
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
                        let data = await mainUseCase.modifyAnswer(request: body)
                        return data
                    }
                    await send(.requestAnswerResponse(result))
                }
            case let .requestAnswerResponse(.success(data)):
                state.answerPayload = RequestAnswerPayload(data)
                screenRouter.dismiss()
                return .none
            case let .requestAnswerResponse(.failure(error)):
                print(error.localizedDescription)
                return .none
            case .cardAction(.editAnswer):
                return .send(.presentSheet(.presented(true)))
            case .presentSheet(.presented(true)):
                state.writeState.question = state.questionPayload.quesContent
                state.writeState.text = state.questionPayload.ansContent
                state.writeState.date = state.questionPayload.createdAt
                state.isPresented = PresentationState(wrappedValue: true)
                return .none
            case .presentSheet(.dismiss):
                state.isPresented = nil
                return .none
            default:
                return .none
            }
        }
    }
}

struct AnswerListView: View {
    let store: StoreOf<AnswerListReducer>
    
    var body: some View {
        WithViewStore(self.store, observe: { $0 }) { viewStore in
            ZStack {
                Image(.tileYellow)
                    .resizable(resizingMode: .tile)
                ScrollView(showsIndicators: false) {
                    VStack(spacing: 0) {
                        Text(viewStore.questionPayload.createdAt.convertToDotFormat())
                            .ssdamLabel()
                            .padding(.bottom, 19)
                        Text(viewStore.questionPayload.quesContent)
                            .font(.pHeadline2)
                            .multilineTextAlignment(.center)
                            .padding(.bottom, 26)
                        
                        VStack(spacing: 16) {
                            HomeAnswerCardView(store: self.store.scope(state: \.cardState, action: AnswerListReducer.Action.cardAction))
                        }
                        .padding(.horizontal, 30)
                    }
                }
                .padding(.top, 142)
            }
            .ignoresSafeArea()
            .fullScreenCover(store: self.store.scope(state: \.$isPresented, action: AnswerListReducer.Action.presentSheet), onDismiss: { viewStore.send(.presentSheet(.dismiss)) }) { store in
                WriteView(store: self.store.scope(state: \.writeState, action: AnswerListReducer.Action.writeAction))
            }
            .onAppear {
                viewStore.send(.fetchQuestion("\(Const.inviteCd)_\(Const.memId)"))
            }
        }
    }
}

#Preview {
    AnswerListView(store: .init(initialState: AnswerListReducer.State(), reducer: {
        AnswerListReducer()
    }))
}
