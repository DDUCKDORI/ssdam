//
//  TabRouterView.swift
//  Ssdam
//
//  Created by 김재민 on 2023/12/04.
//  Copyright © 2023 com.dduckdori. All rights reserved.
//

import SwiftUI
import ComposableArchitecture

struct TabRouterReducer: Reducer {
    struct State: Equatable {
        var tab: Tab = .home
    }
    
    enum Action: Equatable {
        case tabChanged(Tab)
    }
    
    var body: some ReducerOf<Self> {
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
                }
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
            HStack {
                Image(.logo)
                Spacer()
                Image(.setting)
            }
            .padding(.horizontal, 28)
            TabView(selection: viewStore.binding(get: \.tab, send: { value in
                    .tabChanged(value)
            }), content: {
                Text("Calendar")
                    .ignoresSafeArea(edges: .top)
                    .tabItem { Image(.calendar)
                            .renderingMode(.template)
                    }
                    .tag(TabRouterReducer.Tab.calendar)
                Text("Home")
                    .ignoresSafeArea(edges: .top)
                    .tabItem { Image(.home)
                            .renderingMode(.template)
                    }
                    .tag(TabRouterReducer.Tab.home)
                Text("Share")
                    .ignoresSafeArea(edges: .top)
                    .tabItem { Image(.share)
                        .renderingMode(.template) }
                    .tag(TabRouterReducer.Tab.share)
            })
            .tint(Color(.mint50))
            .preferredColorScheme(.light)
        }
    }
}

#Preview {
    TabRouterView(store: .init(initialState: TabRouterReducer.State(), reducer: {
        TabRouterReducer()
    }))
}
