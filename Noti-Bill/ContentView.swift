import SwiftUI

struct ContentView: View {
    @State private var availableCredit: Float
    @State private var showCreditSheet: Bool
    @StateObject private var viewModel = BillsViewModel()
    
    init() {
        let credit = UserDefaults.standard.float(forKey: "availableCredit")
        _availableCredit = State(initialValue: credit)
        _showCreditSheet = State(initialValue: credit == 0.0)
    }
    
    var body: some View {
        NavigationView {
            VStack {
                VStack {
                    Image("AppIcon")
                        .resizable()
                        .frame(width: 70, height: 50)
                        .foregroundColor(.white)
                        .clipShape(Circle())
                    Text("NOTI BILL")
                        .font(.headline)
                        .padding()
                }
                
                VStack {
                    Text("Current available credit")
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .font(.subheadline.bold()).foregroundColor(.white)
                        .padding()
                    Text("\(availableCredit - Float(viewModel.totalForPeriod), specifier: "%.2f") bath ")
                        .font(.system(size: 40))
                        .fontWeight(.bold)
                        .foregroundColor(.black)
                        .padding()
                    
                }
                .background(Color(red: 0.0, green: 0.4980392156862745, blue: 0.4627450980392157))
                .frame(maxWidth: .infinity)
                .onAppear{
                    viewModel.fetchBills()
                }
                
                Button("Update Credit") {
                    self.showCreditSheet = true
                }.background(Color.blue).foregroundColor(.white)
                    .padding()
                    .background(Color.blue)
                    .clipShape(Capsule())
                
                // Buttons grid
                VStack(spacing: 10) {
                    HStack(spacing: 10) {
                        NavigationLink(destination: StatementView()){
                            VStack {
                                Image("StatementIcon")
                                    .resizable()
                                    .scaledToFit()
                                Text("Statement")
                            }.frame(minWidth: 200, minHeight: 100).background(Color.green).padding(5)
                        }
                        .buttonStyle(IconStyle())
                        
                        NavigationLink(destination: FillTheBillView()){
                            VStack {
                                Image("FillBillIcon")
                                    .resizable()
                                    .frame(width: 70, height: 70)
                                Text("Fill the bill")
                            }.frame(width: 200, height: 100).background(Color(red: 1.0, green: 0.0, blue: 0.0, opacity: 1.0)).padding(5)
                        }
                        .buttonStyle(IconStyle())
                    }
                    
                    HStack(spacing: 10) {
                        NavigationLink(destination: FinancialAnalysisView()) {
                            VStack {
                                Image("AnalysisIcon")
                                    .resizable()
                                    .scaledToFill()
                                    .frame(width: 50, height: 50)
                                Text("Analysis")
                            }.frame(minWidth: 200, minHeight: 100).background(Color(red: 0.07450980392156863, green: 0.7450980392156863, blue: 0.8392156862745098)).padding(10)
                        }
                        .buttonStyle(IconStyle())
                        
                        
                        NavigationLink(destination: SettingView()) {
                            VStack {
                                Image("NotiIcon")
                                    .resizable()
                                    .scaledToFit()
                                Text("Notification")
                            }
                            .frame(minWidth: 200, minHeight: 100)
                            .background(Color(red: 0.942, green: 0.866, blue: 0.721))
                            .padding(10)
                            
                        }
                        .buttonStyle(IconStyle())
                        
                        
                    }
                }
                .padding()
                .frame(
                    maxWidth: .infinity
                )
                Spacer()
            }
            .sheet(isPresented: $showCreditSheet) {
                    CreditEntryView(availableCredit: $availableCredit)
            }
            .background(Color("BakcgroundColor"))
            .foregroundColor(.black)
        }
    }
}

// Style for the buttons
struct IconStyle: ButtonStyle {
    func makeBody(configuration: Self.Configuration) -> some View {
        configuration.label
            .frame(width: 100, height: 100)
            .cornerRadius(10)
            .padding()
    }
}

// SwiftUI Preview
struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

