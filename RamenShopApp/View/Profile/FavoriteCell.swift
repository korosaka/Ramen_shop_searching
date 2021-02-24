//
//  FavoriteCell.swift
//  RamenShopApp
//
//  Created by Koro Saka on 2021-02-24.
//  Copyright © 2021 Koro Saka. All rights reserved.
//

import SwiftUI

struct FavoriteCell: View {
    let shopInfo: FavoriteShopInfo
    let size: CGFloat
    
    var body: some View {
        NavigationLink(destination: ShopDetailView(viewModel: .init(shopID: shopInfo.id))) {
            VStack(spacing: 0) {
                if let image = shopInfo.shopTopImage {
                    image
                        .resizable()
                        .scaledToFill()
                        .frame(width: size, height: size)
                        .clipShape(Circle())
                } else {
                    Image(systemName: "camera.fill").font(.title)
                        .padding(20)
                        .frame(width: size, height: size)
                        .background(Color.gray)
                        .foregroundColor(.black)
                        .clipShape(Circle())
                }
                Text(shopInfo.shopName ?? Constants.EMPTY)
                    .bold()
                    .sidePadding(size: 10)
            }
        }
        .upDownPadding(size: 15)
    }
}
