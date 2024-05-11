//
//  LoginView.swift
//  Noti-Bill
//
//  Created by ธนิน ผิวเหลืองสวัสดิ์ on 17/4/2567 BE.
//

import SwiftUI
import Firebase

struct LoginView: View {
    @StateObject private var authManager = AuthManager.shared
    @State private var email = ""
    @State private var password = ""
    @State private var errorMessage = ""
    @State private var authen = false

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

            if !errorMessage.isEmpty {
                Text(errorMessage)
                    .foregroundColor(.red)
            }
            NavigationStack {
                VStack {
                    Button {
                        authManager.signIn(email: email, password: password) { error in
                            if let error = error {
                                print("Login error:", error)
                            } else {
                                print("Login success")
                                authen = true
                            }
                        }
                    } label: {
                        Text("Login").foregroundStyle(Color.white).background(Color.blue).frame(height: /*@START_MENU_TOKEN@*/100/*@END_MENU_TOKEN@*/).frame(maxWidth: /*@START_MENU_TOKEN@*/.infinity/*@END_MENU_TOKEN@*/).cornerRadius(10)
                    }
                }
            }.navigationDestination(isPresented: $authen) {
                ContentView()
            }
            
            HStack{
                Text("No account? : ")
                NavigationStack {
                    NavigationLink{
                        RegisterView()
                    } label: {
                        Text("Regsiter").foregroundStyle(Color.blue)
                    }
                }
                if let error = authManager.error {
                    Text("Error: \(error.localizedDescription)")
                        .foregroundColor(.red)
                }
            }.frame(maxWidth: .infinity, alignment: .center)
            
        }
        .padding()
        .background(Color("BakcgroundColor"))
    }
    
}


struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            LoginView()
        }
    }
}
