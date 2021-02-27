//
//  DoneButton.swift
//  RamenShopApp
//
//  Created by Koro Saka on 2021-02-25.
//  Copyright © 2021 Koro Saka. All rights reserved.
//

import SwiftUI

struct DoneButton: View {
    @EnvironmentObject var viewModel: ReviewingViewModel
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        Button(action: {
            viewModel.activeAlert = .confirmation
            viewModel.isShowAlert = true
        }) {
            HStack {
                Spacer()
                Image(systemName: "paperplane.fill")
                    .font(.largeTitle)
                Spacer().frame(width: 20)
                Text(Constants.SEND_REVIEW)
                    .font(.largeTitle)
                    .bold()
                Spacer()
            }
        }
        .setEnabled(enabled: viewModel.isEnoughInfo,
                    defaultColor: .strongPink,
                    padding: 10,
                    radius: 20)
        .padding(10)
        .alert(isPresented: $viewModel.isShowAlert) {
            switch viewModel.activeAlert {
            case .confirmation:
                return Alert(title: Text(Constants.CONFIRM_TITLE),
                             message: Text(Constants.ASKING_SENDING_REVIEW),
                             primaryButton: .default(Text(Constants.YES)) {
                                viewModel.sendReview()
                             },
                             secondaryButton: .cancel(Text(Constants.CANCEL)))
            case .completion:
                return Alert(title: Text(Constants.SUCCESS),
                             message: Text(Constants.DONE_REVIEW),
                             dismissButton: .default(Text(Constants.OK)) {
                                presentationMode.wrappedValue.dismiss()
                             })
            case .error:
                return Alert(title: Text(Constants.FAILED),
                             message: Text(Constants.FAILED_REVIEW),
                             dismissButton: .default(Text(Constants.OK)) {
                                presentationMode.wrappedValue.dismiss()
                             })
            }
        }
    }
    
}
