import SwiftUI
import Charts

struct Product: Identifiable {
    let id = UUID()
    let title: String
    let revenue: Double
}

struct StatementView: View {
    @State private var availableCredit: Float
    
    init() {
        let credit = UserDefaults.standard.float(forKey: "availableCredit")
        _availableCredit = State(initialValue: credit)
    }
    
    @StateObject private var viewModel = BillsViewModel()

    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                // Header
            
                Text("STATEMENT")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .padding().frame(maxWidth: .infinity, alignment: .center)

                // Pie Chart Placeholder
                // You would replace this with a pie chart from a library or custom implementation
                VStack {
                    Text("Pie Chart")
                        .font(.headline)
                        .padding(.bottom, 5)
                    
                    // This is just a placeholder for the pie chart
                    ZStack {
                        Circle()
                            .fill(Color.gray.opacity(0.2))
                        VStack {
                            Chart(viewModel.products) { product in
                                        SectorMark(
                                            angle: .value(
                                                Text(verbatim: product.title),
                                                product.revenue
                                            )
                                        )
                                        .foregroundStyle(
                                            by: .value(
                                                Text(verbatim: product.title),
                                                product.title
                                            )
                                        )
                                    }
                        }
                    }
                    .frame(height: 200)
                    .padding()
                }
                .background(Color.black.opacity(0.1))
                .cornerRadius(10)
                .frame(maxWidth: .infinity, alignment: .center)

                // List of funds
                ForEach(viewModel.monthlyTotals, id: \.0) { data in
                    let (month, percentage, totalNav) = data
                    VStack(alignment: .leading) {
                        Text("Month: \(month)")
                            .fontWeight(.semibold)
                        HStack {
                            Text("Percentage: \((totalNav * 100)/100000, specifier: "%.2f") %")
                            Spacer()
                            Text("Total Nav: \(totalNav, specifier: "%.2f")")
                        }
                    }
                    .padding()
                    .background(Color.white)
                    .cornerRadius(10)
                }
            }
            .padding()
        }
        .background(Color("BakcgroundColor"))
        .onAppear {
            Task {
                viewModel.fetchBills()
            }
        }
       
    }
    
    private var emptyChartPlaceholder: some View {
            ZStack {
                Circle()
                    .fill(Color.gray.opacity(0.2))
                Text("No data to display")
                    .foregroundColor(.gray)
                    .font(.caption)
            }
            .frame(height: 200)
            .padding()
        }
}

struct StatementUI_Previews: PreviewProvider {
    static var previews: some View {
        StatementView()
    }
}
