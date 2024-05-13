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

struct CategoryValue: Identifiable {
    let id = UUID()
    let category: String
    let value: Int
}

struct Category: Identifiable {
    let id = UUID()
    let name: String
    let color: Color
    let value: Double
}

class BillsViewModel: ObservableObject {
    @Published var bills = [Bill]()
    @Published var showingPopup = false
    @Published var totalForPeriod: Double = 0.0
    @Published var monthlyTotals: [(String, Double, Double)] = []
    @Published var products: [Product] = []
    @Published var categoryValues = [CategoryValue]()
    @Published var avaiableCategory = [Category]()
    @Published var nav = 0.0
    
    init() {
            fetchBills()
        }

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
                    self.calculateTotalForPeriod()
                    self.calculateMonthlyTotals()
                    self.updateProducts()
                    self.processBillsByGroupCategory()
                    self.processavailableCategory()
                } else if let error = error {
                    print("Error fetching bills: \(error)")
                }
            }
        }
    }
    
    func calculateTotalForPeriod() {
            let calendar = Calendar.current
            let now = Date()
            let startOfCurrentMonth = calendar.date(from: calendar.dateComponents([.year, .month, .day], from: now))!
            print(startOfCurrentMonth)
            let previousMonth = calendar.date(byAdding: .month, value: -1, to: startOfCurrentMonth)!

            let twentyFifthOfLastMonth = calendar.date(byAdding: .day, value: 24, to: previousMonth)!
            let twentyFifthOfThisMonth = calendar.date(byAdding: .day, value: 24, to: startOfCurrentMonth)!
        
            let twentyFifthOfLastMonthTimestamp = twentyFifthOfLastMonth.timeIntervalSince1970
            let twentyFifthOfThisMonthTimestamp = twentyFifthOfThisMonth.timeIntervalSince1970

            totalForPeriod = bills.reduce(0) { result, bill in
                if bill.date >= twentyFifthOfLastMonthTimestamp && bill.date <= twentyFifthOfThisMonthTimestamp {
                    let adjustedInstallment = max(1, bill.installment)
                    return result + bill.price
                }
                return result
            }
        }
    
    func calculateMonthlyTotals() {
            let calendar = Calendar.current
            
            // Convert each bill's date from Double to Date before grouping
            let grouped = Dictionary(grouping: bills) { bill -> DateComponents in
                let billDate = Date(timeIntervalSince1970: bill.date)
                return calendar.dateComponents([.year, .month], from: billDate)
            }

            // Calculate the sum for each group
            monthlyTotals = grouped.map { key, value in
                let monthYear = "\(calendar.monthSymbols[key.month! - 1])-\(key.year!)"
                let total = value.reduce(0.0) { result, bill in
                    result + (bill.price + bill.price * bill.fee / 100) / bill.installment
                }
                return (monthYear, 25.25, total) // Adjust as needed
            }.sorted { $0.0 < $1.0 }
            print("Monthly Totals Updated: \(monthlyTotals)")
        }
    
    func updateProducts() {
        let totalRevenue = monthlyTotals.reduce(0.0) { $0 + $1.2 }
        print("Total revenue \(totalRevenue)")
        products = monthlyTotals.map { (month, _, revenue) in
            Product(title: month, revenue: revenue / totalRevenue)
        }
        print("Product \(products)" )
    }
    
    func processBillsByGroupCategory() {
        var categoryTotals: [String: Double] = [:]

        // Aggregate total prices by group
        for bill in bills {
            categoryTotals[bill.category, default: 0] += bill.price
        }

        // Create category value list
        self.categoryValues = categoryTotals.map { CategoryValue(category: $0.key, value: Int($0.value)) }
    }
    
    private func processavailableCategory() {
        let colorMap: [String: Color] = [
            "Entertainment": .green,
            "Food": .red,
            "Cloth": .blue,
            "Movie": .orange,
            "Investment": .yellow,
            "Save": .pink,
            "Bill": .purple
        ]

        var categoryTotals: [String: Double] = [:]

        for bill in bills {
            categoryTotals[bill.category, default: 0] += bill.price
        }

        self.avaiableCategory = categoryTotals.map { (key, value) in
            Category(name: key, color: colorMap[key, default: .gray], value: value)
        }.sorted { $0.name < $1.name }
        
        self.nav =  self.avaiableCategory.reduce(0) { sum, category in
                sum + category.value
            }
    }
    
}



