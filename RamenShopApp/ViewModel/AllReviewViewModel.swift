//
//  AllReviewViewModel.swift
//  RamenShopApp
//
//  Created by Koro Saka on 2020-12-08.
//  Copyright © 2020 Koro Saka. All rights reserved.
//

import Foundation
class AllReviewViewModel: ObservableObject {
    
    @Published var reviews: [Review]
    @Published var showDetailDic: [String: Bool]
    @Published var isShowingProgress = false
    var currentDetail: String?
    var db: FirebaseHelper
    var shop: Shop
    
    init(shop: Shop) {
        db = .init()
        self.shop = shop
        reviews = .init()
        showDetailDic = .init()
        db.delegate = self
    }
    
    func fetchAllReview() {
        isShowingProgress = true
        db.fetchAllReview(shopID: shop.shopID)
    }
    
    func switchShowDetail(reviewID selctedReview: String) {
        showDetailDic[selctedReview]?.toggle()
        if currentDetail == nil {
            // MARK: a review is tapped when every review are closed
            currentDetail = selctedReview
        } else if currentDetail == selctedReview {
            // MARK: the review showing detail is tapped
            currentDetail = nil
        } else {
            // MARK: a review is tapped when another review is showing detail
            showDetailDic[currentDetail!]?.toggle()
            currentDetail = selctedReview
        }
    }
}

extension AllReviewViewModel: FirebaseHelperDelegate {
    func completedFetchingReviews(reviews: [Review]) {
        isShowingProgress = false
        reviews.forEach {
            showDetailDic[$0.reviewID] = false
        }
        self.reviews = reviews
    }
}
