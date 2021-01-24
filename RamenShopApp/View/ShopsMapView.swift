//
//  ShopsMapView.swift
//  RamenShopApp
//
//  Created by Koro Saka on 2021-01-02.
//  Copyright © 2021 Koro Saka. All rights reserved.
//

import SwiftUI

struct ShopsMapView: View {
    @ObservedObject var viewModel: ShopsMapViewModel
    
    var body: some View {
        ZStack(alignment: .topTrailing) {
            GoogleMapView(shopsMapVM: viewModel)
                .padding(5)
                .background(Color.blue)
            
            Button(action: {
                self.viewModel.loadShops()
            }) {
                Text("Reload")
                    .foregroundColor(.white)
                    .padding(10)
                    .background(Color.purple)
                    .cornerRadius(13)
                    .overlay(RoundedRectangle(cornerRadius: 13)
                                .stroke(Color.black, lineWidth: 2)
                    )
                    .padding(10)
            }
            if viewModel.isShowingProgress {
                VStack {
                    Spacer()
                    CustomedProgress()
                    Spacer()
                }
                
            }
            NavigationLink(destination: ShopDetailView(viewModel: .init(mapVM: self.viewModel)),
                           isActive: $viewModel.isShopSelected) {
                EmptyView()
            }
        }
    }
}
