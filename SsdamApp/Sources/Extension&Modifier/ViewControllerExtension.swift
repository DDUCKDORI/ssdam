//
//  ViewControllerExtension.swift
//  Ssdam
//
//  Created by 김재민 on 2/6/24.
//  Copyright © 2024 com.dduckdori. All rights reserved.
//

import Foundation
import UIKit

extension UIViewController {
    var screen: UIScreen? {
        guard let window = UIApplication.shared.connectedScenes.first as? UIWindowScene else {
            return view.window?.windowScene?.screen
        }
        return window.screen
    }
}
