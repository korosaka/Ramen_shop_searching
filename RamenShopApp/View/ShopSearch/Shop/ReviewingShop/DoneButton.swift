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
                Text("send review")
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
                return Alert(title: Text("Final confirmation"),
                             message: Text("Will you send this review?"),
                             primaryButton: .default(Text("Yes")) {
                                viewModel.sendReview()
                             },
                             secondaryButton: .cancel(Text("cancel")))
            case .completion:
                return Alert(title: Text("Success"),
                             message: Text("Your review has been done"),
                             dismissButton: .default(Text("OK")) {
                                presentationMode.wrappedValue.dismiss()
                             })
            case .error:
                return Alert(title: Text("Failed"),
                             message: Text("Uploading this review was failed"),
                             dismissButton: .default(Text("OK")) {
                                presentationMode.wrappedValue.dismiss()
                             })
            }
        }
    }
    
}
