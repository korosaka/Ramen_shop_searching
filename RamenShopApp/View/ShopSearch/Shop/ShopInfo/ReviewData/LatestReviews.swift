//
//  LatestReviews.swift
//  RamenShopApp
//
//  Created by Koro Saka on 2021-02-24.
//  Copyright © 2021 Koro Saka. All rights reserved.
//

import SwiftUI

struct LatestReviews: View {
    let latestReviews: [Review]
    let shop: Shop?
    
    var body: some View {
        Text(Constants.LATEST_REVIEWS)
            .foregroundColor(.white)
            .wideStyle()
            .upDownPadding(size: 3)
            .background(Color.gray)
            .shadow(color: .black, radius: 1)
        if latestReviews.count == 0 {
            Spacer().frame(height: 10)
            Text(Constants.NO_REVIEW)
                .foregroundColor(.viridianGreen)
                .shadow(color: .black, radius: 0.5, x: 0.5, y: 0.5)
        }
        
        if latestReviews.count > 0 {
            Spacer().frame(height: 10)
            ReviewHeadline(viewModel: .init(review: latestReviews[0]))
                .padding(.init(top: 0,
                               leading: 0,
                               bottom: 0,
                               trailing: 15))
        }
        if latestReviews.count > 1 {
            Spacer().frame(height: 10)
            ReviewHeadline(viewModel: .init(review: latestReviews[1]))
                .padding(.init(top: 10,
                               leading: 0,
                               bottom: 0,
                               trailing: 15))
        }
        if latestReviews.count > 0 {
            Spacer().frame(height: 20)
            HStack {
                Spacer()
                if let _shop = shop {
                    NavigationLink(destination: AllReviewView(viewModel: .init(shop: _shop))) {
                        Text(Constants.ALL_REVIEW_LINK)
                            .foregroundColor(.seaBlue)
                            .underline()
                            .sidePadding(size: 15)
                    }
                }
            }
        }
    }
}

