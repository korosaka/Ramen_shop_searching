//
//  ProfileSettingMenu.swift
//  RamenShopApp
//
//  Created by Koro Saka on 2021-02-24.
//  Copyright © 2021 Koro Saka. All rights reserved.
//

import SwiftUI

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
