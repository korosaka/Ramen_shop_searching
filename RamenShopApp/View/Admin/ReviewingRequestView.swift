//
//  InspectingRequestView.swift
//  RamenShopApp
//
//  Created by Koro Saka on 2021-01-13.
//  Copyright © 2021 Koro Saka. All rights reserved.
//

import SwiftUI

struct ReviewingRequestView: View {
    @ObservedObject var viewModel: ReviewingRequestViewModel
    @Environment(\.presentationMode) var presentationMode
    @State var isShowRejectModal = false
    var body: some View {
        ZStack {
            BackGroundView()
            VStack(spacing: 0) {
                CustomNavigationBar(additionalAction: nil)
                Spacer().frame(height: 10)
                Text(viewModel.requestedShop.getName())
                    .largestTitleStyle()
                Spacer().frame(height: 10)
                GoogleMapView(inspectingRequestVM: viewModel)
                    .cornerRadius(20)
                    .padding(5)
                HStack {
                    Spacer()
                    Button(action: { viewModel.isShowingAlert.toggle() }) {
                        Text(Constants.APPROVE)
                            .containingSymbol(symbol: "hand.thumbsup.fill",
                                              color: .seaBlue,
                                              textFont: .title2,
                                              symbolFont: .title3)
                    }
                    Spacer()
                    Button(action: { isShowRejectModal.toggle() }) {
                        Text(Constants.REJECT)
                            .containingSymbol(symbol: "hand.thumbsdown.fill",
                                              color: .strongRed,
                                              textFont: .title2,
                                              symbolFont: .title3)
                    }
                    .sheet(isPresented: $isShowRejectModal) {
                        RejectModal(viewModel: self.viewModel)
                    }
                    Spacer()
                }
                .upDownPadding(size: 15)
            }
            .navigationBarHidden(true)
            .alert(isPresented: $viewModel.isShowingAlert) {
                switch viewModel.activeAlert {
                case .confirmation:
                    return Alert(title: Text(Constants.CONFIRM_TITLE),
                                 message: Text(Constants.ASKING_APPROVE),
                                 primaryButton: .default(Text(Constants.YES)) {
                                    viewModel.approve()
                                 },
                                 secondaryButton: .cancel(Text(Constants.CANCEL)))
                case .completion:
                    return Alert(title: Text(Constants.SUCCESS),
                                 message: Text(Constants.SUCCESS_UPDATE),
                                 dismissButton: .default(Text(Constants.OK)) {
                                    presentationMode.wrappedValue.dismiss()
                                    viewModel.completedInspection()
                                 })
                case .error:
                    return Alert(title: Text(Constants.FAILED),
                                 message: Text(Constants.FAILED_UPDATE),
                                 dismissButton: .default(Text(Constants.OK)) {
                                    presentationMode.wrappedValue.dismiss()
                                    viewModel.completedInspection()
                                 })
                }
            }
        }
    }
}
