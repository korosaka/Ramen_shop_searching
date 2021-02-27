//
//  SendingRequestButton.swift
//  RamenShopApp
//
//  Created by Koro Saka on 2021-02-26.
//  Copyright © 2021 Koro Saka. All rights reserved.
//

import SwiftUI

struct SendingRequestButton: View {
    @ObservedObject var viewModel: RegisteringShopViewModel
    @Environment(\.presentationMode) var presentationMode
    var body: some View {
        Button(action: {
            viewModel.isShowAlert = true
        }) {
            Text(Constants.SEND_REQUEST)
                .containingSymbolWide(symbol: "paperplane.fill",
                                      color: .strongPink,
                                      textFont: .largeTitle,
                                      symbolFont: .largeTitle)
        }
        .padding(10)
        .alert(isPresented: $viewModel.isShowAlert) {
            if (viewModel.location == nil) {
                return Alert(title: Text(Constants.INSUFFICIENT_DATA),
                             message: Text(Constants.NO_LOCATION),
                             dismissButton: .default(Text(Constants.CLOSE)))
            }
            if (!viewModel.isZoomedEnough) {
                return Alert(title: Text(Constants.ROUGH_LOCATION),
                             message: Text(Constants.REQUIRE_ZOOM),
                             dismissButton: .default(Text(Constants.CLOSE)))
            }
            switch viewModel.activeAlertForName {
            case .confirmation:
                return Alert(title: Text(Constants.CONFIRM_TITLE),
                             message: Text(Constants.ASK_REQUESTING),
                             primaryButton: .default(Text(Constants.YES)) {
                                viewModel.sendShopRequest()
                             },
                             secondaryButton: .cancel(Text(Constants.CANCEL)))
            case .completion:
                return Alert(title: Text(Constants.SUCCESS),
                             message: Text(Constants.DONE_REQUEST),
                             dismissButton: .default(Text(Constants.OK)) {
                                viewModel.resetData()
                                presentationMode.wrappedValue.dismiss()
                             })
            case .error:
                return Alert(title: Text(Constants.FAILED),
                             message: Text(Constants.FAILED_REQUEST),
                             dismissButton: .default(Text(Constants.OK)) {
                                viewModel.resetData()
                                presentationMode.wrappedValue.dismiss()
                             })
            }
        }
    }
}
