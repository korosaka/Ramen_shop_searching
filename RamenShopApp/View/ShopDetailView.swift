//
//  ShopDetailView.swift
//  RamenShopApp
//
//  Created by Koro Saka on 2020-11-26.
//  Copyright © 2020 Koro Saka. All rights reserved.
//

import SwiftUI

struct ShopDetailView: View {
    
    var shopName: String
    var shopID: String
    
    var body: some View {
        Text("Shop Name: \(shopName)")
        Text("Shop ID: \(shopID)")
    }
}
