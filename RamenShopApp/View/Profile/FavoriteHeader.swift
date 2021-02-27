//
//  FavoriteHeader.swift
//  RamenShopApp
//
//  Created by Koro Saka on 2021-02-24.
//  Copyright © 2021 Koro Saka. All rights reserved.
//

import SwiftUI

struct FavoriteHeader: View {
    @EnvironmentObject var viewModel: ProfileViewModel
    
    var body: some View {
        Image(systemName: "heart.fill")
            .font(.title)
            .foregroundColor(.strongPink)
            .upDownPadding(size: 5)
            .wideStyle().background(Color.superWhitePasteGreen)
            .shadow(color: .black, radius: 1)
    }
    
}
