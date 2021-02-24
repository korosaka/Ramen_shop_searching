//
//  RequestStatusView.swift
//  RamenShopApp
//
//  Created by Koro Saka on 2021-01-03.
//  Copyright © 2021 Koro Saka. All rights reserved.
//

import SwiftUI

struct RequestStatusView: View {
    @EnvironmentObject var viewModel: RequestStatusViewModel
    var body: some View {
        ZStack {
            BackGroundView()
            ScrollView(.vertical) {
                ZStack(alignment: .topTrailing) {
                    VStack(spacing: 0) {
                        Spacer().frame(height: 15)
                        Text("Request Status")
                            .middleTitleStyle()
                        if viewModel.hasRequest {
                            Spacer().frame(height: 30)
                            RequestInfo()
                                .sidePadding(size: 15)
                            Spacer().frame(height: 20)
                            RemoveButton()
                                .sidePadding(size: 15)
                            Spacer().frame(height: 30)
                            Text(viewModel.annotation)
                                .bold()
                                .foregroundColor(.navy)
                                .padding(10)
                                .sidePadding(size: 10)
                            Spacer().frame(height: 50)
                        } else {
                            Spacer()
                            Text("You have no request now")
                                .foregroundColor(.white)
                            Spacer()
                        }
                    }
                    .wideStyle()
                    
                    ReloadStatusButton().padding(10)
                }
            }
            if viewModel.isShowingProgress {
                CustomedProgress()
            }
        }
        .navigationBarHidden(true)
    }
}
