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

struct RequestInfo: View {
    @EnvironmentObject var viewModel: RequestStatusViewModel
    var body: some View {
        VStack(spacing: 0) {
            Spacer().frame(height: 10).wideStyle()
            RequestedShopName(name: viewModel.shopName ?? "")
            Spacer().frame(height: 30)
            ReviewStatus()
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
    @EnvironmentObject var viewModel: RequestStatusViewModel
    var body: some View {
        VStack {
            Text("review status")
                .foregroundColor(.black)
                .underline()
            Spacer().frame(height: 5)
            Text(viewModel.inspectionStatus?.getStatus() ?? "").largestTitleStyleWithColor(color: viewModel.inspectionStatus?.getStatusColor() ?? .black)
            Spacer().frame(height: 5)
            Text(viewModel.inspectionStatus?.getSubMessage() ?? "").foregroundColor(.gray)
            Spacer().frame(height: 30)
            if viewModel.isRejected {
                RejectReason()
                    .padding(5)
                Spacer().frame(height: 30)
            }
        }
    }
}

struct RemoveButton: View {
    @EnvironmentObject var viewModel: RequestStatusViewModel
    var body: some View {
        Button(action: {
            viewModel.isShowAlert = true
        }) {
            Text(viewModel.inspectionStatus?.getButtonMessage() ?? "")
                .containingSymbolWide(symbol: "trash",
                                      color: .strongRed,
                                      textFont: .title,
                                      symbolFont: .title2)
        }
        .alert(isPresented: $viewModel.isShowAlert) {
            switch viewModel.activeAlert {
            case .confirmation:
                return Alert(title: Text("Confirmation"),
                             message: Text(viewModel.inspectionStatus?.getConfirmationMessage() ?? ""),
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

struct RejectReason: View {
    @EnvironmentObject var viewModel: RequestStatusViewModel
    var body: some View {
        VStack {
            Text("reason for reject")
                .foregroundColor(.black)
                .underline()
                .wideStyle()
            Spacer().frame(height: 5)
            Text(viewModel.rejectReason)
                .foregroundColor(.navy)
                .bold()
        }
    }
}

struct ReloadStatusButton: View {
    @EnvironmentObject var viewModel: RequestStatusViewModel
    var body: some View {
        Button(action: {
            self.viewModel.fetchRequestStatus()
        }) {
            Image(systemName: "arrow.triangle.2.circlepath")
                .circleSymbol(font: .title3,
                              fore: .white,
                              back: .strongPink)
        }
    }
}
