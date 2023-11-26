//
//  LoginView.swift
//  Ssdam
//
//  Created by 김재민 on 2023/11/22.
//  Copyright © 2023 com.dduckdori. All rights reserved.
//

import SwiftUI
import AuthenticationServices
import ComposableArchitecture

struct LoginReducer: Reducer {
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

struct LoginView: View {
    var body: some View {
        ZStack {
            Image(.tile)
                .resizable(resizingMode: .tile)
                .ignoresSafeArea()
            VStack(spacing: 263) {
                Image(.characters)
                    .padding(.top, 272)
                SignInWithAppleButton(.signIn) { _ in
                    
                } onCompletion: { _ in
                    
                }
                .frame(height: 56)
                .padding(.bottom, 112)
                .padding(.horizontal, 30)
            }
        }
    }
}

#Preview {
    LoginView()
}
