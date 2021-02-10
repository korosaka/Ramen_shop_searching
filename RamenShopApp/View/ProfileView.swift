//
//  ProfileSettingView.swift
//  RamenShopApp
//
//  Created by Koro Saka on 2020-12-29.
//  Copyright © 2020 Koro Saka. All rights reserved.
//

import SwiftUI
import QGrid

struct ProfileView: View {
    @EnvironmentObject var viewModel: ProfileViewModel
    var body: some View {
        ZStack {
            Color.white
            ZStack(alignment: .topTrailing) {
                VStack(spacing: 0) {
                    VStack(spacing: 0) {
                        Spacer().frame(height: 15)
                        IconProfile()
                        Spacer().frame(height: 10)
                        NameProfile()
                        Spacer().frame(height: 20)
                    }
                    .wideStyle()
                    .background(BackGroundView())
                    VStack(spacing: 0) {
                        FavoriteHeader()
                        FavoriteCollectionView(scrollable: true,
                                               favorites: viewModel.userFavorites)
                    }
                }
                
                VStack(spacing: 0) {
                    Spacer().frame(height: 10)
                    ReloadButton()
                        .sidePadding(size: 10)
                    Spacer().frame(height: 15)
                    ProfileSetting()
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

struct ReloadButton: View {
    @EnvironmentObject var viewModel: ProfileViewModel
    
    var body: some View {
        HStack {
            Spacer()
            Button(action: {
                self.viewModel.reload()
            }) {
                Image(systemName: "arrow.triangle.2.circlepath")
                    .circleSymbol(font: .title3,
                                  fore: .white,
                                  back: .strongPink)
            }
        }
    }
}

struct ProfileSetting: View {
    @EnvironmentObject var viewModel: ProfileViewModel
    
    var body: some View {
        VStack(spacing: 0) {
            HStack {
                Spacer()
                Button(action: {
                    viewModel.isShowingMenu.toggle()
                }) {
                    Image(systemName: "gearshape.fill")
                        .circleSymbol(font: .title3,
                                      fore: .white,
                                      back: .gray)
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
    }
}

struct ProfileSettingMenu: View {
    @EnvironmentObject var viewModel: ProfileViewModel
    
    var body: some View {
        VStack(spacing: 0) {
            Spacer().frame(height: 15)
            Button(action: {
                viewModel.checkPhotoPermission()
                viewModel.isShowingMenu = false
            }) {
                Text("change icon")
            }
            Spacer().frame(height: 25)
            Button(action: {
                viewModel.onClickChangeName()
                viewModel.isShowingMenu = false
            }) {
                Text("change name")
            }
            Spacer().frame(height: 25)
            Button(action: {
                viewModel.isShowingMenu = false
            }) {
                Text("close")
            }
            Spacer().frame(height: 15)
        }
        .sidePadding(size: 5)
        .background(Color.whitePasteGreen)
        .cornerRadius(10)
    }
}

struct FavoriteHeader: View {
    @EnvironmentObject var viewModel: ProfileViewModel
    
    var body: some View {
        Image(systemName: "heart.fill")
            .font(.title)
            .foregroundColor(.strongPink)
            .upDownPadding(size: 5)
            .wideStyle().background(Color.superWhitePasteGreen)
            .shadow(color: .black, radius: 1)
    }
    
}

struct FavoriteCollectionView: View {
    let scrollable: Bool
    let favorites: [FavoriteShopInfo]
    let pictureSize: CGFloat = UIScreen.main.bounds.size.width / 2.5
    let space: CGFloat = 3.0
    let padding: CGFloat = 3.0
    var row: Int {
        return (favorites.count + 1) / 2
    }
    var frameHieght: CGFloat? {
        if scrollable {
            return .none
        } else {
            return pictureSize * CGFloat(row)
                + space * CGFloat(row - 1)
                + padding * 2
        }
    }
    
    var body: some View {
        if favorites.count == 0 {
            VStack {
                Text("No Favorite Shop")
                    .upDownPadding(size: 30)
            }
        } else {
            QGrid(self.favorites,
                  columns: 2,
                  vSpacing: space,
                  hSpacing: space,
                  vPadding: padding,
                  hPadding: padding,
                  isScrollable: scrollable,
                  showScrollIndicators: scrollable
            ) { shopInfo in
                FavoriteCell(shopInfo: shopInfo, size: pictureSize)
            }
            .frame(height: frameHieght)
        }
        
    }
    
}

struct FavoriteCell: View {
    let shopInfo: FavoriteShopInfo
    let size: CGFloat
    
    var body: some View {
        NavigationLink(destination: ShopDetailView(viewModel: .init(shopID: shopInfo.id))) {
            VStack(spacing: 0) {
                if let image = shopInfo.shopTopImage {
                    image
                        .resizable()
                        .scaledToFill()
                        .frame(width: size, height: size)
                        .clipShape(Circle())
                } else {
                    Image(systemName: "camera.fill").font(.title)
                        .padding(20)
                        .frame(width: size, height: size)
                        .background(Color.gray)
                        .foregroundColor(.black)
                        .clipShape(Circle())
                }
                Text(shopInfo.shopName ?? "")
                    .bold()
                    .sidePadding(size: 10)
            }
        }
        .upDownPadding(size: 15)
    }
}

struct FavoriteShopInfo: Identifiable {
    let id: String //MARK: ShopID
    var shopName: String?
    var shopTopImage: Image?
}
