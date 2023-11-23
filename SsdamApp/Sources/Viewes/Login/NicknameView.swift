//
//  NicknameView.swift
//  Ssdam
//
//  Created by 김재민 on 2023/11/18.
//  Copyright © 2023 com.dduckdori. All rights reserved.
//

import SwiftUI

struct NicknameView: View {
    @State var nickname: String = ""
    @State var isValid: Bool = false
    @State var serviceAgreement: Bool = false
    @State var privacyAgreement: Bool = false
    
    var body: some View {
        VStack(spacing: 16) {
            isValid ?
            Text("멋진 닉네임이네요 :)")
                .font(.pHeadline2)
                .foregroundStyle(Color(.systemBlack))
            :
            Text("사용할 닉네임을 입력해주세요")
                .font(.pHeadline2)
                .foregroundStyle(Color(.systemBlack))

            ZStack(alignment: .trailing) {
                TextField("1~10자 이내 작성", text: $nickname)
                    .font(.pButton)
                    .foregroundStyle(Color(.systemBlack))
                    .padding(.vertical, 16)
                    .multilineTextAlignment(.center)
                    .overlay(RoundedRectangle(cornerRadius: 10).stroke(Color(.mint50), lineWidth: 2))
                    .onChange(of: nickname){ newValue in
                        if newValue.count > 10 {
                            nickname.removeLast()
                            return
                        }
                        // validation check
                        if newValue.count > 1 {
                            isValid = true
                            return
                        }
                        isValid = false
                    }
                if isValid {
                    Image(.checkmarkCircleMint)
                        .padding(.vertical, 16)
                        .padding(.horizontal, 24)
                }
            }
            if nickname.count > 0, !isValid {
                Text("*닉네임을 다시 입력해주세요")
                    .font(.pCaption)
                    .foregroundStyle(Color(.systemRed))
                    .padding(.vertical, 12)
            }
            if isValid {
                HStack {
                    Text("모두 동의합니다")
                        .font(.pButton4)
                        .foregroundStyle(serviceAgreement && privacyAgreement ? Color(.systemBlack) : Color(.gray20))
                    Spacer()
                    Image(serviceAgreement && privacyAgreement ? .checkmarkCircleMint : .checkmarkCircle )
                }
                .padding(.vertical, 16)
                .padding(.horizontal, 24)
                .background(Color(.gray10))
                .clipShape(RoundedRectangle(cornerRadius: 10))
                .onTapGesture {
                    if !serviceAgreement || !privacyAgreement {
                        serviceAgreement = true
                        privacyAgreement = true
                        return
                    }
                    serviceAgreement = false
                    privacyAgreement = false
                }
                
                HStack {
                    Text("(필수) 서비스 이용약관")
                        .font(.pBody)
                        .foregroundStyle(Color(.systemBlack))
                    Spacer()
                    Image(serviceAgreement ? .checkmarkCircleFill : .checkmarkCircle )
                }
                .padding(.vertical, -3)
                .padding(.horizontal, 24)
                .onTapGesture {
                    serviceAgreement.toggle()
                }
                
                HStack {
                    Text("(필수) 개인정보 처리방침")
                        .font(.pBody)
                        .foregroundStyle(Color(.systemBlack))
                    Spacer()
                    Image(privacyAgreement ? .checkmarkCircleFill : .checkmarkCircle )
                }
                .padding(.horizontal, 24)
                .onTapGesture {
                    privacyAgreement.toggle()
                }
                .padding(.bottom, 106)
            }
            
            if isValid, serviceAgreement, privacyAgreement {
                Button {
                    
                } label: {
                    Text("가입하기")
                        .font(.pButton2)
                        .foregroundStyle(.white)
                        .padding(.vertical, 16)
                        .padding(.horizontal, 76)
                        .background(Color(.mint50))
                        .clipShape(RoundedRectangle(cornerRadius: 100))
                }
            }
        }
        .padding(.horizontal, 30)
    }
}

#Preview {
    NicknameView()
}
