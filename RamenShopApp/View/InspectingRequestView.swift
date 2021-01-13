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
    var body: some View {
        Text(viewModel.requestedShop.name)
    }
}
