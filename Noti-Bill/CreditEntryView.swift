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
            Text("Enter your credit:")
            TextField("Credit", text: $creditInput)
                .keyboardType(.decimalPad)
                .textFieldStyle(RoundedBorderTextFieldStyle())
            Button("Submit") {
                if let credit = Float(creditInput) {
                    UserDefaults.standard.set(credit, forKey: "availableCredit")
                    availableCredit = credit
                    dismiss()
                }
            }
            .disabled(creditInput.isEmpty)
        }
        .padding()
    }
}

