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
        var string = ""
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
        
        if self.contains(".") || self.contains("+") {
            string = self.components(separatedBy: [".", "+"])[0]
        }
        
        guard let date = dateFormatter.date(from: string) else {
            return ""
        }
        dateFormatter.dateFormat = format.rawValue
        return dateFormatter.string(from: date)
    }
    
    var toDate: Date? {
        var string = ""
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
        
        if self.contains(".") || self.contains("+") {
            string = self.components(separatedBy: [".", "+"])[0]
        }
        guard let date = formatter.date(from: string) else { return nil }
        return date
    }
    
    func withAttributed(_ font: Font = .pButton4) -> AttributedString {
        var text = AttributedString(stringLiteral: self)
        text.font = font
        text.foregroundColor = Color(.mint50)
        return text
    }
}
