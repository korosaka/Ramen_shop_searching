//
//  EvaluationLabel.swift
//  RamenShopApp
//
//  Created by Koro Saka on 2021-02-24.
//  Copyright © 2021 Koro Saka. All rights reserved.
//

import SwiftUI

struct EvaluationLabel: View {
    @ObservedObject var viewModel: ShopDetailViewModel
    
    var body: some View {
        ZStack(alignment: .trailing) {
            HStack {
                Image(systemName: "star.fill")
                    .foregroundColor(.gold)
                    .font(.title)
                    .shadow(color: .black, radius: 1)
                Text(viewModel.shop?.roundEvaluatione() ?? String(Constants.EMPTY))
                    .foregroundColor(.gold).bold()
                    .font(.largeTitle)
                    .shadow(color: .black, radius: 1)
            }
            .wideStyle()
            
            OptionIcons(viewModel: viewModel)
        }
    }
}
