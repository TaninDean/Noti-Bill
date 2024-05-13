//
//  RegisterView.swift
//  Noti-Bill
//
//  Created by ธนิน ผิวเหลืองสวัสดิ์ on 17/4/2567 BE.
//

import SwiftUI
import Firebase

struct RegisterView: View {
    @StateObject private var authManager = AuthManager.shared
    @State private var email = ""
    @State private var password = ""
    @State private var confirmPassword = ""
    @State private var errorMessage = ""
    @State private var pass = false

    var body: some View {
        NavigationView {
            VStack {
                Spacer()
                
                Image(systemName: "person.crop.circle.badge.plus")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 100, height: 100)
                    .foregroundColor(.blue)
                    .padding(.bottom, 50)
                
                VStack(spacing: 20) {
                    CustomTextField(placeholder: Text("Email").foregroundColor(.gray), text: $email)
                        .padding()
                        .background(Color.white.opacity(0.7))
                        .cornerRadius(10)
                        .overlay(RoundedRectangle(cornerRadius: 10).stroke(Color.blue, lineWidth: 1))

                    CustomSecureField(placeholder: Text("Password").foregroundColor(.gray), text: $password)
                        .padding()
                        .background(Color.white.opacity(0.7))
                        .cornerRadius(10)
                        .overlay(RoundedRectangle(cornerRadius: 10).stroke(Color.blue, lineWidth: 1))

                    CustomSecureField(placeholder: Text("Confirm Password").foregroundColor(.gray), text: $confirmPassword)
                        .padding()
                        .background(Color.white.opacity(0.7))
                        .cornerRadius(10)
                        .overlay(RoundedRectangle(cornerRadius: 10).stroke(Color.blue, lineWidth: 1))
                }
                .padding(.horizontal, 20)
                
                if !errorMessage.isEmpty {
                    Text(errorMessage)
                        .foregroundColor(.red)
                        .padding()
                }

                Button("Register") {
                    if password != confirmPassword {
                        errorMessage = "Passwords don't match"
                        return
                    }
                    authManager.register(email: email, password: password) { error in
                        if let error = error {
                            errorMessage = error.localizedDescription
                        } else {
                            errorMessage = "Registration successful"
                            pass = true
                        }
                    }
                }
                .foregroundColor(.white)
                .padding()
                .frame(maxWidth: .infinity)
                .background(LinearGradient(gradient: Gradient(colors: [Color.blue, Color.purple]), startPoint: .leading, endPoint: .trailing))
                .cornerRadius(10)
                .padding(.horizontal, 20)
                
                Spacer()
            }
            .background(Color("BakcgroundColor").edgesIgnoringSafeArea(.all))
            .navigationBarTitle("Register", displayMode: .inline)
            .sheet(isPresented: $pass) {
            CustomDialog(isActive: $pass, title: "Registration Successful.", message: "You can now log in.", buttonTitle: "Close", showButton: false, action: {
                print("Dialog closed")
            })
        }
        }
    }
}

struct CustomTextField: View {
    var placeholder: Text
    @Binding var text: String

    var body: some View {
        ZStack(alignment: .leading) {
            if text.isEmpty { placeholder }
            TextField("", text: $text).foregroundColor(.black)
        }
    }
}

struct CustomSecureField: View {
    var placeholder: Text
    @Binding var text: String

    var body: some View {
        ZStack(alignment: .leading) {
            if text.isEmpty { placeholder }
            SecureField("", text: $text).foregroundColor(.black)
        }
    }
}

struct RegisterView_Previews: PreviewProvider {
    static var previews: some View {
        RegisterView()
    }
}
