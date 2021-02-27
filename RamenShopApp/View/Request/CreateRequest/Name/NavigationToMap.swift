//
//  NavigationToMap.swift
//  RamenShopApp
//
//  Created by Koro Saka on 2021-02-26.
//  Copyright © 2021 Koro Saka. All rights reserved.
//

import SwiftUI

struct NavigationToMap: View {
    @ObservedObject var viewModel: RegisteringShopViewModel
    var body: some View {
        NavigationLink(destination: RegisteringShopPlaceView(viewModel: self.viewModel)) {
            if viewModel.isNameSet {
                Text(Constants.SET_LOCATION)
                    .containingSymbolWide(symbol: "mappin.and.ellipse",
                                          color: .strongPink,
                                          textFont: .title,
                                          symbolFont: .title3)
            } else {
                Text(Constants.SET_LOCATION)
                    .containingSymbolDisableWide(symbol: "mappin.and.ellipse",
                                                 textFont: .title,
                                                 symbolFont: .title3)
            }
        }
        .disabled(!viewModel.isNameSet)
    }
}
