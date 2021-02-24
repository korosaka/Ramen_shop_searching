//
//  RequestInfo.swift
//  RamenShopApp
//
//  Created by Koro Saka on 2021-02-24.
//  Copyright © 2021 Koro Saka. All rights reserved.
//

import SwiftUI

struct RequestInfo: View {
    @EnvironmentObject var viewModel: RequestStatusViewModel
    var body: some View {
        VStack(spacing: 0) {
            Spacer().frame(height: 10).wideStyle()
            RequestedShopName(name: viewModel.shopName ?? Constants.EMPTY)
            Spacer().frame(height: 30)
            ReviewStatus()
            Spacer().frame(height: 10)
        }
        .background(Color.superWhitePasteGreen)
        .cornerRadius(20)
    }
}
