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
            Color.whitePasteGreen
            VStack(spacing: 0) {
                CustomNavigationBar(additionalAction: nil)
                VStack(spacing: 0) {
                    VStack(spacing: 0) {
                        Spacer().frame(height: 10)
                        ShopName(shopName: viewModel.shop?.name)
                        Spacer().frame(height: 10)
                        EvaluationLabel(viewModel: viewModel)
                        Spacer().frame(height: 5)
                    }
                    .background(BackGroundView())
                    ScrollView(.vertical) {
                        LatestReviews(latestReviews: viewModel.latestReviews,
                                      shop: viewModel.shop)
                        Spacer().frame(height: 40)
                        Pictures(pictures: viewModel.pictures,
                                 shopID: viewModel.shop?.shopID)
                        Spacer().frame(height: 50)
                        Spacer()
                    }
                }
                
                HStack {
                    Spacer()
                    NavigationLink(destination: ReviewingView()
                                    .environmentObject(ReviewingViewModel(shop: viewModel.shop, delegate: viewModel))) {
                        Text("review")
                            .containingSymbolWide(symbol: "bubble.left.fill",
                                                  color: .strongPink,
                                                  textFont: .largeTitle,
                                                  symbolFont: .title)
                    }
                    Spacer()
                }
                Spacer().frame(height: 10)
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
        Text(shopName ?? "no-name").largestTitleStyle()
    }
}

struct EvaluationLabel: View {
    @ObservedObject var viewModel: ShopDetailViewModel
    
    var body: some View {
        ZStack(alignment: .trailing) {
            HStack {
                Image(systemName: "star.fill")
                    .foregroundColor(.gold)
                    .font(.title)
                    .shadow(color: .black, radius: 1)
                Text(viewModel.shop?.roundEvaluatione() ?? String(Constants.EMPTY))
                    .foregroundColor(.gold).bold()
                    .font(.largeTitle)
                    .shadow(color: .black, radius: 1)
            }
            .wideStyle()
            
            FavoriteMapIcons(viewModel: viewModel)
        }
    }
}

struct FavoriteMapIcons: View {
    @ObservedObject var viewModel: ShopDetailViewModel
    
    var body: some View {
        VStack(spacing: 0) {
            Button(action: {
                viewModel.switchFavorite()
            }) {
                if viewModel.favorite {
                    Image(systemName: "heart.fill")
                        .circleSymbol(font: .title3,
                                      fore: .pink,
                                      back: .superWhitePasteGreen)
                } else {
                    Image(systemName: "heart")
                        .circleSymbol(font: .title3,
                                      fore: .pink,
                                      back: .superWhitePasteGreen)
                }
            }
            .sidePadding(size: 10)
            Spacer().frame(height: 20)
            if let shop = viewModel.shop {
                NavigationLink(destination: MapFromShop(targetShop: shop)) {
                    Image(systemName: "mappin.and.ellipse")
                        .circleSymbol(font: .title3,
                                      fore: .viridianGreen,
                                      back: .superWhitePasteGreen)
                }
                
                .sidePadding(size: 10)
            }
        }
    }
}

struct LatestReviews: View {
    let latestReviews: [Review]
    let shop: Shop?
    
    var body: some View {
        Text("latest reviews")
            .foregroundColor(.white)
            .wideStyle()
            .upDownPadding(size: 3)
            .background(Color.gray)
            .shadow(color: .black, radius: 1)
        if latestReviews.count == 0 {
            Spacer().frame(height: 10)
            Text("there is no review")
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
                        Text("all review...")
                            .foregroundColor(.seaBlue)
                            .underline()
                            .sidePadding(size: 15)
                    }
                }
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
        Text("uploaded pictures")
            .foregroundColor(.white)
            .wideStyle()
            .upDownPadding(size: 3)
            .background(Color.gray)
            .shadow(color: .black, radius: 1)
        Spacer().frame(height: 10)
        if pictures.count > 0 {
            VStack(spacing: 0) {
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
                .sidePadding(size: 10)
                
                Spacer().frame(height: 20)
                HStack {
                    Spacer()
                    NavigationLink(destination: AllPictureView(viewModel: .init(shopID: shopID))) {
                        Text("all picture...")
                            .foregroundColor(.seaBlue)
                            .underline()
                    }
                    .sidePadding(size: 10)
                }
            }
        } else {
            Text("there is no picture")
                .foregroundColor(.viridianGreen)
                .shadow(color: .black, radius: 0.5, x: 0.5, y: 0.5)
        }
    }
}
