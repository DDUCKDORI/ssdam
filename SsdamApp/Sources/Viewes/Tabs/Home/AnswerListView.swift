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
import CoreData

struct AnswerListReducer: Reducer {
    @Dependency(\.screenRouter) var screenRouter
    @Dependency(\.mainUseCase) var mainUseCase
    struct State: Equatable {
        var questionPayload: QuestionPayload = .init()
        var writeState = WriteReducer.State()
        var modalState = ModalReducer.State()
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
        case cardAction(HomeAnswerCardReducer.Action)
        case presentSheet(PresentationAction<Bool>)
        case modalAction(ModalReducer.Action)
        case setToggles
        case storeDates(Date)
    }
    
    var body: some ReducerOf<Self> {
        Scope(state: \.writeState, action: /Action.writeAction) {
            WriteReducer()
        }
        Scope(state: \.cardState, action: /Action.cardAction) {
            HomeAnswerCardReducer()
        }
        Scope(state: \.modalState, action: /Action.modalAction) {
            ModalReducer()
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
                if let myIndex = state.cardState.payloads.firstIndex(where: { $0.memberId == Const.memId }) {
                    let myAnswer = state.cardState.payloads.remove(at: myIndex)
                    state.cardState.payloads.insert(myAnswer, at: 0)
                }
                return .send(.setToggles)
            case .setToggles:
                state.cardState.expands = Array(repeating: false, count: state.cardState.payloads.count)
                if state.cardState.payloads.count > 0 {
                    state.cardState.expands[0] = true
                }
                if state.questionPayload.notAnswer == 0, Const.modalPresented == false {
                    return .send(.modalAction(.modalPresented(.presented(true))))
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
                return .send(.presentSheet(.dismiss))
            case .modalAction(.modalPresented(.presented(true))):
                state.modalState.isPresented?.wrappedValue = true
                return .send(.storeDates(Date.now))
            case .modalAction(.modalPresented(.dismiss)):
                state.modalState.isPresented = nil
                return .none
            case let .requestAnswerResponse(.failure(error)):
                print(error.localizedDescription)
                return .none
            case .cardAction(.editAnswer):
                if state.questionPayload.notAnswer > 0 {
                    return .send(.presentSheet(.presented(true)))
                }
                return.none
            case .presentSheet(.presented(true)):
                state.writeState.question = state.questionPayload.quesContent
                state.writeState.text = state.questionPayload.ansContent
                state.writeState.date = state.questionPayload.questionCreatedAt
                state.isPresented = PresentationState(wrappedValue: true)
                return .none
            case .presentSheet(.dismiss):
                state.isPresented = nil
                return .send(.fetchQuestion("\(Const.inviteCd)_\(Const.memId)"))
            case let .storeDates(date):
                let container = PersistenceController.shared.container
                let entity = NSEntityDescription.entity(forEntityName: "Dates", in: container.viewContext)
                let dates = NSManagedObject(entity: entity!, insertInto: container.viewContext)
                dates.setValue(date, forKey: "completedAt")
                LocalNotificationHelper.shared.pushNotification()
                Const.modalPresented = true
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
                        Text(viewStore.questionPayload.questionCreatedAt.convertToDotFormat(.dot))
                            .ssdamLabel()
                            .padding(.bottom, 19)
                        Text(viewStore.questionPayload.quesContent)
                            .font(.pHeadline2)
                            .multilineTextAlignment(.center)
                            .padding(.bottom, 26)
                            .padding(.horizontal, 62)
                        
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
            .modal(self.store.scope(state: \.modalState, action: AnswerListReducer.Action.modalAction), content: {
                VStack {
                    Image(.checkmarkCircleMint)
                        .padding(.bottom, 8)
                        .padding(.top, 70)
                    Text("모두의 답변이 완료됐어요")
                        .font(.pHeadline2)
                        .foregroundStyle(Color(.mint50))
                        .padding(.bottom, 4)
                    Text("내일 오전 9시 새로운 질문이 도착해요")
                        .font(.pBody)
                        .padding(.bottom, 40)
                    Image(.completed)
                        .padding(.bottom, 72)
                }
                .padding(.horizontal, 30)
                .background()
                .clipShape(RoundedRectangle(cornerRadius: 28))
            })
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
