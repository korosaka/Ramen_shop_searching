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
    var db: FirebaseHelper
    var shop: Shop

    init(shop: Shop) {
        db = .init()
        self.shop = shop
        reviews = .init()
        db.delegate = self
    }
    
    func fetchAllReview() {
        db.fetchAllReview(shopID: shop.shopID)
    }
}

extension AllReviewViewModel: CloudFirestoreDelegate {
    func completedFetchingReviews(reviews: [Review]) {
        self.reviews = reviews
    }
}
