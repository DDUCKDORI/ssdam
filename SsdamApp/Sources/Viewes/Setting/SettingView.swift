//
//  SettingView.swift
//  Ssdam
//
//  Created by 김재민 on 1/8/24.
//  Copyright © 2024 com.dduckdori. All rights reserved.
//

import SwiftUI
import ComposableArchitecture

struct SettingReducer: Reducer {
    struct State: Equatable {
        
    }
    
    enum Action: Equatable {
        
    }
    
    var body: some ReducerOf<Self> {
        Reduce { state, action in
            return .none
        }
    }
}

struct SettingView: View {
    let store: StoreOf<SettingReducer>
    var body: some View {
        WithViewStore(self.store, observe: { $0 }) { viewStore in
            VStack {
                List {
                    Section {
                        Group {
                            Text("서비스 이용약관")
                            Text("개인정보 처리방침")
                            Text("이메일 문의")
                        }
                    } header: {
                        Text("고객문의")
                            .font(.pHeadline2)
                            .foregroundStyle(.black)
                            .padding(.bottom, 13)
                    }
                    .font(.pButton4)
                    .foregroundStyle(Color(.gray60))
                    
                    Section {
                        Group {
                            Text("서비스 알림")
                            Text("가족 연결해제")
                            Text("로그아웃")
                            Text("회원탈퇴")
                        }
                        .font(.pButton4)
                        .foregroundStyle(Color(.gray60))
                    } header: {
                        Text("서비스 설정")
                            .font(.pHeadline2)
                            .foregroundStyle(.black)
                            .padding(.bottom, 13)
                    }
                    
                }
                .listStyle(.insetGrouped)
            }
        }
    }
}

#Preview {
    SettingView(store: .init(initialState: SettingReducer.State(), reducer: {
        SettingReducer()
    }))
}
