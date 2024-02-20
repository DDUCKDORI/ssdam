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
import GoogleMobileAds

final class CompletedDateManager: ObservableObject {
    @Dependency(\.mainUseCase) var mainUseCase
    
    @Published var completedDates: [DateComponents] = []
    
    public static let shared = CompletedDateManager()
    private init() {}
    
    func fetchCompletedDates(code: String) async {
        let dates = await mainUseCase.fetchCompletedDates(code: code)
        let dateComponents = dates.compactMap { $0.toDateComponents(.withoutDash) }
        self.completedDates = dateComponents
    }
}

struct CalendarReducer: Reducer {
    @Dependency(\.screenRouter) var screenRouter
    @Dependency(\.mainUseCase) var mainUseCase
    struct State: Equatable {
        var date: DateComponents? = nil
        var answerPayload: AnswerByDatePayload = .init()
        var completedDates: [DateComponents] = []
        @PresentationState var isPresented: PresentationState<Bool>?
    }
    
    enum Action: Equatable {
        case datePicked(DateComponents?, String)
        case presentSheet(PresentationAction<Bool>)
        case settingTapped
        case answerResponse(TaskResult<AnswerByDateEntity>)
        case fetchCompletedDates(String)
        case completedDatesResponse(TaskResult<[String]>)
    }
    
    var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case let .datePicked(date, code):
                guard let date = date else { return .none }
                state.date = date
                return .run { send in
                    let result = await TaskResult {
                        let data = await mainUseCase.fetchAnswerByDate(date: date.toString(.withoutDash), code: code)
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
            case let .fetchCompletedDates(code):
                return .run { send in
                    let result = await TaskResult {
                        let data = await mainUseCase.fetchCompletedDates(code: code)
                        return data
                    }
                    await send(.completedDatesResponse(result))
                }
            case let .completedDatesResponse(.success(dates)):
                state.completedDates = dates.compactMap { $0.toDateComponents(.withoutDash)}
                return .none
            case let .completedDatesResponse(.failure(error)):
                print(error.localizedDescription)
                return .none
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
                .fixedSize(horizontal: false, vertical: UIDevice.current.userInterfaceIdiom == .phone ? true : false)
                .padding(.top, 35)
                .padding(.horizontal, 20)
//                Spacer()
                AdBannerView()
            }
            .sheet(store: self.store.scope(state: \.$isPresented, action: CalendarReducer.Action.presentSheet), onDismiss: { viewStore.send(.presentSheet(.dismiss)) }) { store in
                ZStack {
                    Color(.yellow20)
                        .ignoresSafeArea()
                    ScrollView(showsIndicators: false) {
                        VStack(spacing: 0) {
                            Text(viewStore.answerPayload.questionCreatedAt.convertToDotFormat(.dot))
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
                                            Text("\(payload.nickname.withAttributed())의 답변")
                                                .font(.pButton4)
                                            Spacer()
                                            Text(payload.createdAt.convertToDotFormat(.dot))
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
                                            .clipShape(RoundedCorner(radius: 10, corners: [.bottomLeft, .bottomRight]))
                                    }
                                }
                            }
                            .padding(.horizontal, 30)
                        }
                    }
                }
                .presentationDetents([.fraction(0.4) , .large])
            }
            .onAppear {
                viewStore.send(.fetchCompletedDates(Const.inviteCd))
            }
            .task {
                await CompletedDateManager.shared.fetchCompletedDates(code: Const.inviteCd)
            }
        }
    }
}

#Preview {
    CalendarView(store: .init(initialState: CalendarReducer.State(), reducer: {
        CalendarReducer()
    }))
}
