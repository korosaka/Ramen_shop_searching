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
                Image(systemName: "person.crop.circle.fill")
                    .font(.largeTitle)
                Text(viewModel.review.userID)
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
                Text("2020/10/08").font(.headline)
            }.padding(.init(top: 5,
                            leading: 0,
                            bottom: 5,
                            trailing: 0))
            Text(viewModel.review.comment).padding(.bottom)
            Image(systemName: "camera.fill")
        }.onAppear() {
            viewModel.fetchImages()
        }
    }
}
