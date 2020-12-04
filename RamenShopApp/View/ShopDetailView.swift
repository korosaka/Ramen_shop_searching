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
                .cornerRadius(10)
                .padding(5)
                .background(Color.black)
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
                    
                    LatestReviews(latestReviews: viewModel.latestReviews)
                    
                    Pictures()
                        .padding(20)
                }
            }
            .padding(.init(top: 5,
                           leading: 0,
                           bottom: 5,
                           trailing: 0))
        }.onAppear() {
            self.viewModel.fetchLatestReview()
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
    
    var body: some View {
        Text("Latest reviews")
            .foregroundColor(.white)
            .underline()
            .padding(3)
        if latestReviews.count > 0 {
            ReviewHeadline(review: latestReviews[0])
        }
        if latestReviews.count > 1 {
            ReviewHeadline(review: latestReviews[1])
                .padding(.init(top: 10,
                               leading: 0,
                               bottom: 0,
                               trailing: 0))
        }
        if latestReviews.count > 2 {
            NavigationLink(destination: AllReviewView()) {
                HStack {
                    Spacer()
                    Text("more...").foregroundColor(.white)
                }
                .padding(.init(top: 5,
                               leading: 0,
                               bottom: 0,
                               trailing: 20))
            }
        }
    }
}

struct ReviewHeadline: View {
    let review: Review
    
    var body: some View {
        HStack() {
            Image(systemName: "person.crop.circle.fill")
                .font(.largeTitle)
                .padding(.init(top: 0,
                               leading: 5,
                               bottom: 0,
                               trailing: 5))
            VStack(alignment: .leading) {
                HStack {
                    Image(systemName: "star.fill")
                        .foregroundColor(.yellow)
                        .font(.subheadline)
                    Text(String(review.evaluation))
                    Spacer()
                    if review.imageCount > 0 {
                        Image(systemName: "camera.fill")
                            .foregroundColor(.purple)
                    }
                }
                Text(review.comment).lineLimit(3)
            }.padding(.init(top: 0,
                            leading: 10,
                            bottom: 0,
                            trailing: 10))
            .background(Color.white)
            .cornerRadius(15)
            .padding(.init(top: 0,
                           leading: 0,
                           bottom: 0,
                           trailing: 20))
        }
    }
}

// MARK: TODO
struct Pictures: View {
    var body: some View {
        HStack {
            Spacer()
            Text("Pictures")
            Spacer()
        }
        .padding(.init(top: 50,
                       leading: 0,
                       bottom: 50,
                       trailing: 0))
        .background(Color.white)
    }
}
