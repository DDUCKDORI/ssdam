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
}
