//
//  ToolTipView.swift
//  Ssdam
//
//  Created by 김재민 on 1/12/24.
//  Copyright © 2024 com.dduckdori. All rights reserved.
//

import SwiftUI

struct ToolTipView: View {
    var body: some View {
        VStack {
               Text("초대코드로 가족과 함께해보세요")
                .foregroundStyle(Color.white)
                .font(.pBody2)
                .padding(EdgeInsets(top: 6, leading: 20, bottom: 14, trailing: 20))
                .background(Image(.chatBubble))
        }
    }
}

#Preview {
    ToolTipView()
}
