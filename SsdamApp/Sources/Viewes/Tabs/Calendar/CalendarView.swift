//
//  CalendarView.swift
//  Ssdam
//
//  Created by 김재민 on 2024/01/06.
//  Copyright © 2024 com.dduckdori. All rights reserved.
//

import SwiftUI
import ComposableArchitecture

struct CalendarReducer: Reducer {
    @Dependency(\.screenRouter) var screenRouter
    struct State: Equatable {
        var date: DateComponents? = nil
        @PresentationState var isPresented: PresentationState<Bool>?
    }
    
    enum Action: Equatable {
        case datePicked(DateComponents)
        case presentSheet(PresentationAction<Bool>)
        case settingTapped
    }
    
    var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case let .datePicked(date):
                state.date = date
                return .send(.presentSheet(.presented(true)))
            case let .presentSheet(.presented(value)):
                state.isPresented = PresentationState(wrappedValue: value)
                return .none
            case .presentSheet(.dismiss):
                state.isPresented = nil
                return .none
            case .settingTapped:
                screenRouter.routeTo(.setting)
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
                        .datePicked((value ?? .init(Calendar.current.dateComponents([.day, .month, .year], from: .now))) ?? .init())
                }))
            }
            .sheet(store: self.store.scope(state: \.$isPresented, action: CalendarReducer.Action.presentSheet), onDismiss: { viewStore.send(.presentSheet(.dismiss)) }) { store in
                ZStack {
                    Color(.yellow20)
                        .ignoresSafeArea()
                    ScrollView(showsIndicators: false) {
                        VStack(spacing: 0) {
                            Text("2023.10.29")
                                .ssdamLabel()
                                .padding(.bottom, 12)
                                .padding(.top, 30)
                            
                            Text("오늘부터 쓰담하며\n우리 가족의 목표는 무엇인가요?")
                                .font(.pHeadline2)
                                .multilineTextAlignment(.center)
                                .padding(.bottom, 16)
                            
                            VStack(spacing: 16) {
                                VStack(spacing: 0) {
                                    HStack {
                                        Text("나의 답변")
                                            .font(.pButton4)
                                        Spacer()
                                        Text("2023.12.10")
                                            .font(.pBody2)
                                            .foregroundStyle(Color(.gray60))
                                    }
                                    .padding(.horizontal, 24)
                                    .padding(.vertical, 17)
                                    .background(Color(.gray10))
                                    .clipShape(RoundedCorner(radius: 10, corners: [.topLeft, .topRight])
                                    )
                                    Text("하루도 빠지지 않고 쓰담 기록하기")
                                        .font(.pBody)
                                        .padding(.vertical, 48)
                                        .padding(.horizontal, 52)
                                        .frame(maxWidth: .infinity)
                                        .background(Color.white)
                                        .clipShape(RoundedCorner(radius: 10, corners: [.bottomLeft, .bottomRight])
                                        )
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
