//
//  RequestStatusViewModel.swift
//  RamenShopApp
//
//  Created by Koro Saka on 2021-01-03.
//  Copyright © 2021 Koro Saka. All rights reserved.
//

import Foundation
class RequestStatusViewModel: ObservableObject {
    var db: FirebaseHelper
    var authentication: Authentication
    var userID: String
    @Published var shopName = ""
    
    init(userID: String) {
        db = .init()
        authentication = .init()
        self.userID = userID
    }
}
