//
//  CreditEntryView.swift
//  Noti-Bill
//
//  Created by ธนิน ผิวเหลืองสวัสดิ์ on 30/4/2567 BE.
//

import SwiftUI

struct CreditEntryView: View {
    @Environment(\.dismiss) var dismiss
    @Binding var availableCredit: Float
    @State private var creditInput: String = ""

    var body: some View {
        VStack(spacing: 20) {
            Text("Enter Your Credit")
                .font(.title2)
                .fontWeight(.semibold)
                .foregroundColor(.primary)
                .padding(.top, 20)

            TextField("Credit amount", text: $creditInput)
                .keyboardType(.decimalPad)
                .padding()
                .background(Color(.systemGray6)) // Use system background color for subtlety
                .cornerRadius(10)
                .overlay(
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(Color.blue, lineWidth: 1)
                )
                .padding(.horizontal)

            Button("Submit") {
                if let credit = Float(creditInput) {
                    UserDefaults.standard.set(credit, forKey: "availableCredit")
                    availableCredit = credit
                    dismiss()
                }
            }
            .buttonStyle(SubmitButtonStyle())
            .padding(.horizontal)
            .disabled(creditInput.isEmpty)
        }
        .padding()
        .background(Color(.systemBackground)) // Ensure it looks good in both light and dark mode
        .cornerRadius(15)
        .shadow(radius: 10)
        .padding()
    }
}

struct SubmitButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .foregroundColor(.white)
            .padding()
            .background(LinearGradient(gradient: Gradient(colors: [Color.blue, Color.purple]), startPoint: .leading, endPoint: .trailing))
            .cornerRadius(10)
            .scaleEffect(configuration.isPressed ? 0.95 : 1.0)
            .animation(.easeOut, value: configuration.isPressed)
    }
}

struct CreditEntryView_Previews: PreviewProvider {
    static var previews: some View {
        CreditEntryView(availableCredit: .constant(100.0))
    }
}

