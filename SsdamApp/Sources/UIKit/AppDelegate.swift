//
//  AppDelegate.swift
//  Ssdam
//
//  Created by 김재민 on 2023/11/30.
//  Copyright © 2023 com.dduckdori. All rights reserved.
//

//import FirebaseCore
import UIKit
import CoreData
import Networking

@main
class AppDelegate: NSObject, UIApplicationDelegate {
    var window: UIWindow?
    let screenRouter = ScreenRouter(factory: .init())
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]? = nil) -> Bool {
        //        FirebaseApp.configure()
        
        navigationBarConfigure()
        let window = UIWindow(frame: UIScreen.main.bounds)
        self.window = window
        let launchView = LaunchView(store: .init(initialState: LaunchReducer.State(), reducer: {
            LaunchReducer()
        }))
        screenRouter.start(window: window, rootView: launchView)
        window.makeKeyAndVisible()
        
        
        UNUserNotificationCenter.current().delegate = self
        //        application.registerForRemoteNotifications()
        
        //        Messaging.messaging().delegate = self
        //
        //        Messaging.messaging().token { token, error in
        //          if let error = error {
        //            print("Error fetching FCM registration token: \(error)")
        //          } else if let token = token {
        //            print("FCM registration token: \(token)")
        //          }
        //        }
        
        
        return true
    }
    
    private func navigationBarConfigure() {
        let backButtonImage = UIImage(named: "chevron.left")?.withTintColor(.black, renderingMode: .alwaysOriginal)
        
        let standardAppearance = UINavigationBarAppearance()
        standardAppearance.backgroundColor = .white
        standardAppearance.setBackIndicatorImage(backButtonImage, transitionMaskImage: backButtonImage)
        
        let compactAppearance = UINavigationBarAppearance()
        compactAppearance.backgroundColor = .white
        compactAppearance.setBackIndicatorImage(backButtonImage, transitionMaskImage: backButtonImage)
        
        UINavigationBar.appearance().tintColor = .black
        UINavigationBar.appearance().standardAppearance = standardAppearance
        UINavigationBar.appearance().compactAppearance = compactAppearance
    }
    
    //    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
    //        Messaging.messaging().apnsToken = deviceToken
    //    }
}

//extension AppDelegate: MessagingDelegate {
//    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String?) {
//        print("Firebase registration token: \(String(describing: fcmToken))")
//
//        let dataDict: [String: String] = ["token": fcmToken ?? ""]
//        NotificationCenter.default.post(
//            name: Notification.Name("FCMToken"),
//            object: nil,
//            userInfo: dataDict
//        )
//        // TODO: If necessary send token to application server.
//        // Note: This callback is fired at each app startup and whenever a new token is generated.
//    }
//}

extension AppDelegate: UNUserNotificationCenterDelegate {
    // 푸시메세지가 앱이 켜져 있을때 나올때
    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                willPresent notification: UNNotification,
                                withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void)
    {
        let userInfo = notification.request.content.userInfo
        
        print("willPresent: userInfo: ", userInfo)
        
        completionHandler([.banner, .sound, .badge])
    }
    
    // 푸시메세지를 받았을 때
    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                didReceive response: UNNotificationResponse,
                                withCompletionHandler completionHandler: @escaping () -> Void)
    {
        let userInfo = response.notification.request.content.userInfo
        print("didReceive: userInfo: ", userInfo)
        completionHandler()
    }
    
    func applicationDidBecomeActive(_ application: UIApplication) {
        NetworkMonitor.shared.startNetworkMonitoring { status in
            if status == .notReachable {
                if let vc = UIApplication.shared.firstKeyWindow?.visibleViewController as? UIViewController {
                    let alert = UIAlertController(title: "네트워크 오류", message: "연결이 불안정합니다 동훈 개발자가 원인을 찾고 있습니다🤔", preferredStyle:UIAlertController.Style.alert)
                    let action1 = UIAlertAction(title:"확인", style: .default) { action in
                    }
                    alert.addAction(action1)
                    vc.present(alert, animated: true, completion: nil)
                }
            }
        }
    }
    
    func applicationWillTerminate(_ application: UIApplication) {
        NetworkMonitor.shared.stopNetworkMonitoring { status in
            print(status)
        }
    }
}
