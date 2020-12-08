//
//  AllReviewViewModel.swift
//  RamenShopApp
//
//  Created by Koro Saka on 2020-12-08.
//  Copyright © 2020 Koro Saka. All rights reserved.
//

import Foundation
class AllReviewViewModel: ObservableObject {
    
    var db: FirebaseHelper
    @Published var reviews: [Review]
    var shop: Shop
    
    
    let testReview = Review(reviewID: "test_id",
                            userID: "test_user",
                            evaluation: 4,
                            comment: "hfhkafhbkafsl ljafnlnanljkvlakjn lknflknlknarsn,afj, rk,najb.fajfajbnjdjkduihkfb mahjm kjnanskdnkjrbnakjf kjbjkfasdmnm,famn afmc nm,daf,m , mnnnnn nkjfna,jn,jarhjkn.knmdfkkgUYTRJA,J jsbjslbjbj,afj,nb,a",
                            imageCount: 2)
    
    let testData: [Review]
    init(shop: Shop) {
        testData = [testReview, testReview, testReview]
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
