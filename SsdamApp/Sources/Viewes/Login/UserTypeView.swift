//
//  UserTypeView.swift
//  Ssdam
//
//  Created by 김재민 on 2023/11/16.
//  Copyright © 2023 com.dduckdori. All rights reserved.
//

import SwiftUI

enum UserType {
    case parent
    case child
}

struct UserTypeView: View {
    @State var userType: UserType? = nil
    @Binding var page: Int
    var body: some View {
        VStack(spacing: 16) {
            Text("누구인지 선택해주세요")
                .font(.pHeadline2)
                .foregroundStyle(Color(.systemBlack))
                
            HStack {
                Button(action: {
                    userType = .parent
                    page += 1
                }, label: {
                    Text("부모")
                        .selectableButton(userType == .parent ? .constant(true) : .constant(false))
                })
                Button(action: {
                    userType = .child
                    page += 1
                }, label: {
                    Text("아이")
                        .selectableButton(userType == .child ? .constant(true) : .constant(false))
                })
            }
        }
    }
}

#Preview {
    UserTypeView(userType: .child, page: .constant(0))
}
