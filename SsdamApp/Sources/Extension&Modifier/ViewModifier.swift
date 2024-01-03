//
//  ViewModifier.swift
//  Ssdam
//
//  Created by 김재민 on 2023/11/09.
//  Copyright © 2023 com.dduckdori. All rights reserved.
//

import SwiftUI

struct SelectableButtonModifier: ViewModifier {
    @Binding var isSelected: Bool
    init(_ isSelected: Binding<Bool>) {
        self._isSelected = isSelected
    }
    func body(content: Content) -> some View {
        content
            .font(.pButton)
            .foregroundStyle(Color(.systemBlack))
            .padding(.vertical, 16)
            .frame(maxWidth: .infinity)
            .background(isSelected ? Color(.mint50) : .white)
            .clipShape(.rect(cornerRadius: 10))
            .overlay(isSelected ? nil : RoundedRectangle(cornerRadius: 10)
                .stroke(Color(.mint50), lineWidth: 2)
            )
    }
}

struct SsdamLabelModifier: ViewModifier {
    func body(content: Content) -> some View {
        content
            .font(.pButton2)
            .foregroundStyle(.white)
            .padding(.vertical, 3)
            .padding(.horizontal, 19)
            .background(Color(.mint50))
            .clipShape(Capsule())
    }
}

struct RoundedCorner: Shape {
    var radius: CGFloat = .infinity
    var corners: UIRectCorner = .allCorners
    
    func path(in rect: CGRect) -> Path {
        let path = UIBezierPath(roundedRect: rect, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        return Path(path.cgPath)
    }
}
