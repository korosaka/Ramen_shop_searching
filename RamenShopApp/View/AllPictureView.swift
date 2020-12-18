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
        VStack {
            Text("All picture")
                .padding()
            Spacer()
            PictureCollectionView(scrollable: true,
                                  ramenImages: viewModel.allImages)
            Spacer()
        }
        .onAppear() {
            self.viewModel.fetchAllImage()
        }
    }
}
