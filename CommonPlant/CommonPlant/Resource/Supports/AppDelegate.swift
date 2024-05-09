//
//  AppDelegate.swift
//  CommonPlant
//
//  Created by 이예원 on 2023/07/04.
//

import UIKit
//import FirebaseCore
import UserNotifications
//import FirebaseMessaging
import RxKakaoSDKCommon

@main
class AppDelegate: UIResponder, UIApplicationDelegate, UNUserNotificationCenterDelegate {
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
     //   FirebaseApp.configure()
        if let appKey = Bundle.main.object(forInfoDictionaryKey: "KAKAO_APP_KEY") as? String {
            RxKakaoSDK.initSDK(appKey: appKey)
        }
        
        if #available(iOS 15.0, *) {
            let appearance = UITabBarAppearance()
            appearance.configureWithOpaqueBackground()
            appearance.backgroundColor = .white
            UITabBar.appearance().standardAppearance = appearance
            UITabBar.appearance().scrollEdgeAppearance = UITabBar.appearance().standardAppearance
        }
        
//        Messaging.messaging().delegate = self
//        Messaging.messaging().isAutoInitEnabled = true

        UIApplication.shared.registerForRemoteNotifications()
        UNUserNotificationCenter.current().delegate = self
        application.registerForRemoteNotifications()
        
        return true
    }
    
    
//    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
//        Messaging.messaging().apnsToken = deviceToken
//        let deviceTokenString = deviceToken.map { String(format: "%02x", $0) }.joined()
//        print("deviceTokenString:\(deviceTokenString)")
//    }
//    
//    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String?) {
//        print("fcmToken: \(fcmToken)")
//                pushAlarmViewModel.sendFcmToken(token: fcmToken ?? "")
//                    .subscribe(onNext: { response in
//                        print(response)
//                    })
//                    .disposed(by: disposeBag)
//    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter,willPresent notification: UNNotification,withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
           print("메시지 수신")
        completionHandler([.list, .badge, .sound])
       }
    
    // MARK: UISceneSession Lifecycle
    
    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }
    
    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }
    
    
}

