//
//  RemoveButton.swift
//  RamenShopApp
//
//  Created by Koro Saka on 2021-02-24.
//  Copyright © 2021 Koro Saka. All rights reserved.
//

import SwiftUI

struct RemoveButton: View {
    @EnvironmentObject var viewModel: RequestStatusViewModel
    var body: some View {
        Button(action: {
            viewModel.isShowAlert = true
        }) {
            Text(viewModel.inspectionStatus?.getButtonMessage() ?? Constants.EMPTY)
                .containingSymbolWide(symbol: "trash",
                                      color: .strongRed,
                                      textFont: .title,
                                      symbolFont: .title2)
        }
        .alert(isPresented: $viewModel.isShowAlert) {
            switch viewModel.activeAlert {
            case .confirmation:
                return Alert(title: Text(Constants.CONFIRM_TITLE),
                             message: Text(viewModel.inspectionStatus?.getConfirmationMessage() ?? Constants.EMPTY),
                             primaryButton: .default(Text(Constants.YES)) {
                                viewModel.onClickConfirmation()
                             },
                             secondaryButton: .cancel(Text(Constants.CANCEL)))
            case .completion:
                return Alert(title: Text(Constants.SUCCESS),
                             message: Text(Constants.SUCCESS_UPDATE),
                             dismissButton: .default(Text(Constants.CLOSE)) {
                                viewModel.resetData()
                             })
            case .error:
                return Alert(title: Text(Constants.FAILED),
                             message: Text(Constants.FAILED_UPDATE),
                             dismissButton: .default(Text(Constants.CLOSE)) {
                                viewModel.resetData()
                             })
            }
        }
    }
}

