//
//  RejectModal.swift
//  RamenShopApp
//
//  Created by Koro Saka on 2021-02-24.
//  Copyright © 2021 Koro Saka. All rights reserved.
//

import SwiftUI

struct RejectModal: View {
    @ObservedObject var viewModel: ReviewingRequestViewModel
    @Environment(\.presentationMode) var presentationMode
    @State var isShowRejectConfirmation = false
    var body: some View {
        VStack {
            Text(Constants.REASON)
                .middleTitleStyle()
                .upDownPadding(size: 10)
            TextEditor(text: $viewModel.rejectReason)
                .frame(width: UIScreen.main.bounds.width * 0.9,
                       height: 250)
                .cornerRadius(10)
            Spacer().frame(height: 20)
            HStack {
                Spacer()
                Button(action: { isShowRejectConfirmation.toggle() }) {
                    Text(Constants.DONE)
                        .font(.title)
                        .bold()
                        .shadow(color: .black, radius: 2, x: 2, y: 2)
                }
                .basicStyle(foreColor: .white,
                            backColor: .red,
                            padding: 10,
                            radius: 10)
                .alert(isPresented: $isShowRejectConfirmation) {
                    Alert(title: Text(Constants.CONFIRM_TITLE),
                          message: Text(Constants.ASKING_REJECT),
                          primaryButton: .default(Text(Constants.YES)) {
                            viewModel.reject()
                            presentationMode.wrappedValue.dismiss()
                          },
                          secondaryButton: .cancel(Text(Constants.CANCEL)))
                }
                Spacer()
                Button(action: {
                    UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
                }) {
                    Text(Constants.STOP)
                        .font(.title)
                        .bold()
                        .shadow(color: .black, radius: 2, x: 2, y: 2)
                }
                .basicStyle(foreColor: .white,
                            backColor: .blue,
                            padding: 10,
                            radius: 10)
                Spacer()
            }
            Spacer()
        }
        .background(Color.orange)
    }
}
