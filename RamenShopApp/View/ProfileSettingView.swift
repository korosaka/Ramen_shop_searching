//
//  ProfileSettingView.swift
//  RamenShopApp
//
//  Created by Koro Saka on 2020-12-29.
//  Copyright © 2020 Koro Saka. All rights reserved.
//

import SwiftUI

struct ProfileSettingView: View {
    var body: some View {
        VStack(spacing: 0) {
            CustomNavigationBar(additionalAction: nil)
            Spacer().frame(height: 30)
            IconProfile()
            Spacer().frame(height: 30)
            NameProfile()
            Spacer()
        }
        .background(Color.green)
        .navigationBarHidden(true)
    }
}


struct IconProfile: View {
    @EnvironmentObject var viewModel: ProfileSettingViewModel
    var body: some View {
        viewModel.getIconImage()
        Spacer().frame(height: 10)
        Button(action: {}) {
            Text("change icon image")
        }
    }
}

struct NameProfile: View {
    @EnvironmentObject var viewModel: ProfileSettingViewModel
    @State var isShowConfirmation = false
    var body: some View {
        Text(viewModel.getUserName())
            .font(.title)
            .bold()
            .foregroundColor(.white)
        Spacer().frame(height: 10)
        if viewModel.isEditingName {
            TextField("user name", text: $viewModel.newName)
                .basicStyle()
        }
        HStack {
            Spacer()
            Button(action: {
                //MARK: TODO DO within VM
                viewModel.isEditingName.toggle()
                viewModel.newName = ""
            }) {
                //MARK: TODO DO within VM
                if viewModel.isEditingName {
                    Text("cancel")
                } else {
                    Text("change name")
                }
            }
            .basicStyle(foreColor: .white,
                        backColor: .orange,
                        padding: 10,
                        radius: 10)
            
            Spacer().frame(width: 40)
            //MARK: TODO set disabled
            Button(action: {
                UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
                isShowConfirmation = true
            }) {
                Text("done")
            }
            .basicStyle(foreColor: .white,
                        backColor: .red,
                        padding: 10,
                        radius: 10)
            .alert(isPresented: $isShowConfirmation) {
                Alert(title: Text("Confirmation"),
                      message: Text("Change name?"),
                      primaryButton: .default(Text("Yes")) {
                        viewModel.updateUserName()
                      },
                      secondaryButton: .cancel(Text("No")))
            }
            Spacer()
        }
    }
}
