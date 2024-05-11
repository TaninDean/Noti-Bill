//
//  IconUIView.swift
//  Noti-Bill
//
//  Created by ธนิน ผิวเหลืองสวัสดิ์ on 15/4/2567 BE.
//

import SwiftUI

struct IconUIView: View {
    var body: some View {
            VStack {
                Spacer()
                Image("AppIcon") // Use the exact name of your image asset
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 300, height: 300) // Adjust the frame to fit your design
                Text("NOTI BILL")
                    .font(.title)
                    .fontWeight(.bold)
                    .foregroundColor(Color.blue) // Change the color to match your design
                Spacer()
            }
            
            .edgesIgnoringSafeArea(.all)
        }
}

struct IconView_Previews: PreviewProvider {
    static var previews: some View {
        IconUIView()
    }
}
