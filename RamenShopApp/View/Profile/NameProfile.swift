//
//  NameProfile.swift
//  RamenShopApp
//
//  Created by Koro Saka on 2021-02-24.
//  Copyright © 2021 Koro Saka. All rights reserved.
//

import SwiftUI

struct NameProfile: View {
    @EnvironmentObject var viewModel: ProfileViewModel
    
    var body: some View {
        VStack(spacing: 0) {
            Text(viewModel.getUserName())
                .font(.largeTitle)
                .bold()
                .foregroundColor(.strongPink)
                .shadow(color: .black, radius: 2, x: 2, y: 2)
            if viewModel.isEditingName {
                Spacer().frame(height: 15)
                TextField(Constants.USER_NAME, text: $viewModel.newName)
                    .basicStyle()
                Spacer().frame(height: 15)
                HStack {
                    Spacer()
                    Button(action: {
                        viewModel.onClickChangeName()
                    }) {
                        Text(Constants.CANCEL)
                            .containingSymbol(symbol: "trash.fill",
                                              color: .strongRed,
                                              textFont: .title2,
                                              symbolFont: .title3)
                    }
                    Spacer()
                    Button(action: {
                        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
                        viewModel.isShowingAlert = true
                    }) {
                        Spacer().frame(width: 15)
                        Text(Constants.DONE).font(.title2).bold()
                        Spacer().frame(width: 5)
                        Image(systemName: "paperplane.fill").font(.title3)
                        Spacer().frame(width: 15)
                    }
                    .setEnabled(enabled: viewModel.isNameEdited,
                                defaultColor: .strongPink,
                                padding: 10,
                                radius: 20)
                    Spacer()
                }
            }
        }
        .alert(isPresented: $viewModel.isShowingAlert) {
            switch viewModel.activeAlertForName {
            case .confirmation:
                return Alert(title: Text(Constants.CONFIRM_TITLE),
                             message: Text(Constants.ASKING_CHANGE_NAME),
                             primaryButton: .default(Text(Constants.YES)) {
                                viewModel.updateUserName()
                             },
                             secondaryButton: .cancel(Text(Constants.CANCEL)))
            case .completion:
                return Alert(title: Text(Constants.SUCCESS),
                             message: Text(Constants.SUCCESS_UPDATE),
                             dismissButton: .default(Text(Constants.OK)) {
                                viewModel.resetAlertData()
                             })
            case .error:
                return Alert(title: Text(Constants.FAILED),
                             message: Text(Constants.FAILED_UPDATE),
                             dismissButton: .default(Text(Constants.OK)){
                                viewModel.resetAlertData()
                             })
            }
        }
    }
}
