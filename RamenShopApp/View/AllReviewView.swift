//
//  AllReviewView.swift
//  RamenShopApp
//
//  Created by Koro Saka on 2020-12-03.
//  Copyright © 2020 Koro Saka. All rights reserved.
//

import SwiftUI

struct AllReviewView: View {
    
    @ObservedObject var viewModel: AllReviewViewModel
    
    var body: some View {
        VStack(spacing: 0) {
            CustomNavigationBar(additionalAction: nil)
            Text("All Review")
                .font(.title)
                .foregroundColor(.yellow)
                .padding(5)
            List {
                ForEach(viewModel.reviews, id: \.reviewID) { review in
                    Button(action: {
                        viewModel.switchShowDetail(reviewID: review.reviewID)
                    }) {
                        if viewModel.showDetailDic[review.reviewID] ?? false {
                            ReviewDetailView(viewModel: .init(review: review))
                        } else {
                            ReviewHeadline(viewModel: .init(review: review))
                        }
                    }
                }
            }
            .background(Color.white)
            .padding(5)
        }
        .background(Color.blue)
        .navigationBarHidden(true)
        
    }
}
