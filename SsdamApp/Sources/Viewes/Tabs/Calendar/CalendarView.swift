//
//  CalendarView.swift
//  Ssdam
//
//  Created by 김재민 on 2024/01/06.
//  Copyright © 2024 com.dduckdori. All rights reserved.
//

import SwiftUI
import ComposableArchitecture
import Domain
import Utils

struct CalendarReducer: Reducer {
    @Dependency(\.screenRouter) var screenRouter
    @Dependency(\.mainUseCase) var mainUseCase
    struct State: Equatable {
        var date: DateComponents? = nil
        var answerPayload: AnswerByDatePayload = .init()
        @PresentationState var isPresented: PresentationState<Bool>?
    }
    
    enum Action: Equatable {
        case datePicked(DateComponents?, String)
        case presentSheet(PresentationAction<Bool>)
        case settingTapped
        case answerResponse(TaskResult<AnswerByDateEntity>)
    }
    
    var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case let .datePicked(date, code):
                guard let date = date else { return .none }
                state.date = date
                return .run { send in
                    let result = await TaskResult {
                        let data = await mainUseCase.fetchAnswerByDate(date: date.toYYYYMMDDString(), code: code)
                        return data
                    }
                    await send(.answerResponse(result))
                }
            case let .presentSheet(.presented(value)):
                state.isPresented = PresentationState(wrappedValue: value)
                return .none
            case .presentSheet(.dismiss):
                state.isPresented = nil
                return .none
            case .settingTapped:
                screenRouter.routeTo(.setting)
                return .none
            case let .answerResponse(.success(entity)):
                if entity.answerList.isEmpty { return .none }
                state.answerPayload = AnswerByDatePayload(entity)
                return .send(.presentSheet(.presented(true)))
            default:
                return .none
            }
        }
    }
}

struct CalendarView: View {
    
    let store: StoreOf<CalendarReducer>
    var body: some View {
        WithViewStore(self.store, observe: { $0 }) { viewStore in
            VStack {
                CalendarViewRepresentable(selectedDate: viewStore.binding(get: \.date, send: { value in
                        .datePicked(value, Const.inviteCd)
                }))
            }
            .sheet(store: self.store.scope(state: \.$isPresented, action: CalendarReducer.Action.presentSheet), onDismiss: { viewStore.send(.presentSheet(.dismiss)) }) { store in
                ZStack {
                    Color(.yellow20)
                        .ignoresSafeArea()
                    ScrollView(showsIndicators: false) {
                        VStack(spacing: 0) {
                            Text(viewStore.answerPayload.answerList.first?.createdAt.convertToDotFormat() ?? "")
                                .ssdamLabel()
                                .padding(.bottom, 12)
                                .padding(.top, 30)
                            
                            Text(viewStore.answerPayload.question)
                                .font(.pHeadline2)
                                .multilineTextAlignment(.center)
                                .padding(.bottom, 16)
                            
                            VStack(spacing: 16) {
                                ForEach(viewStore.answerPayload.answerList, id: \.self) { payload in
                                    VStack(spacing: 0) {
                                        HStack {
                                            Text("\(payload.nickname)의 답변")
                                                .font(.pButton4)
                                            Spacer()
                                            Text(payload.createdAt.convertToDotFormat())
                                                .font(.pBody2)
                                                .foregroundStyle(Color(.gray60))
                                        }
                                        .padding(.horizontal, 24)
                                        .padding(.vertical, 17)
                                        .background(Color(.gray10))
                                        .clipShape(RoundedCorner(radius: 10, corners: [.topLeft, .topRight])
                                        )
                                        Text(payload.answer)
                                            .font(.pBody)
                                            .padding(.vertical, 48)
                                            .padding(.horizontal, 52)
                                            .frame(maxWidth: .infinity)
                                            .background(Color.white)
                                            .clipShape(RoundedCorner(radius: 10, corners: [.bottomLeft, .bottomRight])
                                            )
                                    }
                                }
                            }
                            .padding(.horizontal, 30)
                        }
                    }
                }
                .presentationDetents([.fraction(0.4) , .large])
            }
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
        }
    }
}

#Preview {
    CalendarView(store: .init(initialState: CalendarReducer.State(), reducer: {
        CalendarReducer()
    }))
}
