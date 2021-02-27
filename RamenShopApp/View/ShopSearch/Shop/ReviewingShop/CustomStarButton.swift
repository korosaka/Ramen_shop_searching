//
//  CustomStarButton.swift
//  RamenShopApp
//
//  Created by Koro Saka on 2021-02-25.
//  Copyright © 2021 Koro Saka. All rights reserved.
//

import SwiftUI

struct CustomStarButton: View {
    let starNumber: Int
    @EnvironmentObject var viewModel: ReviewingViewModel
    var body: some View {
        HStack {
            Spacer()
            Button(action: {
                viewModel.setEvaluation(num: starNumber)
            }) {
                viewModel.getStarImage(num: starNumber)
                    .font(.largeTitle)
                    .foregroundColor(.gold)
                    .shadow(color: .black, radius: 1.5)
            }
            Spacer()
        }
    }
}
