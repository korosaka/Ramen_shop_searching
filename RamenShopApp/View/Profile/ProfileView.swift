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
                    Spacer()
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
