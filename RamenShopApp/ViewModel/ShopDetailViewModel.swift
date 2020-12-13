//
//  ShopDetailViewModel.swift
//  RamenShopApp
//
//  Created by Koro Saka on 2020-12-02.
//  Copyright © 2020 Koro Saka. All rights reserved.
//

import Foundation
import SwiftUI
class ShopDetailViewModel: ObservableObject {
    
    var db: FirebaseHelper
    @Published var latestReviews: [Review]
    @Published var pictures: [UIImage]
    var shop: Shop?
    
    init(mapVM: MapSearchingViewModel) {
        if mapVM.isShopSelected {
            shop = mapVM.selectedShop!
        }
        self.db = .init()
        latestReviews = .init()
        pictures = .init()
        
        db.delegate = self
    }
    
    func fetchDataFromDB() {
        if shop == nil { return }
        db.fetchLatestReviews(shopID: shop!.shopID)
        db.fetchPictureReviews(shopID: shop!.shopID)
    }
}

extension ShopDetailViewModel: FirebaseHelperDelegate {
    func completedFetchingReviews(reviews: [Review]) {
        latestReviews = reviews
    }
    func completedFetchingPictures(pictures: [UIImage]) {
        self.pictures = pictures
    }
}
