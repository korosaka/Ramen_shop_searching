//
//  ReviewingView.swift
//  RamenShopApp
//
//  Created by Koro Saka on 2020-12-20.
//  Copyright © 2020 Koro Saka. All rights reserved.
//

import SwiftUI

struct ReviewingView: View {
    @EnvironmentObject var viewModel: ReviewingViewModel
    var body: some View {
        ZStack {
            BackGroundView()
            VStack(spacing: 0) {
                CustomNavigationBar {
                    viewModel.leaveReviewing()
                }
                ScrollView(.vertical) {
                    Spacer().frame(height: 10)
                    ShopName(shopName: viewModel.shop?.getName())
                    Spacer().frame(height: 20)
                    StarSelectView()
                        .sidePadding(size: 20)
                    Spacer().frame(height: 20)
                    EditingCommentView()
                    Spacer().frame(height: 50)
                    UploadingPicture()
                        .sidePadding(size: 10)
                    Spacer().frame(height: 40)
                    DoneButton()
                }
                .frame(width: UIScreen.main.bounds.width)
            }
            if viewModel.isShowingProgress {
                CustomedProgress()
            }
        }
        .navigationBarHidden(true)
    }
}
