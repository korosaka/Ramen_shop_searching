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
            RequestingTitleBar()
            Spacer().frame(height: 5)
            Text("Your request will be inspected within a few days")
                .foregroundColor(.white)
            Spacer().frame(height: 50)
            TextField("Enter shop name", text: $viewModel.shopName)
                .basicStyle().font(.title)
            NavigationLink(destination: RegisteringShopPlaceView(viewModel: self.viewModel)) {
                Text("enter location")
                    .font(.title)
                    .foregroundColor(viewModel.getTextColor(enable: viewModel.isNameSet))
                    .underline()
            }
            .disabled(!viewModel.isNameSet)
            
            Spacer()
        }
        .background(Color.blue)
        
    }
}

struct RequestingTitleBar: View {
    var body: some View {
        HStack {
            Spacer()
            Text("New shop request")
                .font(.largeTitle)
                .foregroundColor(.white)
                .bold()
            Spacer()
        }
        .upDownPadding(size: 5)
        .background(Color.yellow)
    }
}
