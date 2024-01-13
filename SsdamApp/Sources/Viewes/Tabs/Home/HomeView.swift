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

public enum HomeViewType {
    case question
    case list
}

struct HomeReducer: Reducer {
    @Dependency(\.screenRouter) var screenRouter
    @Dependency(\.mainUseCase) var mainUseCase
    struct State: Equatable {
        var writeState = WriteReducer.State()
        var viewType: HomeViewType = .question
        var questionPayload: QuestionPayload = .init()
        @PresentationState var isPresented: PresentationState<Bool>?
    }
    
    enum Action: Equatable {
        case settingTapped
        case viewTypeChanged
        case writeAction(WriteReducer.Action)
        case presentSheet(PresentationAction<Bool>)
        case fetchQuestion(String)
        case makeQuestionPayload(TaskResult<QuestionFetchEntity>)
    }
    var body: some ReducerOf<Self> {
        Scope(state: \.writeState, action: /Action.writeAction) {
            WriteReducer()
        }
        Reduce { state, action in
            switch action {
            case .settingTapped:
                screenRouter.routeTo(.setting)
                return .none
            case .presentSheet(.presented(true)):
                state.isPresented = PresentationState(wrappedValue: true)
                return .none
            case .presentSheet(.dismiss):
                state.isPresented = nil
                return .none
            case .writeAction(.answerButtonTapped):
                screenRouter.dismiss()
                return .send(.viewTypeChanged)
            case .viewTypeChanged:
                state.viewType = .list
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
                return .none
            case let .makeQuestionPayload(.failure(error)):
                print(error.localizedDescription)
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
                    AnswerListView(store: .init(initialState: AnswerListReducer.State(), reducer: {
                        AnswerListReducer()
                    }))
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
