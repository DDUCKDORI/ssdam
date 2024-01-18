//
//  LocalNotificationHelper.swift
//  Ssdam
//
//  Created by 김재민 on 1/17/24.
//  Copyright © 2024 com.dduckdori. All rights reserved.
//

import Foundation
import UIKit

final public class LocalNotificationHelper {
    static let shared = LocalNotificationHelper()
    
    private init() { }
    
    func setAuthorization() {
        let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound] // 필요한 알림 권한을 설정
        UNUserNotificationCenter.current().requestAuthorization(
            options: authOptions,
            completionHandler: { _, _ in
                self.pushNotification(title: "welcome", body: "이것은 로컬 푸시", seconds: 60, identifier: "TEST")
            }
        )
    }
    
    func pushNotification(title: String, body: String, seconds: Double, identifier: String) {
        // 1️⃣ 알림 내용, 설정
        let notificationContent = UNMutableNotificationContent()
        notificationContent.title = title
        notificationContent.body = body
        
        let currentDate = Date()
         var dateComponents = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute, .second], from: currentDate)
         dateComponents.hour = 9
         dateComponents.minute = 0
         dateComponents.second = 0
         
         guard let triggerDate = Calendar.current.date(from: dateComponents) else { return }
         
         let timeInterval = triggerDate.timeIntervalSinceNow

        // 2️⃣ 조건(시간, 반복)
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: getNotiTimeInterval(), repeats: true)

        // 3️⃣ 요청
        let request = UNNotificationRequest(identifier: identifier,
                                            content: notificationContent,
                                            trigger: trigger)

        // 4️⃣ 알림 등록
        UNUserNotificationCenter.current().add(request) { error in
            if let error = error {
                print("Notification Error: ", error)
            }
        }
    }
    
    private func getNotiTimeInterval() -> TimeInterval {
        let currentDate = Date()
         var dateComponents = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute, .second], from: currentDate)
         dateComponents.hour = 9
         dateComponents.minute = 0
         dateComponents.second = 0
         
        let triggerDate = Calendar.current.date(from: dateComponents)
         
        let timeInterval = triggerDate!.timeIntervalSinceNow
        
        return timeInterval
    }
}
