//
//  ViewExtension.swift
//  Ssdam
//
//  Created by 김재민 on 2023/11/09.
//  Copyright © 2023 com.dduckdori. All rights reserved.
//

import SwiftUI

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
    
    @ViewBuilder func present<Content: View>(asSheet: Bool, isPresented: Binding<Bool>, @ViewBuilder content: @escaping () -> Content) -> some View {
        if asSheet {
            self.sheet(
                isPresented: isPresented,
                onDismiss: nil,
                content: content
            )
        } else {
            self.fullScreenCover(
                isPresented: isPresented,
                onDismiss: nil,
                content: content
            )
        }
    }
}
