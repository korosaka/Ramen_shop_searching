//
//  EnteringShopName.swift
//  RamenShopApp
//
//  Created by Koro Saka on 2021-02-26.
//  Copyright © 2021 Koro Saka. All rights reserved.
//

import SwiftUI

struct EnteringShopName: View {
    @ObservedObject var viewModel: RegisteringShopViewModel
    var body: some View {
        VStack {
            Text(Constants.SHOP_NAME)
                .font(.title)
                .bold()
                .foregroundColor(.strongPink)
                .shadow(color: .black, radius: 1, x: 1, y: 1)
            Spacer().frame(height: 10)
            TextField(Constants.ENTER_SHOP_NAME, text: $viewModel.shopName)
                .basicStyle().font(.title)
        }
    }
}
