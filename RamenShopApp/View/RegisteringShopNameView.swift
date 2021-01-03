//
//  RegisteringShopNameView.swift
//  RamenShopApp
//
//  Created by Koro Saka on 2021-01-02.
//  Copyright © 2021 Koro Saka. All rights reserved.
//

import SwiftUI

struct RegisteringShopNameView: View {
    @ObservedObject var viewModel: RegisteringShopViewModel
    var body: some View {
        VStack(spacing: 0) {
            Spacer().frame(height: 15)
            Text("Application for adding new shop")
                .font(.largeTitle)
                .foregroundColor(.white)
            Text("Your application will be inspected for a few days")
                .foregroundColor(.white)
            Spacer()
            TextField("Enter shop name", text: $viewModel.shopName)
                .basicStyle()
            NavigationLink(destination: RegisteringShopPlaceView(viewModel: self.viewModel)) {
                Text("next").foregroundColor(.white)
            }
            
            Spacer()
        }
        .background(Color.blue)
        
    }
}
