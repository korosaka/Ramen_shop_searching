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
        VStack(spacing: 0) {
            HStack {
                Spacer()
                Text("Your request's status to add new shop")
                    .font(.title)
                    .foregroundColor(.white)
                Spacer()
            }
            .background(Color.orange)
            ScrollView(.vertical) {
                if viewModel.hasRequest {
                    VStack {
                        HStack {
                            Spacer()
                            Text("Your Request")
                                .font(.largeTitle)
                                .bold()
                                .foregroundColor(.blue)
                            Spacer()
                        }
                        Spacer().frame(height: 30)
                        VStack {
                            Text("Shop Name")
                                .foregroundColor(.black)
                                .underline()
                            Spacer().frame(height: 5)
                            Text(viewModel.shopName!)
                                .font(.title)
                                .bold()
                                .foregroundColor(.red)
                        }
                        Spacer().frame(height: 30)
                        VStack {
                            Text("Inspection Status")
                                .foregroundColor(.black)
                                .underline()
                            Spacer().frame(height: 5)
                            Text(viewModel.inspectionStatus!.getStatus())
                                .font(.title)
                                .bold()
                                .foregroundColor(.red)
                            Text(viewModel.inspectionStatus!.getSubMessage())
                            if viewModel.isRejected {
                                VStack {
                                    //MARK: TODO refactor(create this type modifire)
                                    HStack {
                                        Spacer()
                                        Text("reason for reject")
                                            .bold()
                                            .underline()
                                        Spacer()
                                    }
                                    Spacer().frame(height: 2)
                                    Text(viewModel.rejectReason)
                                }
                                .padding(3)
                                .background(Color.gray)
                                .cornerRadius(10)
                                .padding(10)
                            }
                        }
                        Spacer()
                        Button(action: {
                            viewModel.isShowAlert = true
                        }) {
                            HStack {
                                Spacer()
                                Text(viewModel.inspectionStatus!.getButtonMessage())
                                    .font(.title)
                                    .bold()
                                Spacer()
                            }
                        }
                        .basicStyle(foreColor: .white,
                                    backColor: .blue,
                                    padding: 10,
                                    radius: 15)
                        .padding(10)
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
                        Text(viewModel.annotation)
                            .foregroundColor(.gray)
                            .padding(10)
                    }
                    .background(Color.white)
                    .cornerRadius(10)
                    .padding(20)
                } else {
                    Spacer()
                    Text("You have no request now").foregroundColor(.white)
                    Spacer()
                }
            }
        }
        .background(Color.green)
        .navigationBarHidden(true)
    }
}

