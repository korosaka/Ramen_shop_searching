//
//  AllReviewView.swift
//  RamenShopApp
//
//  Created by Koro Saka on 2020-12-03.
//  Copyright © 2020 Koro Saka. All rights reserved.
//

import SwiftUI

struct AllReviewView: View {
    
    @ObservedObject var viewModel: AllReviewViewModel
    
    var body: some View {
        
        ZStack {
            Color.blue
            VStack {
                Text("All Review")
                    .font(.headline)
                    .foregroundColor(.yellow)
                    .padding(5)
                List {
                    ForEach(viewModel.reviews, id: \.reviewID) { review in
                        ReviewHeadline(review: review)
                    }
                }
                .padding(.init(top: 0,
                               leading: 5,
                               bottom: 5,
                               trailing: 5))
            }
        }.onAppear() {
            self.viewModel.fetchAllReview()
        }
        
    }
}
