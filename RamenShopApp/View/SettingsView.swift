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
        VStack {
            if let url = URL(string: "https://korosaka.github.io/privacy_policy_for_RamenMap/") {
                HStack {
                    Spacer()
                    Link("Privacy Policy", destination: url)
                    Spacer()
                }
                .upDownPadding(size: 30)
                .background(Color.white)
                .cornerRadius(20)
                .sidePadding(size: 30)
                .upDownPadding(size: 50)
            }
            Spacer()
        }
        .background(Color.gray)
    }
}
