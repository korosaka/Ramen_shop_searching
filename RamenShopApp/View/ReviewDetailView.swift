//
//  ReviewDetailView.swift
//  RamenShopApp
//
//  Created by Koro Saka on 2020-12-09.
//  Copyright © 2020 Koro Saka. All rights reserved.
//

import SwiftUI
import QGrid

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
                Text(viewModel.review.displayDate())
                    .font(.headline)
            }.padding(.init(top: 5,
                            leading: 0,
                            bottom: 5,
                            trailing: 0))
            Text(viewModel.review.comment).padding(.bottom)
            PictureCollectionView(scrollable: false,
                                  ramenImages: viewModel.reviewImages)
        }.onAppear() {
            viewModel.fetchImages()
        }
    }
}

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
                Text("No Picture")
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
            .background(Color.blue)
        }
        
    }
    
}

struct PictureCell: View {
    let ramenImage: RamenImage
    let size: CGFloat
    
    var body: some View {
        ramenImage.picture
            .resizable()
            .scaledToFit()
            .frame(width: size, height: size)
            .background(Color.red)
            .border(Color.black)
    }
}

struct RamenImage: Identifiable {
    let id = UUID()
    let picture: Image
}
