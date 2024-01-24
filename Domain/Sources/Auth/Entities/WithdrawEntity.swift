//
//  WithdrawEntity.swift
//  Domain
//
//  Created by 김재민 on 1/24/24.
//  Copyright © 2024 com.dduckdori. All rights reserved.
//

import Foundation
import SwiftyJSON

public struct WithdrawEntity: Equatable {
    public var result: String
    public var message: String
    
    init(_ json: JSON) {
        self.result = json["result"].stringValue
        self.message = json["message"].stringValue
    }
}

