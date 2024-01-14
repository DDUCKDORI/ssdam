//
//  DateComponentExtension.swift
//  Ssdam
//
//  Created by 김재민 on 1/14/24.
//  Copyright © 2024 com.dduckdori. All rights reserved.
//

import Foundation

extension DateComponents {
    func toYYYYMMDDString() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyyMMdd"
        
        guard let date = Calendar.current.date(from: self) else {
            return ""
        }
        return dateFormatter.string(from: date)
    }
}
