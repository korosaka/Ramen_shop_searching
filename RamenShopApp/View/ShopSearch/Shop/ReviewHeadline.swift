//
//  ReviewHeadline.swift
//  RamenShopApp
//
//  Created by Koro Saka on 2021-02-24.
//  Copyright © 2021 Koro Saka. All rights reserved.
//

import SwiftUI

//MARK: TODO "if" should be done within VM
struct ReviewHeadline: View {
    @ObservedObject var viewModel: ReviewHeadlineViewModel
    
    var body: some View {
        HStack() {
            if viewModel.userProfile.icon == nil {
                Image(systemName: "person.crop.circle.fill")
                    .iconSmallStyle()
                    .sidePadding(size: 5)
            } else {
                Image(uiImage: viewModel.userProfile.icon!)
                    .iconSmallStyle()
                    .sidePadding(size: 5)
            }
            
            VStack(alignment: .leading) {
                HStack {
                    Image(systemName: "star.fill")
                        .foregroundColor(.yellow)
                        .font(.subheadline)
                    Text(String(viewModel.review.evaluation))
                        .foregroundColor(.black)
                    Spacer()
                    Text(viewModel.review.displayDate())
                        .foregroundColor(.gray)
                    if viewModel.review.imageCount > 0 {
                        Image(systemName: "camera.fill")
                            .foregroundColor(.purple)
                    } else {
                        Image(systemName: "camera")
                            .foregroundColor(.gray)
                    }
                }
                .padding(.init(top: 0,
                               leading: 0,
                               bottom: 2,
                               trailing: 0))
                Text(viewModel.review.comment)
                    .foregroundColor(.black)
                    .lineLimit(1)
            }
            .sidePadding(size: 10)
            .background(Color.white)
            .cornerRadius(15)
        }
    }
}
