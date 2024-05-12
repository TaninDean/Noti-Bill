//
//  FinancialAnalysisView.swift
//  Noti-Bill
//
//  Created by ธนิน ผิวเหลืองสวัสดิ์ on 12/5/2567 BE.
//

import SwiftUI
import Charts

struct FinancialAnalysisView: View {
    @StateObject private var viewModel = BillsViewModel()
    
    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                Text("Financial Overview")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .padding(.top, 20)

                VStack{
                    BarChartView(categoryValues: viewModel.categoryValues)
                }
                .frame(maxWidth: /*@START_MENU_TOKEN@*/.infinity/*@END_MENU_TOKEN@*/, minHeight: 150, maxHeight: 1000)
                .padding(.horizontal)

                PieChartView(availableCategory: viewModel.avaiableCategory)
                    .frame(height: 250)
                    .padding(.horizontal)
                
                CategoryButtonsView(availableCategory: viewModel.avaiableCategory)
                    .padding(.horizontal)

                TotalNavView(nav: viewModel.nav)
                    .padding()
            }
            .onAppear {
                viewModel.fetchBills()
            }
        }
        .background(Color("BackgroundColor").edgesIgnoringSafeArea(.all))
    }
}

struct BarChartView: View {
    var categoryValues:[CategoryValue] = [CategoryValue]([])
    
    var body: some View {
        Chart {
            ForEach(categoryValues) { item in
                BarMark(
                    x: .value("Category", item.category),
                    y: .value("Value", item.value)
                )
                .annotation(position: .top) {
                    Text("\(item.value)")
                }
            }
        }
        .chartYAxis {
            AxisMarks(position: .leading)
        }
    }
}

struct CategoryButtonsView: View {
    var availableCategory: [Category] = [Category]([])
    
    var body: some View {
        HStack(spacing: 10) {
            ForEach(availableCategory) { category in
                Text(category.name)
                    .padding()
                    .foregroundColor(.white)
                    .background(category.color)
                    .cornerRadius(10)
            }
        }
        .padding(.vertical)
    }
}

struct PieChartView: View {
    var availableCategory: [Category] = [Category]([])
    
    var body: some View {
        Chart {
            ForEach(availableCategory) { item in
                SectorMark(
                    angle: .value(item.name, item.value)
                )
                .foregroundStyle(item.color)
            }
        }
        .background(Color.white)
        .cornerRadius(10)
    }
}

struct TotalNavView: View {
    var nav: Double
    
    var body: some View {
        VStack {
            Text("Total NAV")
                .font(.title)
                .foregroundColor(.gray)
                .bold()
            Text("\(nav, specifier: "%.2f")")
                .font(.title)
                .bold()
        }
        .padding()
        .background(Color.white)
        .cornerRadius(10)
        .shadow(radius: 10)
    }
}

struct FinancialAnalysis_Previews: PreviewProvider {
    static var previews: some View {
        FinancialAnalysisView()
            .environmentObject(BillsViewModel())
    }
}
