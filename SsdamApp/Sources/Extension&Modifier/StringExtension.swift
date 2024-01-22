//
//  StringExtension.swift
//  Ssdam
//
//  Created by 김재민 on 1/15/24.
//  Copyright © 2024 com.dduckdori. All rights reserved.
//

import Foundation
import SwiftUI

extension String {
    func convertToDotFormat(_ format: DateFormatType) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZZZZZ"
        
        guard let date = dateFormatter.date(from: self) else {
            return ""
        }
        dateFormatter.dateFormat = format.rawValue
        return dateFormatter.string(from: date)
    }
    
    func withAttributed(_ font: Font = .pButton4) -> AttributedString {
        var text = AttributedString(stringLiteral: self)
        text.font = font
        text.foregroundColor = Color(.mint50)
        return text
    }
}
