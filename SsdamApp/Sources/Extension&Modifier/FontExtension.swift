//
//  FontExtension.swift
//  Ssdam
//
//  Created by Jimmy on 2023/10/31.
//  Copyright © 2023 com.dduckdori. All rights reserved.
//

import SwiftUI

extension Font {
    // headline
    static let pHeadline: Font = .custom(SsdamFontFamily.Pretendard.semiBold.family, size: 26)
    static let pHeadline2: Font = .custom(SsdamFontFamily.Pretendard.semiBold.family, size: 20)
    static let pHeadline3: Font = .custom(SsdamFontFamily.Pretendard.medium.family, size: 18)
    static let pHeadline4: Font = .custom(SsdamFontFamily.Pretendard.medium.family, size: 16)
    
    // button
    static let pButton: Font = .custom(SsdamFontFamily.Pretendard.semiBold.family, size: 18)
    static let pButton2: Font = .custom(SsdamFontFamily.Pretendard.semiBold.family, size: 16)
    
    // body
    static let pBody: Font = .custom(SsdamFontFamily.Pretendard.regular.family, size: 22)
    static let pBody2: Font = .custom(SsdamFontFamily.Pretendard.regular.family, size: 14)
    
    // caption
    static let pCaption: Font = .custom(SsdamFontFamily.Pretendard.regular.family, size: 16)
}
