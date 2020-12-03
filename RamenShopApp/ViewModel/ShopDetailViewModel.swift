//
//  ShopDetailViewModel.swift
//  RamenShopApp
//
//  Created by Koro Saka on 2020-12-02.
//  Copyright © 2020 Koro Saka. All rights reserved.
//

import Foundation
class ShopDetailViewModel: ObservableObject {

    var db: CloudFirestore
    var latestReviews: [Review]
    var shop: Shop?
    
    init(mapVM: MapSearchingViewModel) {
        if mapVM.isShopSelected {
            shop = mapVM.selectedShop!
        }
        self.db = .init()
        latestReviews = [Review]()
        
        db.delegate = self
    }
    
    func fetchLatestReview() {
        if shop == nil { return }
        db.fetchLatestReviews(shopID: shop!.shopID)
    }
}

extension ShopDetailViewModel: CloudFirestoreDelegate {
    func completedFetchingLatestReviews(reviews: [Review]) {
        latestReviews = reviews
    }
}
