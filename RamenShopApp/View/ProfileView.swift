//
//  ProfileSettingView.swift
//  RamenShopApp
//
//  Created by Koro Saka on 2020-12-29.
//  Copyright © 2020 Koro Saka. All rights reserved.
//

import SwiftUI

struct ProfileView: View {
    @EnvironmentObject var viewModel: ProfileViewModel
    var body: some View {
        ZStack {
            VStack(spacing: 0) {
                Titleheader()
                Spacer().frame(height: 30)
                IconProfile()
                Spacer().frame(height: 50)
                NameProfile()
                Spacer()
            }
            if viewModel.isShowingProgress {
                CustomedProgress()
            }
        }
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
                             message: Text("Profile has been updated!"),
                             dismissButton: .default(Text("OK")) {
                                viewModel.resetAlertData()
                             })
            case .error:
                return Alert(title: Text("Failed"),
                             message: Text("Updating profile was failed"),
                             dismissButton: .default(Text("OK")){
                                viewModel.resetAlertData()
                             })
            }
        }
        .background(Color.green)
    }
}

struct Titleheader: View {
    var body: some View {
        HStack {
            Spacer()
            Text("Your Profile")
                .font(.largeTitle)
                .foregroundColor(.white)
                .padding(5)
            Spacer()
        }
        .background(Color.red)
    }
}

struct IconProfile: View {
    @EnvironmentObject var viewModel: ProfileViewModel
    var body: some View {
        viewModel
            .getIconImage()
            .iconLargeStyle()
        Spacer().frame(height: 10)
        Button(action: {
            viewModel.checkPhotoPermission()
        }) {
            Text("change icon image")
        }
        .basicStyle(foreColor: .white,
                    backColor: .orange,
                    padding: 10,
                    radius: 10)
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
    @EnvironmentObject var viewModel: ProfileViewModel
    
    var body: some View {
        Text(viewModel.getUserName())
            .font(.largeTitle)
            .bold()
            .foregroundColor(.white)
        Spacer().frame(height: 15)
        if viewModel.isEditingName {
            TextField("user name", text: $viewModel.newName)
                .basicStyle()
        }
        VStack {
            Button(action: {
                viewModel.onClickChangeName()
            }) {
                Text(viewModel.changeNameButtonText)
            }
            .basicStyle(foreColor: .white,
                        backColor: .orange,
                        padding: 10,
                        radius: 10)
            Spacer().frame(height: 10)
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
        }
    }
}
