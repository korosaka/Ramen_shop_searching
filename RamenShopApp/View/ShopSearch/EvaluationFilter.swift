//
//  EvaluationFilter.swift
//  RamenShopApp
//
//  Created by Koro Saka on 2021-02-24.
//  Copyright © 2021 Koro Saka. All rights reserved.
//

import SwiftUI

struct EvaluationFilter: View {
    @ObservedObject var viewModel: ShopsMapViewModel
    
    var body: some View {
        VStack(spacing: 0) {
            Text("evaluation filter")
                .foregroundColor(.viridianGreen)
                .shadow(color: .black, radius: 0.5, x: 0.5, y: 0.5)
            Picker(selection: $viewModel.evaluationFilter, label: Text("EvaFilter"), content: {
                Text("---").tag(-1)
                ForEach(0..<viewModel.filterValues.count, id: \.self) { index in
                    Text(String(viewModel.filterValues[index])).tag(index)
                }
            })
            .pickerStyle(SegmentedPickerStyle())
        }
    }
}
