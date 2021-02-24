//
//  ReviewStatus.swift
//  RamenShopApp
//
//  Created by Koro Saka on 2021-02-24.
//  Copyright © 2021 Koro Saka. All rights reserved.
//

import SwiftUI

struct ReviewStatus: View {
    @EnvironmentObject var viewModel: RequestStatusViewModel
    var body: some View {
        VStack {
            Text("review status")
                .foregroundColor(.black)
                .underline()
            Spacer().frame(height: 5)
            Text(viewModel.inspectionStatus?.getStatus() ?? Constants.EMPTY).largestTitleStyleWithColor(color: viewModel.inspectionStatus?.getStatusColor() ?? .black)
            Spacer().frame(height: 5)
            Text(viewModel.inspectionStatus?.getSubMessage() ?? Constants.EMPTY).foregroundColor(.gray)
            Spacer().frame(height: 30)
            if viewModel.isRejected {
                RejectReason()
                    .padding(5)
                Spacer().frame(height: 30)
            }
        }
    }
}
