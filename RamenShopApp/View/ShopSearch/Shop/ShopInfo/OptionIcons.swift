//
//  OptionIcons.swift
//  RamenShopApp
//
//  Created by Koro Saka on 2021-02-24.
//  Copyright © 2021 Koro Saka. All rights reserved.
//

import SwiftUI

struct OptionIcons: View {
    @ObservedObject var viewModel: ShopDetailViewModel
    
    var body: some View {
        VStack(spacing: 0) {
            Button(action: {
                viewModel.switchFavorite()
            }) {
                if viewModel.favorite {
                    Image(systemName: "heart.fill")
                        .circleSymbol(font: .title3,
                                      fore: .pink,
                                      back: .superWhitePasteGreen)
                } else {
                    Image(systemName: "heart")
                        .circleSymbol(font: .title3,
                                      fore: .pink,
                                      back: .superWhitePasteGreen)
                }
            }
            .sidePadding(size: 10)
            Spacer().frame(height: 20)
            if let shop = viewModel.shop {
                NavigationLink(destination: MapFromShop(targetShop: shop)) {
                    Image(systemName: "mappin.and.ellipse")
                        .circleSymbol(font: .title3,
                                      fore: .viridianGreen,
                                      back: .superWhitePasteGreen)
                }
                
                .sidePadding(size: 10)
            }
        }
    }
}
