//
//  SettingView.swift
//  RamenShopApp
//
//  Created by Koro Saka on 2021-01-24.
//  Copyright © 2021 Koro Saka. All rights reserved.
//

import SwiftUI

struct SettingsView: View {
    var body: some View {
        ZStack {
            BackGroundView()
            VStack {
                Spacer().frame(height: 15)
                if let url = URL(string: "https://korosaka.github.io/privacy_policy_for_RamenMap/") {
                    HStack {
                        Spacer()
                        Link("Privacy Policy", destination: url)
                        Spacer()
                    }
                    .upDownPadding(size: 10)
                    .background(Color.superWhitePasteGreen)
                    .cornerRadius(20)
                    .sidePadding(size: 50)
                }
                Spacer()
            }
        }
    }
}
