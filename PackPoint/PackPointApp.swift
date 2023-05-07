//
//  PackPointApp.swift
//  PackPoint
//
//  Created by Keegan Gaffney on 4/19/23.
//

import SwiftUI
import FirebaseCore
import Firebase
import FirebaseAuth
import UserNotifications


class AppDelegate: NSObject, UIApplicationDelegate, UNUserNotificationCenterDelegate {
    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        registerForRemoteNotifications()
        FirebaseApp.configure()

        return true
    }
    
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
            Auth.auth().setAPNSToken(deviceToken, type: .sandbox)
    }

    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable: Any], fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        if Auth.auth().canHandleNotification(userInfo) {
            completionHandler(.noData)
            return
        }
        // This notification is not for Auth, so handle it as appropriate for your app.
    }
    
    func registerForRemoteNotifications() {
        let center = UNUserNotificationCenter.current()
        center.delegate = self
        center.requestAuthorization(options: [.alert, .sound, .badge]) { granted, error in
            guard granted else { return }
            DispatchQueue.main.async {
                UIApplication.shared.registerForRemoteNotifications()
            }
        }
    }
}

@main
struct PackPointApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    
    var body: some Scene {
        WindowGroup {
            NavigationStack {
                if Auth.auth().currentUser != nil {
//                    Yay()
                    MainContentView()
                        .onAppear() {
                            let center = UNUserNotificationCenter.current()
                            center.requestAuthorization(options: [.alert, .sound, .badge]) { granted, error in
                                
                                if let error = error {
                                    print(error)
                                }
                            }
                        }
                } else {
                    Onboarding()
                        .onAppear() {
                            let center = UNUserNotificationCenter.current()
                            center.requestAuthorization(options: [.alert, .sound, .badge]) { granted, error in
                                
                                if let error = error {
                                    print(error)
                                }
                            }
                        }
                }
            }
        }
    }
}
