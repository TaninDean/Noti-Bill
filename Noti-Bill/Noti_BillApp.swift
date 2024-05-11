//
//  Noti_BillApp.swift
//  Noti-Bill
//
//  Created by ธนิน ผิวเหลืองสวัสดิ์ on 15/4/2567 BE.
//

import SwiftUI
import FirebaseCore


class AppDelegate: NSObject, UIApplicationDelegate {
  func application(_ application: UIApplication,
                   didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
    FirebaseApp.configure()

    return true
  }
}

@main
struct NotiBillApp: App {
    
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    
    var body: some Scene {
        WindowGroup {
            LaunchView()
        }
    }
}

struct LaunchView: View {
    @State private var isActive = false // State to handle the visibility of ContentView
    
    var body: some View {
        Group {
            if isActive {
                LoginView()
            } else {
                IconUIView()
            }
        }
        .onAppear {
            // Set a delay of 5 seconds before switching views
            DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
                withAnimation {
                    self.isActive = true
                }
            }
        }
    }
}
