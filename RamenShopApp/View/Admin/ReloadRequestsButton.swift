//
//  ReloadRequestsButton.swift
//  RamenShopApp
//
//  Created by Koro Saka on 2021-02-24.
//  Copyright © 2021 Koro Saka. All rights reserved.
//

import SwiftUI

struct ReloadRequestsButton: View {
    @ObservedObject var viewModel: AdminPageViewModel
    var body: some View {
        Button(action: {
            viewModel.fetchRequests()
        }) {
            Text(Constants.RELOAD)
                .containingSymbol(symbol: "arrow.triangle.2.circlepath",
                                  color: .strongPink,
                                  textFont: .title3,
                                  symbolFont: .title3)
        }
    }
}
