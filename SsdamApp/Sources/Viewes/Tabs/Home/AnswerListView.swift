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

struct AnswerListReducer: Reducer {
    @Dependency(\.mainUseCase) var mainUseCase
    struct State: Equatable {
        var answerPayloads: [FetchAnswerPayload] = []
        var questionPayload: QuestionPayload = .init()
    }
    
    enum Action: Equatable {
        case fetchAnswer(String)
        case answerReponse(TaskResult<[FetchAnswerEntity]>)
        case fetchQuestion(String)
        case makeQuestionPayload(TaskResult<FetchQuestionEntity>)
    }
    
    var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case let .fetchAnswer(id):
                return .run { send in
                    let result = await TaskResult {
                        let data = await mainUseCase.fetchAllAnswers(id: id)
                        return data
                    }
                    await send(.answerReponse(result))
                }
            case let .answerReponse(.success(entity)):
                state.answerPayloads = entity.map { FetchAnswerPayload($0) }
                return .none
            case let .answerReponse(.failure(error)):
                print(error.localizedDescription)
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
                return .send(.fetchAnswer("\(state.questionPayload.categoryId)_\(state.questionPayload.questionId)_\(Const.inviteCd)"))
            case let .makeQuestionPayload(.failure(error)):
                print(error.localizedDescription)
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
                        Text("2023.12.12")
                            .ssdamLabel()
                            .padding(.bottom, 19)
                        Text(viewStore.questionPayload.quesContent)
                            .font(.pHeadline2)
                            .multilineTextAlignment(.center)
                            .padding(.bottom, 26)
                        
                        VStack(spacing: 16) {
                            ForEach(viewStore.answerPayloads, id: \.self) { answer in
                                HomeAnswerCard(payload: answer)
                            }
                        }
                        .padding(.horizontal, 30)
                    }
                }
                .padding(.top, 142)
            }
            .ignoresSafeArea()
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
