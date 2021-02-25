//
//  MapFromShop.swift
//  RamenShopApp
//
//  Created by Koro Saka on 2021-02-10.
//  Copyright © 2021 Koro Saka. All rights reserved.
//

import SwiftUI

struct MapFromShop: View {
    let targetShop: Shop
    var body: some View {
        ZStack {
            BackGroundView()
            VStack(spacing: 0) {
                CustomNavigationBar(additionalAction: nil)
                GoogleMapView.init(from: targetShop)
                    .cornerRadius(20)
                    .padding(5)
            }
        }
        .navigationBarHidden(true)
    }
}
