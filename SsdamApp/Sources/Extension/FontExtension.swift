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
    static let headline1: Font = .custom(SsdamFontFamily.Pretendard.semiBold.family, size: 26)
    static let headline2: Font = .custom(SsdamFontFamily.Pretendard.semiBold.family, size: 20)
    static let headline3: Font = .custom(SsdamFontFamily.Pretendard.medium.family, size: 18)
    static let headline4: Font = .custom(SsdamFontFamily.Pretendard.medium.family, size: 16)
    
    // button
    static let button1: Font = .custom(SsdamFontFamily.Pretendard.semiBold.family, size: 18)
    static let button2: Font = .custom(SsdamFontFamily.Pretendard.semiBold.family, size: 16)
    
    // body
    static let body1: Font = .custom(SsdamFontFamily.Pretendard.regular.family, size: 22)
    static let body2: Font = .custom(SsdamFontFamily.Pretendard.regular.family, size: 14)
    
    // caption
    static let caption: Font = .custom(SsdamFontFamily.Pretendard.regular.family, size: 16)
}
