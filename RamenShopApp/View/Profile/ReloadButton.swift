//
//  ReloadButton.swift
//  RamenShopApp
//
//  Created by Koro Saka on 2021-02-24.
//  Copyright © 2021 Koro Saka. All rights reserved.
//

import SwiftUI

struct ReloadButton: View {
    @EnvironmentObject var viewModel: ProfileViewModel
    
    var body: some View {
        HStack {
            Spacer()
            Button(action: {
                self.viewModel.reload()
            }) {
                Image(systemName: "arrow.triangle.2.circlepath")
                    .circleSymbol(font: .title3,
                                  fore: .white,
                                  back: .strongPink)
            }
        }
    }
}
