//
//  MapSearchingViewModel.swift
//  RamenShopApp
//
//  Created by Koro Saka on 2020-11-23.
//  Copyright © 2020 Koro Saka. All rights reserved.
//

import Foundation
class MapSearchingViewModel {
    var shopDB: CloudFirestore
    
    init() {
        shopDB = .init()
//        shopDB.getShops()
    }
    
    func getShops() {
        shopDB.getShops()
    }
}
