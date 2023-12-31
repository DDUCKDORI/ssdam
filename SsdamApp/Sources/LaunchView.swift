//
//  LaunchView.swift
//  Ssdam
//
//  Created by 김재민 on 2023/12/31.
//  Copyright © 2023 com.dduckdori. All rights reserved.
//

import SwiftUI

struct LaunchView: View {
    var body: some View {
        ZStack(alignment: .top) {
            Image(.tileMint)
                .resizable(resizingMode: .tile)
                    }
        .ignoresSafeArea()
        .safeAreaInset(edge: .top) {
            VStack(spacing: 0) {
                Image(.charactersSilhouette)
                Text("우리 가족 쓰고 담고")
                    .font(.pHeadline2)
                    .padding(.top, 20)
            }
            .offset(y: 272)
        }
    }
}

#Preview {
    LaunchView()
}
