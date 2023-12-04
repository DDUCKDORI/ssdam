//
//  SignUpSuccessView.swift
//  Ssdam
//
//  Created by 김재민 on 2023/12/03.
//  Copyright © 2023 com.dduckdori. All rights reserved.
//

import SwiftUI

struct SignUpSuccessView: View {
    var body: some View {
        ZStack {
            Color(.yellow50)
                .ignoresSafeArea()
            VStack {
                Image(.characterSuccess)
                    .resizable()
                    .frame(height: 339)
                    .padding(.bottom, 23)
                    .padding(.horizontal, 36)
                
                var welcomeMessage: AttributedString {
                    var text: AttributedString = "shinhye님\n환영합니다"
                    let nicknameRange = text.range(of: "shinhye")!
                    let messageRange = text.range(of: "님\n환영합니다")!
                    
                    text[nicknameRange].font = .pHeadline
                    text[messageRange].font = .pHeadline
                    text[nicknameRange].foregroundColor = Color(.mint50)
                    
                    return text
                }
                Text(welcomeMessage)
                    .padding(.bottom, 106)
                
                Button(action: {
                    
                }, label: {
                    Text("다음")
                        .font(.pButton)
                        .foregroundStyle(Color(.white))
                        .padding(.vertical, 16)
                        .frame(maxWidth: .infinity)
                        .background(Color(.mint50))
                        .clipShape(RoundedRectangle(cornerRadius: 100))
                        .padding(.horizontal, 80)
                })
            }
        }
    }
}

#Preview {
    SignUpSuccessView()
}
