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
        ZStack {
            BackGroundView()
            VStack(spacing: 0) {
                CustomNavigationBar(additionalAction: nil)
                Spacer().frame(height: 15)
                Text(Constants.ALL_REVIEW_HEADER).middleTitleStyle()
                List {
                    ForEach(viewModel.reviews, id: \.id) { review in
                        Button(action: {
                            viewModel.switchShowDetail(reviewID: review.getReviewID())
                        }) {
                            if viewModel.showDetailDic[review.getReviewID()] ?? false {
                                ReviewDetailView(viewModel: .init(review: review))
                            } else {
                                ReviewHeadline(viewModel: .init(review: review))
                            }
                        }
                    }
                    .listRowBackground(Color.superWhitePasteGreen)
                }
                .cornerRadius(15)
                .padding(5)
            }
            if viewModel.isShowingProgress {
                CustomedProgress()
            }
        }
        .navigationBarHidden(true)
        .onAppear() {
            viewModel.fetchAllReview()
        }
    }
}
