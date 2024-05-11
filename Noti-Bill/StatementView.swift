import SwiftUI
import Charts

struct Product: Identifiable {
    let id = UUID()
    let title: String
    let revenue: Double
}

struct StatementView: View {
    // Assuming you have a data model for your funds, you'd use that here
    // For simplicity, we'll use a static list
    let fundList = [
        ("January", 25.25, 100000),
        ("February", 25.25, 100000),
        ("March", 25.25, 100000),
        ("April", 25.25, 100000),
        ("May", 25.25, 100000)
        // Add more months as needed
    ]
    
    let data = [
            (value: 25, label: "January"),
            (value: 25, label: "February"),
            (value: 25, label: "March"),
            (value: 25, label: "April"),
            (value: 25, label: "May"),
            (value: 25, label: "June"),
            (value: 25, label: "July"),
            (value: 25, label: "August")
        ]
    
    
    @State private var products: [Product] = [
            .init(title: "Annual", revenue: 0.7),
            .init(title: "Monthly", revenue: 0.2),
            .init(title: "Lifetime", revenue: 0.1)
        ]
    
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
                    Text("Fund list")
                        .font(.headline)
                        .padding(.bottom, 5)
                    
                    // This is just a placeholder for the pie chart
                    ZStack {
                        Circle()
                            .fill(Color.gray.opacity(0.2))
                        VStack {
                            Chart(products) { product in
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
                ForEach(fundList, id: \.0) { month, percentage, totalNav in
                    VStack(alignment: .leading) {
                        Text("Month: \(month)")
                            .fontWeight(.semibold)
                        HStack {
                            Text("Percentage \(percentage) %")
                            Spacer()
                            Text("Total Nav: \(totalNav)")
                        }
                    }
                    .padding()
                    .background(Color.white)
                    .cornerRadius(10)
                }
            }
            .padding()
        }
        .background(Color("BakcgroundColor")) // Replace with the actual color you're using
    }
}

struct StatementUI_Previews: PreviewProvider {
    static var previews: some View {
        StatementView()
    }
}
