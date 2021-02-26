//
//  ReviewDetailView.swift
//  RamenShopApp
//
//  Created by Koro Saka on 2020-12-09.
//  Copyright © 2020 Koro Saka. All rights reserved.
//

import SwiftUI

struct ReviewDetailView: View {
    @ObservedObject var viewModel: ReviewDetailViewModel
    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                if viewModel.userProfile.icon == nil {
                    Image(systemName: "person.crop.circle.fill")
                        .iconSmallStyle()
                        .sidePadding(size: 5)
                } else {
                    Image(uiImage: viewModel.userProfile.icon!)
                        .iconSmallStyle()
                        .sidePadding(size: 5)
                }
                Text(viewModel.userProfile.userName)
                    .foregroundColor(.black)
                Spacer()
            }
            HStack {
                Image(systemName: "star.fill")
                    .foregroundColor(.yellow)
                    .font(.headline)
                Text(String(viewModel.review.evaluation))
                    .foregroundColor(.black)
                    .font(.headline)
                Spacer()
                Text(viewModel.review.displayDate())
                    .font(.headline)
                    .foregroundColor(.black)
            }
            .upDownPadding(size: 5)
            Text(viewModel.review.comment)
                .padding(.bottom)
                .foregroundColor(.black)
            PictureCollectionView(scrollable: false,
                                  ramenImages: viewModel.reviewImages)
        }
    }
}
