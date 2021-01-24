//
//  MapSearchingViewModel.swift
//  RamenShopApp
//
//  Created by Koro Saka on 2020-11-23.
//  Copyright © 2020 Koro Saka. All rights reserved.
//

import Foundation
class ShopsMapViewModel: ObservableObject {
    var shopDB: FirebaseHelper
    @Published var shops: [Shop]
    @Published var isShopSelected = false
    @Published var isShowingProgress = false
    var selectedShop: Shop?
    
    init() {
        shopDB = .init()
        shops = [Shop]()
        shopDB.delegate = self
        loadShops()
    }
    
    func loadShops() {
        isShowingProgress = true
        shopDB.fetchShops(target: .approved)
    }
    
    //MARK: TODO (high priority)
    /*
     rather than searching and passing shop, only pass shopID, and on the next view that will receive the shopID should fetch Shop data with ID.
     because this function can take a long time if there lots shop,,,,,,
     */
    func selectShop(id: String, name: String) {
        for shop in shops {
            if shop.shopID == id {
                selectedShop = shop
                // MARK: this Bool will be false when back to MapSearchingView by NavigationLink
                isShopSelected = true
                break
            }
        }
    }
}

extension ShopsMapViewModel: FirebaseHelperDelegate {
    func completedFetchingShops(shops: [Shop]) {
        isShowingProgress = false
        self.shops = shops
    }
}
