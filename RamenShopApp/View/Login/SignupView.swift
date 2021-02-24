//
//  SignupView.swift
//  RamenShopApp
//
//  Created by Koro Saka on 2021-02-24.
//  Copyright © 2021 Koro Saka. All rights reserved.
//

import SwiftUI

struct SignupView: View {
    
    @ObservedObject var viewModel: LoginViewModel
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        ZStack {
            BackGroundView()
            VStack(spacing: 0) {
                CustomNavigationBar(additionalAction: nil)
                Spacer().frame(height: UIScreen.main.bounds.height / 5)
                Text(Constants.SIGNUP_UPPERCASE)
                    .foregroundColor(.viridianGreen)
                    .font(.largeTitle)
                    .bold()
                    .shadow(color: .black, radius: 2, x: 2, y: 2)
                Spacer().frame(height: 70)
                TextField(Constants.EMAIL, text: $viewModel.email)
                    .basicStyle()
                Spacer().frame(height: 30)
                TextField(Constants.PASSWORD, text: $viewModel.password)
                    .basicStyle()
                Spacer().frame(height: 50)
                Button(action: {
                    self.viewModel.createAccount()
                }) {
                    Text(Constants.SIGNUP)
                        .containingSymbol(symbol: "person.badge.plus",
                                          color: .viridianGreen,
                                          textFont: .title,
                                          symbolFont: .title3)
                }
                .alert(isPresented: $viewModel.isShowSignUpAlert) {
                    if viewModel.sentEmail {
                        return Alert(title: Text(Constants.SENT_EMAIL_TITLE),
                                     message: Text(Constants.SENT_EMAIL_MESSAGE),
                                     dismissButton: .default(Text(Constants.OK),
                                                             action: {
                                                                self.viewModel.reset()
                                                                presentationMode.wrappedValue.dismiss()
                                                             }
                                     )
                        )
                    } else {
                        return Alert(title: Text(Constants.SIGNUP_ERROR_TITLE),
                                     message: Text(viewModel.errorMesaage),
                                     dismissButton: .default(Text(Constants.OK),
                                                             action: { self.viewModel.reset() }))
                    }
                    
                }
                Spacer()
            }
            if viewModel.isShowingProgress {
                CustomedProgress()
            }
        }
        .navigationBarHidden(true)
    }
}
