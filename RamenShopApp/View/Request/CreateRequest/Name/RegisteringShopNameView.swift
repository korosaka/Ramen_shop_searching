//
//  RegisteringShopNameView.swift
//  RamenShopApp
//
//  Created by Koro Saka on 2021-01-02.
//  Copyright © 2021 Koro Saka. All rights reserved.
//

import SwiftUI

struct RegisteringShopNameView: View {
    @ObservedObject var viewModel: RegisteringShopViewModel
    var body: some View {
        ZStack {
            BackGroundView()
            VStack(spacing: 0) {
                Spacer().frame(height: 15)
                Text(Constants.CREATE_REQUEST_HEADER).middleTitleStyle()
                Spacer().frame(height: 40)
                RequestExplanation().sidePadding(size: 10)
                Spacer().frame(height: 40)
                EnteringShopName(viewModel: viewModel)
                Spacer()
                NavigationToMap(viewModel: viewModel)
                    .sidePadding(size: 10)
                Spacer().frame(height: 10)
            }
        }
    }
}
