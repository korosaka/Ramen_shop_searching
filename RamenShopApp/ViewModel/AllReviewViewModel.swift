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
        db.fetchAllReview(shopID: shop.shopID)
    }
    
    func switchShowDetail(reviewID: String) {
        showDetailDic[reviewID]?.toggle()
    }
}

extension AllReviewViewModel: CloudFirestoreDelegate {
    func completedFetchingReviews(reviews: [Review]) {
        reviews.forEach {
            showDetailDic[$0.reviewID] = false
        }
        self.reviews = reviews
    }
}
