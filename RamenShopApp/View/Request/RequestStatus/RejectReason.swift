//
//  RejectReason.swift
//  RamenShopApp
//
//  Created by Koro Saka on 2021-02-24.
//  Copyright © 2021 Koro Saka. All rights reserved.
//

import SwiftUI

struct RejectReason: View {
    @EnvironmentObject var viewModel: RequestStatusViewModel
    var body: some View {
        VStack {
            Text(Constants.REJECT_REASON)
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
