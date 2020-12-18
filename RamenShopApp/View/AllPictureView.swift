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
        Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
            .onAppear() {
                self.viewModel.fetchAllImage()
            }
    }
}
