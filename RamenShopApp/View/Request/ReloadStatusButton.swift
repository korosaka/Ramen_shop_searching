//
//  ReloadStatusButton.swift
//  RamenShopApp
//
//  Created by Koro Saka on 2021-02-24.
//  Copyright © 2021 Koro Saka. All rights reserved.
//

import SwiftUI

struct ReloadStatusButton: View {
    @EnvironmentObject var viewModel: RequestStatusViewModel
    var body: some View {
        Button(action: {
            self.viewModel.fetchRequestStatus()
        }) {
            Image(systemName: "arrow.triangle.2.circlepath")
                .circleSymbol(font: .title3,
                              fore: .white,
                              back: .strongPink)
        }
    }
}
