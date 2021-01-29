//
//  RequestStatusView.swift
//  RamenShopApp
//
//  Created by Koro Saka on 2021-01-03.
//  Copyright © 2021 Koro Saka. All rights reserved.
//

import SwiftUI

struct RequestStatusView: View {
    @ObservedObject var viewModel: RequestStatusViewModel
    var body: some View {
        ZStack {
            BackGroundView()
            ScrollView(.vertical) {
                Spacer().frame(height: 15)
                Text("Your Request Status")
                    .middleTitleStyle()
                if viewModel.hasRequest {
                    RequestInfo(viewModel: viewModel)
                        .padding(10)
                    Spacer().frame(height: 25)
                    Text(viewModel.annotation)
                        .bold()
                        .foregroundColor(.navy)
                        .padding(10)
                        .sidePadding(size: 10)
                } else {
                    Spacer()
                    Text("You have no request now").foregroundColor(.white)
                    Spacer()
                }
            }
            if viewModel.isShowingProgress {
                CustomedProgress()
            }
        }
        .navigationBarHidden(true)
    }
}

struct RequestInfo: View {
    @ObservedObject var viewModel: RequestStatusViewModel
    var body: some View {
        VStack {
            Spacer().frame(height: 10)
            RequestedShopName(name: viewModel.shopName!)
            Spacer().frame(height: 35)
            ReviewStatus(viewModel: viewModel)
            Spacer().frame(height: 60)
            RemoveButton(viewModel: viewModel)
            Spacer().frame(height: 10)
        }
        .background(Color.superWhitePasteGreen)
        .cornerRadius(20)
    }
}

struct RequestedShopName: View {
    let name: String
    var body: some View {
        VStack {
            Text("shop name")
                .foregroundColor(.black)
                .underline()
            Spacer().frame(height: 5)
            Text(name)
                .largestTitleStyleWithColor(color: .viridianGreen)
        }
    }
}

struct ReviewStatus: View {
    @ObservedObject var viewModel: RequestStatusViewModel
    var body: some View {
        VStack {
            Text("review status")
                .foregroundColor(.black)
                .underline()
            Spacer().frame(height: 5)
            Text(viewModel.inspectionStatus!.getStatus()).largestTitleStyleWithColor(color: viewModel.inspectionStatus!.getStatusColor())
            Spacer().frame(height: 10)
            Text(viewModel.inspectionStatus!.getSubMessage()).foregroundColor(.gray)
            if viewModel.isRejected {
                VStack {
                    Text("reason for reject")
                        .bold()
                        .underline()
                    Spacer().frame(height: 2)
                    Text(viewModel.rejectReason)
                }
                .padding(3)
                .background(Color.gray)
                .cornerRadius(10)
                .padding(10)
            }
        }
    }
}

struct RemoveButton: View {
    @ObservedObject var viewModel: RequestStatusViewModel
    var body: some View {
        Button(action: {
            viewModel.isShowAlert = true
        }) {
            Text(viewModel.inspectionStatus!.getButtonMessage())
                .containingSymbolWide(symbol: "trash",
                                      color: .strongRed,
                                      textFont: .title2,
                                      symbolFont: .title3)
                .wideStyle()
        }
        .alert(isPresented: $viewModel.isShowAlert) {
            switch viewModel.activeAlert {
            case .confirmation:
                return Alert(title: Text("Confirmation"),
                             message: Text(viewModel.inspectionStatus!.getConfirmationMessage()),
                             primaryButton: .default(Text("Yes")) {
                                viewModel.onClickConfirmation()
                             },
                             secondaryButton: .cancel(Text("cancel")))
            case .completion:
                return Alert(title: Text("Success"),
                             message: Text("Updating data was succeeded"),
                             dismissButton: .default(Text("Close")) {
                                viewModel.resetData()
                             })
            case .error:
                return Alert(title: Text("Fail"),
                             message: Text("Updating data was failed"),
                             dismissButton: .default(Text("Close")) {
                                viewModel.resetData()
                             })
            }
        }
    }
}
