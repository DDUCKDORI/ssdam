//
//  ViewExtension.swift
//  Ssdam
//
//  Created by 김재민 on 2023/11/09.
//  Copyright © 2023 com.dduckdori. All rights reserved.
//

import SwiftUI
import ComposableArchitecture

extension View {
    func selectableButton(_ isSelected: Binding<Bool>) -> some View {
        self
            .modifier(SelectableButtonModifier(isSelected))
    }
    
    func ssdamLabel() -> some View {
        self
            .modifier(SsdamLabelModifier())
    }
    
    func roundedCorner(_ radius: CGFloat, corners: UIRectCorner) -> some View {
        clipShape(RoundedCorner(radius: radius, corners: corners) )
    }
    
    @ViewBuilder
    func toast(_ store: StoreOf<ToastReducer>, content: @escaping () -> some View) -> some View {
        self
            .modifier(
                ToastViewModifier(
                    viewStore: ViewStore(store, observe: { $0 }),
                    toastContent: content
                )
            )
    }
}
