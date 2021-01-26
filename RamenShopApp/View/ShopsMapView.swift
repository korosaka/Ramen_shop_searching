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
                .padding(3)
                .background(Color.pastelGreen)
            
            Button(action: {
                self.viewModel.loadShops()
            }) {
                Text("reload")
                    .containingSymbol(symbol: "arrow.triangle.2.circlepath",
                                                color: .strongPink,
                                                textFont: .title3,
                                                symbolFont: .title3)
                    .padding(5)
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
