//
//  ProfileSetting.swift
//  RamenShopApp
//
//  Created by Koro Saka on 2021-02-24.
//  Copyright © 2021 Koro Saka. All rights reserved.
//

import SwiftUI

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
