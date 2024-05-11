//
//  AuthManger.swift
//  Noti-Bill
//
//  Created by ธนิน ผิวเหลืองสวัสดิ์ on 17/4/2567 BE.
//

import Firebase
import FirebaseAuth

class AuthManager: ObservableObject {
    @Published var user: User? = nil
    @Published var error: Error? = nil

    static let shared = AuthManager()

    private init() {
        Auth.auth().addStateDidChangeListener { [weak self] auth, user in
            self?.user = user
        }
    }

    func signIn(email: String, password: String, completion: @escaping (Error?) -> Void) {
        Auth.auth().signIn(withEmail: email, password: password) { result, error in
            if let error = error {
                self.error = error
                completion(error)
            } else {
                self.error = nil
                if let user = result?.user {
                    UserDefaults.standard.set(user.uid, forKey: "id")
                }
                completion(nil)
            }
        }
    }

    func register(email: String, password: String, completion: @escaping (Error?) -> Void) {
        Auth.auth().createUser(withEmail: email, password: password) { result, error in
            if let error = error {
                self.error = error
                completion(error)
            } else {
                self.error = nil
                completion(nil)
            }
        }
    }

    func signOut() {
        do {
            try Auth.auth().signOut()
        } catch {
            print("Error signing out:", error)
        }
    }
}
