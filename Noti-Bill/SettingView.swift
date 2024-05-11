import SwiftUI

struct SettingView: View {
    @State private var notificationSetting = true
    @State private var pushNotification = true
    @State private var emailNotification = false

    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Notification setting")
                            .font(.headline)
                            .foregroundColor(.black))
                {
                    Toggle("Enable to notify all", isOn: $notificationSetting)
                    Toggle("Receive monthly notify", isOn: $pushNotification)
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
