import SwiftUI
import UserNotifications
import UserNotifications


struct SettingView: View {
    @State private var notificationSetting = false
    @State private var pushNotification = false
    @State private var emailNotification = false
    
    init() {
        let notify = UserDefaults.standard.bool(forKey: "notificationSetting")
        let pushNotify = UserDefaults.standard.bool(forKey: "pushNotificationSetting")
        print("notify : \(notify)")
        print("notify : \(pushNotify)")
        _notificationSetting = State(initialValue: notify)
        _pushNotification = State(initialValue: pushNotify)
    }
    
    func requestNotificationPermission() {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound]) { granted, error in
            if granted {
                print("Notification permission granted.")
            } else if let error = error {
                print("Notification permission denied because: \(error.localizedDescription).")
            }
        }
    }
    
    func scheduleMonthlyNotification() {
        let content = UNMutableNotificationContent()
        content.title = "Monthly Reminder"
        content.body = "This is your monthly notification."
        content.sound = UNNotificationSound.default

        var dateComponents = DateComponents()
        dateComponents.day = 13

        let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: true)

        let request = UNNotificationRequest(identifier: "monthlyNotification", content: content, trigger: trigger)

        UNUserNotificationCenter.current().add(request) { error in
            if let error = error {
                print("Error scheduling notification: \(error)")
            } else {
                print("Monthly notification scheduled.")
            }
        }
    }

    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Notification setting")
                            .font(.headline)
                            .foregroundColor(.black)) {
                    Toggle("Enable to notify all", isOn: $notificationSetting)
                        .onChange(of: notificationSetting) { value in
                            UserDefaults.standard.set(notificationSetting, forKey: "notificationSetting")
                            if value {
                                requestNotificationPermission()
                                
                            }
                        }
                    Toggle("Receive monthly notify", isOn: $pushNotification)
                        .onChange(of: pushNotification) { value in
                            UserDefaults.standard.set(pushNotification, forKey: "pushNotificationSetting")
                            if value {
                                scheduleMonthlyNotification()
        
                            }
                        }
                    Toggle("Receive monthly notify via email", isOn: $emailNotification)
                }
                .toggleStyle(SwitchToggleStyle(tint: .purple))
            }
            .navigationTitle("Notification")
            .navigationBarTitleDisplayMode(.inline)
        }
    }

    var backButton: some View {
        Button(action: {
            // Action to go back
        }) {
            Image(systemName: "chevron.left")
                .foregroundColor(.black)
        }
    }
}

struct SettingUI_Previews: PreviewProvider {
    static var previews: some View {
        SettingView()
    }
}
