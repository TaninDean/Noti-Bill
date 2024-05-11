//
//  FillTheBillView.swift
//  Noti-Bill
//
//  Created by ธนิน ผิวเหลืองสวัสดิ์ on 15/4/2567 BE.
//

import SwiftUI

struct FillTheBillView: View {
    // Dummy data for the list of bills
    let bills = [
        (category: "Computer", installment: 10, price: 100, fee: 5, nextBill: 10.5),
        (category: "S&P", installment: 0, price: 100, fee: 0, nextBill: 100.0)
        // Add more bills as necessary
    ]
    
    @State private var showingPopup = false
    @StateObject private var viewModel = BillsViewModel()
    
    var body: some View {
        VStack {
            
            // Add button
            Button(action: {
                showingPopup = true
            }) {
                Image(systemName: "plus")
                    .foregroundColor(.black)
                    .padding()
                    .background(Color.gray.opacity(0.5))
                    .clipShape(Circle())
            }
            .padding(.bottom)
            
            
            // List of bills
            ScrollView {
                VStack(spacing: 20) {
                    ForEach(viewModel.bills) { bill in
                        VStack {
                            HStack(alignment: .top){
                                ZStack {
                                    Circle()
                                        .strokeBorder(Color.gray.opacity(0.2), lineWidth: 4)
                                    Circle()
                                        .trim(from: 0, to: CGFloat(12) / 12) // Assuming 12 is the max number of installments
                                        .stroke(Color.green, style: StrokeStyle(lineWidth: 4, lineCap: .round))
                                    Text(String(12))
                                        .font(.caption)
                                        .foregroundColor(.green)
                                }
                                .frame(width: 40, height: 40)

                                // Category
                                VStack{
                                    Text(bill.category)
                                        .fontWeight(.medium)
                                        .foregroundColor(.white)
                                        .padding(.horizontal, 8)
                                        .background(Color.gray.opacity(0.5))
                                        .cornerRadius(10)
                                }.frame(minWidth: 0, maxWidth: .infinity, alignment: .trailing)
                                
                                    
                            }
                                    

                            HStack {
                                // Installment
                                VStack {
                                    Text("Installment")
                                        .font(.caption)
                                        .foregroundColor(.gray)
                                    Text("\(bill.installment, specifier: "%0.2f")")
                                        .fontWeight(.bold)
                                        .foregroundColor(.white)
                                        .padding(.all, 4)
                                        .background(Color.red)
                                        .cornerRadius(5)
                                }.frame(minWidth: 0, maxWidth: .infinity)
                                
                                // Price and fee
                                VStack {
                                    Text("Price")
                                        .font(.caption)
                                        .foregroundColor(.gray)
                                    HStack {
                                        Text("\(bill.price, specifier: "%.2f")")
                                            .fontWeight(.bold)
                                        Text("+ \(bill.fee, specifier: "%.2f")%")
                                            .font(.caption)
                                            .foregroundColor(.gray)
                                    }
                                    .foregroundColor(.white)
                                    .padding(.all, 4)
                                    .background(Color.black.opacity(0.7))
                                    .cornerRadius(5)
                                }.frame(minWidth: 0, maxWidth: .infinity)
                                
                                // Next Bill
                                VStack {
                                    Text("Next Bill")
                                        .font(.caption)
                                        .foregroundColor(.gray)
                                    Text("\((bill.price + bill.price * bill.fee / 100)/bill.installment, specifier: "%.2f")")
                                        .fontWeight(.bold)
                                        .foregroundColor(.white)
                                        .padding(.all, 4)
                                        .background(Color.green)
                                        .cornerRadius(5)
                                }.frame(minWidth: 0, maxWidth: .infinity)
                            }
                            .frame(maxWidth: .infinity)

                        }
                        .padding()
                        .background(Color.white)
                        .cornerRadius(10)
                        .overlay(
                            RoundedRectangle(cornerRadius: 10)
                                .stroke(Color.green, lineWidth: 2)
                        )
                        .shadow(color: .gray, radius: 2, x: 0, y: 2)
                        .padding(.horizontal)
                        .foregroundColor(.black)
                        .frame(maxWidth: .infinity)
                    }
                }
                .padding()
                .frame(maxWidth: .infinity)
                .onAppear {
                    viewModel.fetchBills()
                }
            }
            .frame(maxWidth: .infinity)
            Spacer()
        }
        .background(Color("BakcgroundColor"))
        .navigationBarTitleDisplayMode(.inline)
        
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .sheet(isPresented: $showingPopup) {
            FillBillForm(showingPopup: $showingPopup, onDismiss: fetchData)
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
    
    private func fetchData() {
            viewModel.fetchBills()  // Refetch the data when the form is dismissed
        }
}

struct FillBillForm: View {
    @Binding var showingPopup: Bool
    var onDismiss: () -> Void
    @State private var name: String = ""
    @State private var group: String = ""
    @State private var price: String = ""
    @State private var installment: String = ""
    @State private var fee: String = ""

    var body: some View {
        VStack(spacing: 20) {
            // Close button at the top right corner of the popup
            HStack {
                Spacer()
                Button(action: {
                    showingPopup = false
                }) {
                    Image(systemName: "xmark")
                        .foregroundColor(.black)
                        .padding()
                        .background(Color.white)
                        .clipShape(Circle())
                }
            }
            .padding(.top)
            
            Text("Fill Bill")
                .font(.title)
                .fontWeight(.bold)
            
            // Form fields
            Group {
                TextField("Name", text: $name)
                TextField("Group", text: $group)
                TextField("Price", text: $price)
                HStack {
                    TextField("Installment", text: $installment)
                    TextField("Fee", text: $fee)
                }
            }
            .textFieldStyle(RoundedBorderTextFieldStyle())
            .padding()
            
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
            .foregroundColor(.white)
            .padding()
            .background(Color.blue)
            .clipShape(Capsule())

            Spacer()
        }
        .frame(width: .infinity, height: .infinity)
        .background(Color.white)
        .cornerRadius(12)
        .shadow(radius: 10)
    }

}


struct FillTheBillView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            FillTheBillView()
        }
    }
}

