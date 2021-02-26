//
//  ShopName.swift
//  RamenShopApp
//
//  Created by Koro Saka on 2021-02-24.
//  Copyright © 2021 Koro Saka. All rights reserved.
//

import SwiftUI

struct ShopName: View {
    let shopName: String?
    var body: some View {
        Text(shopName ?? Constants.NO_NAME).largestTitleStyle()
    }
}
