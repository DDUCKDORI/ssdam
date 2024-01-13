//
//  MainRepository.swift
//  Domain
//
//  Created by 김재민 on 1/11/24.
//  Copyright © 2024 com.dduckdori. All rights reserved.
//

import Combine
import Foundation
import Networking
import SwiftyJSON

public protocol MainRepository: AnyObject {
    func fetchQuestionByUser(id: String) async -> JSON
    func fetchAnswer(id: String) async -> JSON
    func fetchAllAnswers(id: String) async -> [JSON]
    func postAnswer(request: PostAnswerBody) async -> JSON
    func modifyAnswer(request: PostAnswerBody) async -> JSON
}
