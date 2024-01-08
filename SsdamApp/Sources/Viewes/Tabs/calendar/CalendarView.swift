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
    struct State: Equatable {
        var date: DateComponents? = nil
        var isPresented: Bool = false
    }
    
    enum Action: Equatable {
        case datePicked(DateComponents)
        case presentSheet
    }
    
    var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case let .datePicked(date):
                state.date = date
                return .send(.presentSheet)
            case .presentSheet:
                state.isPresented = true
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
            .sheet(isPresented: viewStore.binding(get: \.isPresented, send: .presentSheet), content: {
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
            })
            
        }
        .safeAreaInset(edge: .top) {
            HeaderView(store: .init(initialState: HeaderReducer.State(), reducer: {
                HeaderReducer()
            }))
        }
    }
}

#Preview {
    CalendarView(store: .init(initialState: CalendarReducer.State(), reducer: {
        CalendarReducer()
    }))
}
