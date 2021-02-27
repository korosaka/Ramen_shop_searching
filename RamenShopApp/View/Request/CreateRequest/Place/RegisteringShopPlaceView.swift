//
//  RegisteringShopPlaceView.swift
//  RamenShopApp
//
//  Created by Koro Saka on 2021-01-02.
//  Copyright © 2021 Koro Saka. All rights reserved.
//

import SwiftUI

struct RegisteringShopPlaceView: View {
    @ObservedObject var viewModel: RegisteringShopViewModel
    var body: some View {
        ZStack {
            BackGroundView()
            VStack(spacing: 0) {
                CustomNavigationBar(additionalAction: nil)
                Spacer().frame(height: 10)
                Text(viewModel.shopName).largestTitleStyle()
                Spacer().frame(height: 20)
                LocationExplanation()
                    .sidePadding(size: 10)
                Spacer().frame(height: 10)
                SelectingLocation(viewModel: viewModel)
                    .sidePadding(size: 10)
                SendingRequestButton(viewModel: viewModel)
            }
            if viewModel.isShowingProgress {
                CustomedProgress()
            }
        }
        .navigationBarHidden(true)
    }
}
