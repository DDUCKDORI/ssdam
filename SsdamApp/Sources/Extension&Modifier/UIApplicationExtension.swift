//
//  UIApplicationExtension.swift
//  Ssdam
//
//  Created by 김재민 on 1/23/24.
//  Copyright © 2024 com.dduckdori. All rights reserved.
//

import Foundation
import UIKit

extension UIApplication {
    func getSafeAreaBottom()->CGFloat{
        let keyWindow = UIApplication.shared.connectedScenes
            .filter({$0.activationState == .foregroundActive})
            .map({$0 as? UIWindowScene})
            .compactMap({$0})
            .first?.windows
            .filter({$0.isKeyWindow}).first
        
        return (keyWindow?.safeAreaInsets.bottom)!
        
    }
}
