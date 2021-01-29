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
        ZStack {
            BackGroundView()
            VStack(spacing: 0) {
                Spacer().frame(height: 15)
                Text("Ramen Shop Map").middleTitleStyle()
                Spacer().frame(height: 15)
                ZStack(alignment: .topTrailing) {
                    GoogleMapView(shopsMapVM: viewModel)
                        .cornerRadius(20)
                        .padding(5)
                    
                    Button(action: {
                        self.viewModel.loadShops()
                    }) {
                        Text("reload")
                            .containingSymbol(symbol: "arrow.triangle.2.circlepath",
                                              color: .strongPink,
                                              textFont: .title3,
                                              symbolFont: .title3)
                            .padding(10)
                    }
                }
            }
            if viewModel.isShowingProgress {
                CustomedProgress()
            }
            NavigationLink(destination: ShopDetailView(viewModel: .init(mapVM: self.viewModel)),
                           isActive: $viewModel.isShopSelected) {
                EmptyView()
            }
        }
    }
}
