//
//  TabRouterView.swift
//  Ssdam
//
//  Created by 김재민 on 2023/12/04.
//  Copyright © 2023 com.dduckdori. All rights reserved.
//

import SwiftUI
import ComposableArchitecture
import Utils

@Reducer
struct TabRouterReducer {
    struct State: Equatable {
        var tab: Tab = .home
        var homeState: HomeReducer.State = .init()
        var calendarState: CalendarReducer.State = .init()
        var shareState: ShareReducer.State = .init()
    }
    
    enum Action {
        case tabChanged(Tab)
        case calendarAction(CalendarReducer.Action)
        case shareAction(ShareReducer.Action)
    }
    
    var body: some ReducerOf<Self> {
        Scope(state: \.calendarState, action: /Action.calendarAction) {
            CalendarReducer()
        }
        Scope(state: \.shareState, action: /Action.shareAction) {
            ShareReducer()
        }
        Reduce { state, action in
            switch action {
            case let .tabChanged(tab):
                state.tab = tab
                switch tab {
                case .calendar:
                    print("calendar")
                case .home:
                    print("home")
                case .share:
                    print("share")
                    Const.isPioneer = false
                }
                return .none
            default:
                return .none
            }
        }
    }
    
    enum Tab: Hashable, CaseIterable {
        case calendar
        case home
        case share
    }
    
}

struct TabRouterView: View {
    let store: StoreOf<TabRouterReducer>
    var body: some View {
        WithViewStore(self.store, observe: { $0 }) { viewStore in
            ZStack(alignment: .top) {
                ZStack(alignment: .bottomTrailing) {
                    Image(.tileMint)
                        .resizable(resizingMode: .tile)
                        .ignoresSafeArea()
                    VStack {
                        TabView(selection: viewStore.binding(get: \.tab, send: { value in
                                .tabChanged(value)
                        }), content: {
                            CalendarView(store: self.store.scope(state: \.calendarState, action: \.calendarAction))
                                .tag(TabRouterReducer.Tab.calendar)
                            HomeView(store: .init(initialState: HomeReducer.State(), reducer: {
                                HomeReducer()
                            }))
                            .tag(TabRouterReducer.Tab.home)
                            ShareView(store: self.store.scope(state: \.shareState, action: \.shareAction))
                                .tag(TabRouterReducer.Tab.share)
                        })
                        .preferredColorScheme(.light)
                        
                    }
                    if Const.isPioneer {
                        ToolTipView()
                            .offset(x: -45)
                    }
                }
                HeaderView(store: .init(initialState: HeaderReducer.State(), reducer: {
                    HeaderReducer()
                }))
            }
            .safeAreaInset(edge: .bottom) {
                VStack {
                    ZStack(alignment: .top) {
                        HStack {
                            Image(.calendar)
                                .renderingMode(.template)
                                .foregroundStyle(viewStore.tab == .calendar ? Color(.mint50) : Color(.gray30))
                                .onTapGesture {
                                    viewStore.send(.tabChanged(.calendar))
                                }
                            Spacer()
                            Image(.home)
                                .renderingMode(.template)
                                .foregroundStyle(viewStore.tab == .home ? Color(.mint50) : Color(.gray30))
                                .onTapGesture {
                                    viewStore.send(.tabChanged(.home))
                                }
                            Spacer()
                            Image(.share)
                                .renderingMode(.template)
                                .foregroundStyle(viewStore.tab == .share ? Color(.mint50) : Color(.gray30))
                                .onTapGesture {
                                    viewStore.send(.tabChanged(.share))
                                }
                        }
                        .padding(.vertical, 9)
                        .padding(.horizontal, 47)
                        .frame(maxWidth: .infinity)
                        .background(Color(.white))
                        Rectangle()
                            .frame(height: 1)
                            .foregroundStyle(Color(.gray10))
                    }
                }
            }
        }
    }
}

#Preview {
    TabRouterView(store: .init(initialState: TabRouterReducer.State(), reducer: {
        TabRouterReducer()
    }))
}
