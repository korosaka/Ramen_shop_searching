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
            Color.blue
            ScrollView(.vertical) {
                VStack {
                    ShopName(shopName: viewModel.shop?.name)
                        .padding(.init(top: 15,
                                       leading: 15,
                                       bottom: 0,
                                       trailing: 15))
                    
                    ShopEvaluation(aveEvaluation: viewModel.shop?.roundEvaluatione())
                        .padding(.init(top: 0,
                                       leading: 0,
                                       bottom: 20,
                                       trailing: 0))
                    
                    LatestReviews(latestReviews: viewModel.latestReviews,
                                  shop: viewModel.shop!)
                    
                    Pictures(pictures: viewModel.pictures, shopID: viewModel.shop?.shopID)
                        .padding(.init(top: 20,
                                       leading: 10,
                                       bottom: 0,
                                       trailing: 10))
                }
            }
            .padding(.init(top: 5,
                           leading: 0,
                           bottom: 5,
                           trailing: 0))
        }.onAppear() {
            self.viewModel.fetchDataFromDB()
        }
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
            .padding(.init(top: 30,
                           leading: 0,
                           bottom: 30,
                           trailing: 0))
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
                .padding(.init(top: 5,
                               leading: 0,
                               bottom: 0,
                               trailing: 15))
            }
        }
    }
}

struct ReviewHeadline: View {
    @ObservedObject var viewModel: ReviewHeadlineViewModel
    
    var body: some View {
        HStack() {
            if viewModel.userProfile.icon == nil {
                Image(systemName: "person.crop.circle.fill")
                    .resizable()
                    .frame(width: 41, height: 41)
                    .padding(.init(top: 0,
                                   leading: 5,
                                   bottom: 0,
                                   trailing: 5))
            } else {
                Image(uiImage: viewModel.userProfile.icon!)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 40, height: 40)
                    .clipShape(Circle())
                    .padding(1)
                    .background(Color.black)
                    .clipShape(Circle())
                    .padding(.init(top: 0,
                                   leading: 5,
                                   bottom: 0,
                                   trailing: 5))
            }
            
            VStack(alignment: .leading) {
                HStack {
                    Image(systemName: "star.fill")
                        .foregroundColor(.yellow)
                        .font(.subheadline)
                    Text(String(viewModel.review.evaluation))
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
                Text(viewModel.review.comment).lineLimit(2)
            }.padding(.init(top: 0,
                            leading: 10,
                            bottom: 0,
                            trailing: 10))
            .background(Color.white)
            .cornerRadius(15)
        }
    }
}

struct Pictures: View {
    let pictures: [UIImage]
    let shopID: String?
    
    var body: some View {
        GeometryReader { bodyView in
            if pictures.count > 0 {
                VStack {
                    HStack {
                        Spacer()
                        ForEach(0...2, id: \.self) { index in
                            let imageSize = bodyView.size.width / 3.5
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
                    .padding(.init(top: 10,
                                   leading: 0,
                                   bottom: 10,
                                   trailing: 0))
                    .background(Color.white)
                    .cornerRadius(10)
                    
                    NavigationLink(destination: AllPictureView(viewModel: .init(shopID: shopID))) {
                        HStack {
                            Spacer()
                            Text("All picture...")
                                .foregroundColor(.white)
                                .underline()
                        }
                        .padding(.init(top: 5,
                                       leading: 0,
                                       bottom: 0,
                                       trailing: 15))
                    }
                }
            } else {
                Text("There is no picture")
                    .foregroundColor(.white)
                    .padding(3)
            }
        }
    }
}
