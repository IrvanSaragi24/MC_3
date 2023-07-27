//
//  MC_3App.swift
//  MC_3
//
//  Created by Irvan P. Saragi on 14/07/23.
//

import SwiftUI

@main
struct MC_3App: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    @State private var showSplash = true
   
    var body: some Scene {
        WindowGroup {
            if showSplash {
                SplashScreenView()
                    
                    .onAppear {
                        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                            withAnimation {
                                showSplash = false
                            }
                        }
                    }
            } else {
                HangOutView()
                    
            }
        }
    }
}

// Implementing the AppDelegate
class AppDelegate: NSObject, UIApplicationDelegate, UNUserNotificationCenterDelegate {
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Request notification authorization
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound]) { _, _ in }
        application.registerForRemoteNotifications()

        // Set the UNUserNotificationCenter delegate
        UNUserNotificationCenter.current().delegate = self

        return true
    }

    // Handle notification tap when app is in the foreground
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        if response.notification.request.identifier == "VoiceDetectingStopped" {
            if let notificationFlag = response.notification.request.content.userInfo["notificationFlag"] as? Bool, notificationFlag {
                // User tapped on the notification with the flag to run quizTime()
                // Handle the next operation or open the next screen here
                // For example, you can present the ListenView or perform the quizTime() method
                // You might need to check the app state (background/foreground) here to proceed accordingly.

                // Note: To present the ListenView, you may need to navigate to the correct navigation stack.
                // For example, if your app uses a coordinator pattern, you can ask the coordinator to show the ListenView.

                // Remove the flag after processing
                UserDefaults.standard.removeObject(forKey: "QuizTimeFromNotification")
                UserDefaults.standard.synchronize()
            } else {
                // Handle other types of notifications (if any)
            }
        }

        completionHandler()
    }
}
