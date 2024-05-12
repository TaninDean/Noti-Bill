//
//  FillBillForm.swift
//  Noti-Bill
//
//  Created by ธนิน ผิวเหลืองสวัสดิ์ on 12/5/2567 BE.
//

import SwiftUI

import SwiftUI
import Firebase

struct FillBillForm: View {
    @Binding var showingPopup: Bool
    var onDismiss: () -> Void = {}
    @State private var name: String = ""
    @State private var group: String = "Bill"
    @State private var price: String = ""
    @State private var installment: String = ""
    @State private var fee: String = ""

    let categories = [
        ("Entertainment", Color.green),
        ("Food", Color.red),
        ("Cloth", Color.blue),
        ("Movie", Color.orange),
        ("Investment", Color.yellow),
        ("Save", Color.pink),
        ("Bill", Color.purple)
    ]

    var body: some View {
        VStack(alignment: .center, spacing: 20) {
            // Close button at the top
            HStack {
                Spacer()
                Button(action: {
                    showingPopup = false
                }) {
                    Image(systemName: "xmark.circle.fill")
                        .foregroundColor(Color.gray)
                        .font(.title)
                }
            }
            .padding(.horizontal, 20)
            .padding(.top, 10)

            Text("Fill Bill")
                .font(.title)
                .fontWeight(.bold)
                .padding(.bottom, 20)

            // Form fields
            Group {
                CustomFillBillTextField(placeholder: "Name", text: $name)

                Menu {
                    Picker("Select Category", selection: $group) {
                        ForEach(categories, id: \.0) { category in
                            Text(category.0).tag(category.0)
                        }
                    }
                } label: {
                    HStack {
                        Text(group)
                            .foregroundColor(.black)
                        Spacer()
                        Image(systemName: "chevron.down")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 10, height: 6)
                            .foregroundColor(.gray)
                    }
                    .padding(.vertical, 12)
                    .padding(.horizontal)
                    .background(Color.gray.opacity(0.1))
                    .cornerRadius(8)
                    .foregroundColor(Color.black)
                }

                CustomFillBillTextField(placeholder: "Price", text: $price)
                CustomFillBillTextField(placeholder: "Installment", text: $installment)
                CustomFillBillTextField(placeholder: "Fee", text: $fee)
            }
            .padding(.horizontal)

            // Save button
            Button("SAVE") {
                let uuid = UserDefaults.standard.string(forKey: "id")
                        let currentTime = Date()
                        let data: [String: Any] = [
                          "date": currentTime.timeIntervalSince1970,
                          "name": name,
                          "group": group,
                          "price": price,
                          "installment": installment,
                          "fee": fee
                        ]
                        FirestoreManager().addData(collectionName: "UserBills", uuid: uuid!, data: data)
                        showingPopup = false
                        self.onDismiss()
            }
            .buttonStyle(FillButtonStyle())

            Spacer()
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.white)
        .cornerRadius(20)
        .shadow(radius: 10)
        .padding(.horizontal, 10)
    }
}

struct CustomFillBillTextField: View {
    var placeholder: String
    @Binding var text: String

    var body: some View {
        TextField(placeholder, text: $text)
            .padding(.vertical, 12)
            .padding(.horizontal)
            .background(Color.gray.opacity(0.1))
            .cornerRadius(8)
            .overlay(RoundedRectangle(cornerRadius: 8).stroke(Color.blue, lineWidth: 1))
    }
}

struct FillButtonStyle: ButtonStyle {
    func makeBody(configuration: Self.Configuration) -> some View {
        configuration.label
            .foregroundColor(.white)
            .padding()
            .background(LinearGradient(gradient: Gradient(colors: [Color.blue, Color.purple]), startPoint: .leading, endPoint: .trailing))
            .cornerRadius(10)
            .padding(.horizontal)
            .scaleEffect(configuration.isPressed ? 0.98 : 1.0)
    }
}

struct FillBillForm_Previews: PreviewProvider {
    static var previews: some View {
        FillBillForm(showingPopup: .constant(true))
    }
}


