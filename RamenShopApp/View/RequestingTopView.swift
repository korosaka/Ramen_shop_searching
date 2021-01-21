//
//  RequestingTopView.swift
//  RamenShopApp
//
//  Created by Koro Saka on 2021-01-07.
//  Copyright © 2021 Koro Saka. All rights reserved.
//

import SwiftUI

struct RequestingTopView: View {
    @ObservedObject var viewModel: RequestingTopViewModel
    var body: some View {
        //MARK: without VStack, crash will happen (see issue#43 for detail)
        VStack {
            if viewModel.hasRequest {
                RequestStatusView(viewModel: .init(viewModel.userID!,
                                                   viewModel.requestedShopID!,
                                                   delegate: viewModel))
            } else {
                RegisteringShopNameView(viewModel: .init(delegate: viewModel))
            }
        }
    }
}
