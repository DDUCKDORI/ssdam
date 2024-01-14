//
//  StringExtension.swift
//  Ssdam
//
//  Created by 김재민 on 1/15/24.
//  Copyright © 2024 com.dduckdori. All rights reserved.
//

import Foundation

extension String {
    func convertToDotFormat() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZZZZZ"
        
        guard let date = dateFormatter.date(from: self) else {
            return ""
        }
        dateFormatter.dateFormat = "yyyy.MM.dd"
        return dateFormatter.string(from: date)
    }
}
