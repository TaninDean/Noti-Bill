//
//  BillsViewModel.swift
//  Noti-Bill
//
//  Created by ธนิน ผิวเหลืองสวัสดิ์ on 1/5/2567 BE.
//

import SwiftUI
import Combine

struct Bill: Identifiable {
    var id: String
    let name: String
    let date: Double
    let category: String
    let price: Double
    let installment: Double
    let fee: Double
}

class BillsViewModel: ObservableObject {
    @Published var bills = [Bill]()
    @Published var showingPopup = false

    func fetchBills() {
        let id = UserDefaults.standard.string(forKey: "id") ?? ""
        FirestoreManager().fetchBills(collectionName: "UserBills", uuid: id) { data, error in
            DispatchQueue.main.async {
                if let data = data as? [[String: Any]] { // Ensure that data is cast to the correct type
                    self.bills = data.compactMap { dict in
                            guard
                                let name = dict["name"] as? String,
                                let date = dict["date"] as? Double,
                                let group = dict["group"] as? String,
                                let fee = dict["fee"] as? String,
                                let installment = dict["installment"] as? String,
                                let price = dict["price"] as? String else {
                            print("Error parsing one of the bills")
                            return nil
                        }
                        let parsePrice = Double(price)!
                        let parseFee = Double(fee)!
                        let parseInstallment = Double(installment)!
                        return Bill(id: UUID().uuidString, name: name, date: date,category: group,
                                    price: parsePrice, installment: parseInstallment, fee: parseFee
                        )
                    }
                } else if let error = error {
                    print("Error fetching bills: \(error)")
                }
            }
        }
    }
}



