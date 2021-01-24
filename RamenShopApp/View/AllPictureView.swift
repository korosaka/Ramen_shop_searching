//
//  AllPictureView.swift
//  RamenShopApp
//
//  Created by Koro Saka on 2020-12-17.
//  Copyright © 2020 Koro Saka. All rights reserved.
//

import SwiftUI

struct AllPictureView: View {
    
    @ObservedObject var viewModel: AllPictureViewModel
    
    var body: some View {
        ZStack {
            VStack(spacing: 0) {
                CustomNavigationBar(additionalAction: nil)
                Text("All picture")
                    .font(.title)
                    .foregroundColor(.red)
                    .padding(5)
                Spacer()
                PictureCollectionView(scrollable: true,
                                      ramenImages: viewModel.allImages)
                    .sidePadding(size: 5)
                Spacer()
            }
            if viewModel.isShowingProgress {
                CustomedProgress()
            }
        }
        .navigationBarHidden(true)
        .onAppear() {
            viewModel.fetchAllImage()
        }
    }
}
