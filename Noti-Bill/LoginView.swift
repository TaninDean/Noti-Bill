import SwiftUI
import Firebase

struct LoginView: View {
    @StateObject private var authManager = AuthManager.shared
    @State private var email = ""
    @State private var password = ""
    @State private var errorMessage = ""
    @State private var authen = false
    
    var body: some View {
        NavigationStack {
            if authen { // Conditionally show ContentView
                  ContentView()
                }
            else {
                VStack {
                    Spacer()
                    Image("AppIcon")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 240, height: 240)
                        .foregroundColor(.blue)
                        .padding(.bottom, 50)

                    VStack(spacing: 15) {
                        HStack {
                            Image(systemName: "envelope")
                                .foregroundColor(.gray)
                                .frame(minWidth: 0, alignment: .leading)
                                .padding(.leading, 15)
                            TextField("Email", text: $email)
                                .padding(.horizontal)
                                .frame(height: 50)
                                .background(Color.white.opacity(0.7))
                                .cornerRadius(10)
                        }
                        HStack {
                            Image(systemName: "lock.fill")
                                .foregroundColor(.gray)
                                .frame(minWidth: 0, alignment: .leading)
                                .padding(.leading, 15)
                            SecureField("Password", text: $password)
                                .padding(.horizontal)
                                .frame(height: 50)
                                .background(Color.white.opacity(0.7))
                                .cornerRadius(10)
                        }
                    }
                    .padding(.horizontal, 20)

                    if !errorMessage.isEmpty {
                        Text(errorMessage)
                            .foregroundColor(.red)
                            .padding()
                    }

                    Button(action: {
                        authManager.signIn(email: email, password: password) { error in
                            if let error = error {
                                errorMessage = error.localizedDescription
                            } else {
                                authen = true
                            }
                        }
                    }) {
                        Text("Login")
                            .fontWeight(.bold)
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .frame(height: 50)
                            .background(LinearGradient(gradient: Gradient(colors: [Color.blue, Color.purple]), startPoint: .leading, endPoint: .trailing))
                            .cornerRadius(10)
                    }
                    .padding(.horizontal, 20)
                    .padding(.top, 20)

                    Spacer()

                    NavigationLink(destination: RegisterView()) {
                        Text("No account? Register")
                            .foregroundColor(.blue)
                    }
                    .padding(.bottom, 20)
                }
                .background(Color("BakcgroundColor").edgesIgnoringSafeArea(.all))
                .navigationBarHidden(true)
            }
            }
            
    }
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView()
    }
}
