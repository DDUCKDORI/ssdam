//
//  ToastModifier.swift
//  Ssdam
//
//  Created by 김재민 on 1/11/24.
//  Copyright © 2024 com.dduckdori. All rights reserved.
//

import SwiftUI
import ComposableArchitecture

struct ToastReducer: Reducer {
    
    public struct State: Equatable {
        @PresentationState var isPresented: PresentationState<Bool>? = .init(wrappedValue: false)
    }
    
    public enum Action: Equatable {
        case toast(PresentationAction<Bool>)
    }
    
    @Dependency(\.continuousClock) var clock
    
    var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case .toast(.presented(_)):
                return .none
            case .toast(.dismiss):
                state.isPresented?.wrappedValue = false
                return .none
            }
        }
    }
}

struct ToastViewModifier<ToastContent>: ViewModifier where ToastContent: View {
    @ObservedObject var viewStore: ViewStoreOf<ToastReducer>
    let toastContent: () -> ToastContent
    
    internal init(
        viewStore: ViewStoreOf<ToastReducer>,
        @ViewBuilder toastContent: @escaping () -> ToastContent
    ) {
        self.viewStore = viewStore
        self.toastContent = toastContent
    }
    
    func body(content: Content) -> some View {
        ZStack(alignment: .top) {
            content
            if viewStore.isPresented?.wrappedValue == true {
                toastContent()
                    .onAppear {
                        DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
                            viewStore.send(.toast(.dismiss))
                        }
                    }
            }
        }
    }
}
