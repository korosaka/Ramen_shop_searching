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
                if let url = URL(string: Constants.POLICY_URL) {
                    HStack {
                        Spacer()
                        Link(Constants.POLICY, destination: url)
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

//MARK: TODO It looks like the bug(#15) has been fixed,,,,
struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView()
    }
}
