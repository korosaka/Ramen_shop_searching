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
                if viewModel.userProfile.getIcon() == nil {
                    Image(systemName: "person.crop.circle.fill")
                        .iconSmallStyle()
                        .sidePadding(size: 5)
                } else {
                    Image(uiImage: viewModel.userProfile.getIcon()!)
                        .iconSmallStyle()
                        .sidePadding(size: 5)
                }
                Text(viewModel.userProfile.getUserName())
                    .foregroundColor(.black)
                Spacer()
            }
            HStack {
                Image(systemName: "star.fill")
                    .foregroundColor(.yellow)
                    .font(.headline)
                Text(String(viewModel.review.getEvaluation()))
                    .foregroundColor(.black)
                    .font(.headline)
                Spacer()
                Text(viewModel.review.displayDate())
                    .font(.headline)
                    .foregroundColor(.black)
            }
            .upDownPadding(size: 5)
            Text(viewModel.review.getComment())
                .padding(.bottom)
                .foregroundColor(.black)
            PictureCollectionView(scrollable: false,
                                  ramenImages: viewModel.reviewImages)
        }
    }
}
