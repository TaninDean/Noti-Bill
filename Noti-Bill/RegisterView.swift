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
    @State private var errorMessage = ""
    @State private var confirmPassword = ""
    @State private var pass = false
    
    var body: some View {
        VStack {
            Image("AppIcon")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 300, height: 300)
            TextField("Email", text: $email)
                .autocapitalization(.none)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()
            
            SecureField("Password", text: $password)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()
            
            SecureField("ConfirmPassword", text:  $confirmPassword)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()
            
            if !errorMessage.isEmpty {
                Text(errorMessage)
                    .foregroundColor(.red)
            }
            NavigationStack {
                Button("Register") {
                    if password != confirmPassword {
                        print("Passwords don't match")
                        Alert(title: Text("Passwords don't match"))
                        return
                    }
                    authManager.register(email: email, password: password) { error in
                        if let error = error {
                            print("Registration error : ", error)
                        } else {
                            print("Register successful")
                            pass = true
                        }
                    }
                }
            }
            .background(Color("BakcgroundColor"))
        }.navigationDestination(isPresented: $pass) {
            LoginView()
        }
    }
}

struct RegisterView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            RegisterView()
        }
    }
}
