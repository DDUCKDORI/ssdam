//
//  ModalModifier.swift
//  Ssdam
//
//  Created by 김재민 on 1/16/24.
//  Copyright © 2024 com.dduckdori. All rights reserved.
//

import SwiftUI
import ComposableArchitecture

struct ModalReducer: Reducer {
    
    public struct State: Equatable {
        @PresentationState var isPresented: PresentationState<Bool>? = .init(wrappedValue: false)
    }
    
    public enum Action: Equatable {
        case modalPresented(PresentationAction<Bool>)
    }
    
    var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case .modalPresented(.presented(_)):
                return .none
            case .modalPresented(.dismiss):
                state.isPresented = nil
                return .none
            }
        }
    }
}

struct ModalViewModifier<ModalContent>: ViewModifier where ModalContent: View {
    @ObservedObject var viewStore: ViewStoreOf<ModalReducer>
    let modalContent: () -> ModalContent
    
    internal init(
        viewStore: ViewStoreOf<ModalReducer>,
        @ViewBuilder modalContent: @escaping () -> ModalContent
    ) {
        self.viewStore = viewStore
        self.modalContent = modalContent
    }
    
    func body(content: Content) -> some View {
        ZStack {
            content
            if viewStore.isPresented?.wrappedValue == true {
                Color(.gray80).opacity(0.7)
                modalContent()
                    .onTapGesture {
                        viewStore.send(.modalPresented(.dismiss))
                    }
            }
        }
    }
}
