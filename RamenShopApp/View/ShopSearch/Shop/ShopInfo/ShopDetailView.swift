//
//  ShopDetailView.swift
//  RamenShopApp
//
//  Created by Koro Saka on 2020-11-26.
//  Copyright © 2020 Koro Saka. All rights reserved.
//

import SwiftUI

struct ShopDetailView: View {
    
    @ObservedObject var viewModel: ShopDetailViewModel
    
    var body: some View {
        ZStack {
            Color.whitePasteGreen
            VStack(spacing: 0) {
                CustomNavigationBar(additionalAction: nil)
                VStack(spacing: 0) {
                    VStack(spacing: 0) {
                        Spacer().frame(height: 10)
                        ShopName(shopName: viewModel.shop?.name)
                        Spacer().frame(height: 10)
                        EvaluationLabel(viewModel: viewModel)
                        Spacer().frame(height: 5)
                    }
                    .background(BackGroundView())
                    ScrollView(.vertical) {
                        LatestReviews(latestReviews: viewModel.latestReviews,
                                      shop: viewModel.shop)
                        Spacer().frame(height: 40)
                        Pictures(pictures: viewModel.pictures,
                                 shopID: viewModel.shop?.shopID)
                        Spacer().frame(height: 50)
                        Spacer()
                    }
                }
                
                HStack {
                    Spacer()
                    NavigationLink(destination: ReviewingView()
                                    .environmentObject(ReviewingViewModel(shop: viewModel.shop, delegate: viewModel))) {
                        Text("review")
                            .containingSymbolWide(symbol: "bubble.left.fill",
                                                  color: .strongPink,
                                                  textFont: .largeTitle,
                                                  symbolFont: .title)
                    }
                    Spacer()
                }
                Spacer().frame(height: 10)
            }
            if viewModel.isShowingProgress {
                CustomedProgress()
            }
        }
        .navigationBarHidden(true)
    }
}
