//
//  DateComponentExtension.swift
//  Ssdam
//
//  Created by 김재민 on 1/14/24.
//  Copyright © 2024 com.dduckdori. All rights reserved.
//

import Foundation

enum DateFormatType: String {
    case dash = "yyyy-MM-dd"
    case withoutDash = "yyyyMMdd"
    case dot = "yyyy.MM.dd"
}

extension DateComponents {
    func toString(_ format: DateFormatType) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format.rawValue
        
        guard let date = Calendar.current.date(from: self) else {
            return ""
        }
        return dateFormatter.string(from: date)
    }
    
    func isEqual(to other: DateComponents) -> Bool {
        return self.day == other.day && self.month == other.month && self.year == other.year
    }
}

extension Date {
    var dateToComponents: DateComponents {
        let calendar = Calendar.current
        let components = calendar.dateComponents([.year, .month, .day, .hour, .minute, .second], from: self)
        return components
    }
}
