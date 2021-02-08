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
            BackGroundView()
            ScrollView(.vertical) {
                ZStack(alignment: .topTrailing) {
                    VStack(spacing: 0) {
                        Spacer().frame(height: 15)
                        IconProfile()
                        Spacer().frame(height: 10)
                        NameProfile()
                        Spacer().frame(height: 10)
                    }
                    .wideStyle()
                    
                    VStack(spacing: 0) {
                        Spacer().frame(height: 15)
                        HStack {
                            Spacer()
                            Button(action: {
                                viewModel.isShowingMenu.toggle()
                            }) {
                                Image(systemName: "gearshape.fill")
                                    .foregroundColor(.gray)
                                    .font(.title)
                                    .shadow(color: .black, radius: 1, x: 1, y: 1)
                            }
                        }
                        if viewModel.isShowingMenu {
                            Spacer().frame(height: 10)
                            HStack {
                                Spacer()
                                ProfileSettingMenu()
                            }
                        }
                    }
                    .sidePadding(size: 10)
                }
                
            }
            if viewModel.isShowingProgress {
                CustomedProgress()
            }
        }
    }
}

struct IconProfile: View {
    @EnvironmentObject var viewModel: ProfileViewModel
    var body: some View {
        VStack {
            viewModel
                .getIconImage()
                .iconLargeStyle()
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
                TextField("user name", text: $viewModel.newName)
                    .basicStyle()
                Spacer().frame(height: 15)
                HStack {
                    Spacer()
                    Button(action: {
                        viewModel.onClickChangeName()
                    }) {
                        Text("cancel")
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
                        Text("done").font(.title2).bold()
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
    }
}

struct ProfileSettingMenu: View {
    @EnvironmentObject var viewModel: ProfileViewModel
    
    var body: some View {
        VStack(spacing: 0) {
            Spacer().frame(height: 15)
            Button(action: {
                viewModel.checkPhotoPermission()
                viewModel.isShowingMenu.toggle()
            }) {
                Text("change icon")
            }
            Spacer().frame(height: 25)
            Button(action: {
                viewModel.onClickChangeName()
                viewModel.isShowingMenu.toggle()
            }) {
                Text("change name")
            }
            Spacer().frame(height: 25)
            Button(action: {
                viewModel.isShowingMenu.toggle()
            }) {
                Text("close")
            }
            Spacer().frame(height: 15)
        }
        .sidePadding(size: 5)
        .background(Color.superWhitePasteGreen)
        .cornerRadius(10)
    }
}
