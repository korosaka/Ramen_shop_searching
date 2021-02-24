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
                return Alert(title: Text("Confirmation"),
                             message: Text(viewModel.inspectionStatus?.getConfirmationMessage() ?? Constants.EMPTY),
                             primaryButton: .default(Text("Yes")) {
                                viewModel.onClickConfirmation()
                             },
                             secondaryButton: .cancel(Text("cancel")))
            case .completion:
                return Alert(title: Text("Success"),
                             message: Text("Updating data was succeeded"),
                             dismissButton: .default(Text("Close")) {
                                viewModel.resetData()
                             })
            case .error:
                return Alert(title: Text("Fail"),
                             message: Text("Updating data was failed"),
                             dismissButton: .default(Text("Close")) {
                                viewModel.resetData()
                             })
            }
        }
    }
}

