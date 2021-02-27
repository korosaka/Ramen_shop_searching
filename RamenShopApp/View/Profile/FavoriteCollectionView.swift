//
//  FavoriteCollectionView.swift
//  RamenShopApp
//
//  Created by Koro Saka on 2021-02-24.
//  Copyright © 2021 Koro Saka. All rights reserved.
//

import SwiftUI
import QGrid

struct FavoriteCollectionView: View {
    let scrollable: Bool
    let favorites: [FavoriteShopInfo]
    let pictureSize: CGFloat = UIScreen.main.bounds.size.width / 2.5
    let space: CGFloat = 3.0
    let padding: CGFloat = 3.0
    var row: Int {
        return (favorites.count + 1) / 2
    }
    var frameHieght: CGFloat? {
        if scrollable {
            return .none
        } else {
            return pictureSize * CGFloat(row)
                + space * CGFloat(row - 1)
                + padding * 2
        }
    }
    
    var body: some View {
        if favorites.count == 0 {
            VStack {
                Text(Constants.NO_FAVORITE)
                    .upDownPadding(size: 30)
            }
        } else {
            QGrid(self.favorites,
                  columns: 2,
                  vSpacing: space,
                  hSpacing: space,
                  vPadding: padding,
                  hPadding: padding,
                  isScrollable: scrollable,
                  showScrollIndicators: scrollable
            ) { shopInfo in
                FavoriteCell(shopInfo: shopInfo, size: pictureSize)
            }
            .frame(height: frameHieght)
        }
        
    }
    
}
