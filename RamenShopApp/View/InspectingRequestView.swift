//
//  InspectingRequestView.swift
//  RamenShopApp
//
//  Created by Koro Saka on 2021-01-13.
//  Copyright © 2021 Koro Saka. All rights reserved.
//

import SwiftUI

struct InspectingRequestView: View {
    @ObservedObject var viewModel: InspectingRequestViewModel
    @State var isShowApproveConfirmation = false
    @State var isShowRejectModal = false
    var body: some View {
        VStack(spacing: 0) {
            CustomNavigationBar(additionalAction: nil)
            Text(viewModel.requestedShop.name)
                .font(.title)
                .bold()
                .underline()
                .foregroundColor(.white)
                .padding(5)
            GoogleMapView(inspectingRequestVM: viewModel)
                .padding(5)
            HStack {
                Spacer()
                Button(action: { isShowApproveConfirmation.toggle() }) {
                    Text("Approve")
                        .font(.title)
                        .bold()
                }
                .basicStyle(foreColor: .white,
                            backColor: .blue,
                            padding: 10,
                            radius: 10)
                .alert(isPresented: $isShowApproveConfirmation) {
                    Alert(title: Text("Final confirmation"),
                          message: Text("Are you sure to approve it?"),
                          primaryButton: .default(Text("Yes")) {
                            //MARK: TODO
                          },
                          secondaryButton: .cancel(Text("cancel")))
                }
                Spacer()
                Button(action: { isShowRejectModal.toggle() }) {
                    Text("Reject")
                        .font(.title)
                        .bold()
                }
                .basicStyle(foreColor: .white,
                            backColor: .red,
                            padding: 10,
                            radius: 10)
                .sheet(isPresented: $isShowRejectModal) {
                    RejectModal(viewModel: self.viewModel)
                }
                Spacer()
            }
            .upDownPadding(size: 15)
        }
        .background(Color.green)
        .navigationBarHidden(true)
    }
}

struct RejectModal: View {
    @ObservedObject var viewModel: InspectingRequestViewModel
    @State var isShowRejectConfirmation = false
    var body: some View {
        VStack {
            Text("reason for reject")
                .font(.title)
                .foregroundColor(.white)
                .bold()
                .underline()
                .upDownPadding(size: 10)
            TextEditor(text: $viewModel.rejectReason)
                .frame(width: UIScreen.main.bounds.width * 0.9,
                       height: 250)
            HStack {
                Spacer()
                Button(action: { isShowRejectConfirmation.toggle() }) {
                    Text("Done")
                        .font(.title)
                        .bold()
                }
                .basicStyle(foreColor: .white,
                            backColor: .red,
                            padding: 10,
                            radius: 10)
                .alert(isPresented: $isShowRejectConfirmation) {
                    Alert(title: Text("Final confirmation"),
                          message: Text("Are you sure to reject it?"),
                          primaryButton: .default(Text("Yes")) {
                            //MARK: TODO
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
