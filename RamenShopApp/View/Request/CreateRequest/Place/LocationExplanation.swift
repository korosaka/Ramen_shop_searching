//
//  LocationExplanation.swift
//  RamenShopApp
//
//  Created by Koro Saka on 2021-02-26.
//  Copyright © 2021 Koro Saka. All rights reserved.
//

import SwiftUI

struct LocationExplanation: View {
    var body: some View {
        HStack {
            Spacer()
            Text(Constants.LOCATION_EXPLANATION)
                .bold()
                .foregroundColor(.white)
                .padding(10)
            
            Spacer()
        }
        .background(Color.viridianGreen)
        .cornerRadius(20)
        .shadow(color: .black, radius: 3, x: 2, y: 2)
    }
}
