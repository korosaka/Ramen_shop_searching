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
        Button(action: {
            viewModel.checkPhotoPermission()
        }) {
            Text("change icon image")
        }
        .sheet(isPresented: $viewModel.isShowPhotoLibrary,
               content: { ImagePicker(delegate: viewModel) })
        .alert(isPresented: $viewModel.isShowPhotoPermissionDenied) {
            Alert(title: Text("This app has no permission"),
                  message: Text("You need to change setting"),
                  primaryButton: .default(Text("go to setting")) {
                    goToSetting()
                  },
                  secondaryButton: .cancel(Text("cancel")))
        }
    }
}

struct NameProfile: View {
    @EnvironmentObject var viewModel: ProfileSettingViewModel
    
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
                viewModel.isShowAlertForName = true
            }) {
                Text("done")
            }
            .setEnabled(enabled: viewModel.isNameEdited,
                        defaultColor: .red,
                        padding: 10,
                        radius: 10)
            .alert(isPresented: $viewModel.isShowAlertForName) {
                switch viewModel.activeAlertForName {
                case .confirmation:
                    return Alert(title: Text("Confirmation"),
                                 message: Text("Change name?"),
                                 primaryButton: .default(Text("Yes")) {
                                    viewModel.updateUserName()
                                 },
                                 secondaryButton: .cancel(Text("cancel")))
                case .completion:
                    return Alert(title: Text("Success"),
                                 message: Text("User name has been updated!"),
                                 dismissButton: .default(Text("OK")) {
                                    viewModel.resetAlertData()
                                 })
                case .error:
                    return Alert(title: Text("Failed"),
                                 message: Text("Updating user name was failed"),
                                 dismissButton: .default(Text("OK")){
                                    viewModel.resetAlertData()
                                 })
                }
            }
            Spacer()
        }
    }
}
