//
//  ShopDetailView.swift
//  RamenShopApp
//
//  Created by Koro Saka on 2020-11-26.
//  Copyright © 2020 Koro Saka. All rights reserved.
//

import SwiftUI

struct ShopDetailView: View {
    
    @ObservedObject var viewModel: ShopDetailViewModel
    
    var body: some View {
        ZStack {
            VStack(spacing: 0) {
                CustomNavigationBar(additionalAction: nil)
                ScrollView(.vertical) {
                    VStack {
                        Spacer().frame(height: 10)
                        ShopName(shopName: viewModel.shop?.name).sidePadding(size: 15)
                        ShopEvaluation(aveEvaluation: viewModel.shop?.roundEvaluatione())
                        Spacer().frame(height: 30)
                        LatestReviews(latestReviews: viewModel.latestReviews,
                                      shop: viewModel.shop!)
                        Spacer().frame(height: 20)
                        Pictures(pictures: viewModel.pictures, shopID: viewModel.shop?.shopID)
                            .sidePadding(size: 10)
                        Spacer().frame(height: 30)
                    }
                }
                .background(Color.blue)
                
                HStack {
                    Spacer()
                    NavigationLink(destination: ReviewingView()
                                    .environmentObject(ReviewingViewModel(shop: viewModel.shop, delegate: viewModel))) {
                        Text("Review this shop").font(.largeTitle)
                            .foregroundColor(.white)
                            .underline()
                            .upDownPadding(size: 5)
                    }
                    Spacer()
                }
                .background(Color.red)
            }
            if viewModel.isShowingProgress {
                CustomedProgress()
            }
        }
        .navigationBarHidden(true)
    }
}

struct ShopName: View {
    let shopName: String?
    
    var body: some View {
        Text(shopName ?? "no-name")
            .foregroundColor(Color.red)
            .font(.largeTitle)
            .bold()
            .frame(maxWidth: .infinity)
            .upDownPadding(size: 30)
            .background(Color.white)
            .cornerRadius(20)
    }
}

struct ShopEvaluation: View {
    let aveEvaluation: String?
    
    var body: some View {
        HStack {
            Image(systemName: "star.fill")
                .foregroundColor(.yellow)
                .font(.largeTitle)
            Text(aveEvaluation ?? String(""))
                .foregroundColor(.yellow)
                .font(.largeTitle)
        }
    }
}

struct LatestReviews: View {
    let latestReviews: [Review]
    let shop: Shop
    
    var body: some View {
        if latestReviews.count > 0 {
            Text("Latest reviews")
                .foregroundColor(.white)
                .underline()
                .padding(3)
        } else {
            Text("There is no review")
                .foregroundColor(.white)
                .padding(3)
        }
        
        if latestReviews.count > 0 {
            ReviewHeadline(viewModel: .init(review: latestReviews[0]))
                .padding(.init(top: 0,
                               leading: 0,
                               bottom: 0,
                               trailing: 15))
        }
        if latestReviews.count > 1 {
            ReviewHeadline(viewModel: .init(review: latestReviews[1]))
                .padding(.init(top: 10,
                               leading: 0,
                               bottom: 0,
                               trailing: 15))
        }
        if latestReviews.count > 0 {
            NavigationLink(destination: AllReviewView(viewModel: .init(shop: shop))) {
                HStack {
                    Spacer()
                    Text("All review...")
                        .foregroundColor(.white)
                        .underline()
                }
                .padding(.init(top: 3,
                               leading: 0,
                               bottom: 0,
                               trailing: 15))
            }
        }
    }
}

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

struct Pictures: View {
    let pictures: [UIImage]
    let shopID: String?
    
    var body: some View {
        if pictures.count > 0 {
            VStack {
                HStack {
                    Spacer()
                    ForEach(0...2, id: \.self) { index in
                        let imageSize = UIScreen.main.bounds.width / 4
                        if pictures.count > index {
                            Image(uiImage: pictures[index])
                                .resizable()
                                .scaledToFit()
                                .frame(width: imageSize,
                                       height: imageSize)
                        } else {
                            Image(systemName: "camera.fill")
                                .frame(width: imageSize,
                                       height: imageSize)
                                .background(Color.gray)
                        }
                        Spacer()
                    }
                }
                .upDownPadding(size: 10)
                .background(Color.white)
                .cornerRadius(10)
                
                NavigationLink(destination: AllPictureView(viewModel: .init(shopID: shopID))) {
                    HStack {
                        Spacer()
                        Text("All picture...")
                            .foregroundColor(.white)
                            .underline()
                    }
                    .padding(.init(top: 3,
                                   leading: 0,
                                   bottom: 0,
                                   trailing: 0))
                }
            }
        } else {
            Text("There is no picture")
                .foregroundColor(.white)
                .padding(3)
        }
    }
}
