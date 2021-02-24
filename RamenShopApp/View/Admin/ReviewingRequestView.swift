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
                Text(viewModel.requestedShop.name)
                    .largestTitleStyle()
                Spacer().frame(height: 10)
                GoogleMapView(inspectingRequestVM: viewModel)
                    .cornerRadius(20)
                    .padding(5)
                HStack {
                    Spacer()
                    Button(action: { viewModel.isShowingAlert.toggle() }) {
                        Text("Approve")
                            .containingSymbol(symbol: "hand.thumbsup.fill",
                                              color: .seaBlue,
                                              textFont: .title2,
                                              symbolFont: .title3)
                    }
                    Spacer()
                    Button(action: { isShowRejectModal.toggle() }) {
                        Text("Reject")
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
                    return Alert(title: Text("Final confirmation"),
                                 message: Text("Are you sure to approve it?"),
                                 primaryButton: .default(Text("Yes")) {
                                    viewModel.approve()
                                 },
                                 secondaryButton: .cancel(Text("cancel")))
                case .completion:
                    return Alert(title: Text("Success!"),
                                 message: Text("Updating has been done."),
                                 dismissButton: .default(Text("OK")) {
                                    presentationMode.wrappedValue.dismiss()
                                    viewModel.completedInspection()
                                 })
                case .error:
                    return Alert(title: Text("Fail"),
                                 message: Text("Updating was failed"),
                                 dismissButton: .default(Text("OK")) {
                                    presentationMode.wrappedValue.dismiss()
                                    viewModel.completedInspection()
                                 })
                }
            }
        }
    }
}

struct RejectModal: View {
    @ObservedObject var viewModel: ReviewingRequestViewModel
    @Environment(\.presentationMode) var presentationMode
    @State var isShowRejectConfirmation = false
    var body: some View {
        VStack {
            Text("Reason")
                .middleTitleStyle()
                .upDownPadding(size: 10)
            TextEditor(text: $viewModel.rejectReason)
                .frame(width: UIScreen.main.bounds.width * 0.9,
                       height: 250)
                .cornerRadius(10)
            Spacer().frame(height: 20)
            HStack {
                Spacer()
                Button(action: { isShowRejectConfirmation.toggle() }) {
                    Text("Done")
                        .font(.title)
                        .bold()
                        .shadow(color: .black, radius: 2, x: 2, y: 2)
                }
                .basicStyle(foreColor: .white,
                            backColor: .red,
                            padding: 10,
                            radius: 10)
                .alert(isPresented: $isShowRejectConfirmation) {
                    Alert(title: Text("Final confirmation"),
                          message: Text("Are you sure to reject it?"),
                          primaryButton: .default(Text("Yes")) {
                            viewModel.reject()
                            presentationMode.wrappedValue.dismiss()
                          },
                          secondaryButton: .cancel(Text("cancel")))
                }
                Spacer()
                Button(action: {
                    UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
                }) {
                    Text("Stop")
                        .font(.title)
                        .bold()
                        .shadow(color: .black, radius: 2, x: 2, y: 2)
                }
                .basicStyle(foreColor: .white,
                            backColor: .blue,
                            padding: 10,
                            radius: 10)
                Spacer()
            }
            Spacer()
        }
        .background(Color.orange)
    }
}
