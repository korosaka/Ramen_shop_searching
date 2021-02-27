//
//  RegisteringToken.swift
//  RamenShopApp
//
//  Created by Koro Saka on 2021-01-15.
//  Copyright © 2021 Koro Saka. All rights reserved.
//

import Foundation
import Firebase
class RegisteringToken {
    func registerTokenToUser(to userID: String) {
        Messaging.messaging().token { token, error in
            if let error = error {
                print("Error fetching FCM registration token: \(error)")
            } else if let _token = token {
                print("FCM registration token: \(_token)")
                DatabaseHelper().registerTokenToUser(token: _token, to: userID)
            }
        }
    }
}
