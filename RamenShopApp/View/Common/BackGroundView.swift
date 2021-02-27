//
//  BackGroundView.swift
//  RamenShopApp
//
//  Created by Koro Saka on 2021-02-24.
//  Copyright © 2021 Koro Saka. All rights reserved.
//

import SwiftUI

struct BackGroundView: View {
    var body: some View {
        LinearGradient(gradient: Gradient(colors: [Color.green,
                                                   Color.pastelGreen]),
                       startPoint: .top,
                       endPoint: .bottom)
    }
}
