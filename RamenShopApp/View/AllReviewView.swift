//
//  AllReviewView.swift
//  RamenShopApp
//
//  Created by Koro Saka on 2020-12-03.
//  Copyright © 2020 Koro Saka. All rights reserved.
//

import SwiftUI

struct AllReviewView: View {
    
    var viewModel: AllReviewViewModel
    
    var body: some View {
        
        ZStack {
            Color.blue
            VStack {
                Text("All Review")
                    .font(.headline)
                    .foregroundColor(.yellow)
                    .padding(5)
                List(0..<viewModel.testData.count) { i in
                    ReviewHeadline(review: viewModel.testData[i])
                }
                .padding(.init(top: 0,
                               leading: 5,
                               bottom: 5,
                               trailing: 5))
            }
        }
        
    }
}
