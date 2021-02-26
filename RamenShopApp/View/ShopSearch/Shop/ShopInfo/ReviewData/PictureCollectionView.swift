//
//  PictureCollectionView.swift
//  RamenShopApp
//
//  Created by Koro Saka on 2021-02-25.
//  Copyright © 2021 Koro Saka. All rights reserved.
//

import SwiftUI
import QGrid

struct PictureCollectionView: View {
    let scrollable: Bool
    let ramenImages: [RamenImage]
    let pictureSize: CGFloat = UIScreen.main.bounds.size.width / 2.4
    let space: CGFloat = 5.0
    let padding: CGFloat = 5.0
    var row: Int {
        return (ramenImages.count + 1) / 2
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
        if ramenImages.count == 0 {
            VStack {
                Text(Constants.NO_PICTURE)
            }
        } else {
            QGrid(self.ramenImages,
                  columns: 2,
                  vSpacing: space,
                  hSpacing: space,
                  vPadding: padding,
                  hPadding: padding,
                  isScrollable: scrollable,
                  showScrollIndicators: scrollable
            ) { ramenImage in
                PictureCell(ramenImage: ramenImage, size: pictureSize)
            }
            .frame(height: frameHieght)
        }
        
    }
    
}
