//
//  MapSearchingViewModel.swift
//  RamenShopApp
//
//  Created by Koro Saka on 2020-11-23.
//  Copyright © 2020 Koro Saka. All rights reserved.
//

import Foundation
class MapSearchingViewModel: ObservableObject {
    var shopDB: CloudFirestore
    @Published var shops: [Shop]
    @Published var isShopSelected = false
    var selectedShopID = ""
    var selectedShopName = ""
    
    init() {
        shopDB = .init()
        shops = [Shop]()
        shopDB.delegate = self
    }
    
    func loadShops() {
        shopDB.getShops()
    }
    
    func selectShop(id: String, name: String) {
        isShopSelected = true
        selectedShopID = id
        selectedShopName = name
    }
}

extension MapSearchingViewModel: CloudFirestoreDelegate {
    func completedGettingShop() {
        shops = shopDB.shops
    }
}
