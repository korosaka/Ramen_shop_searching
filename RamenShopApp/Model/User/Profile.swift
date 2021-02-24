//
//  Profile.swift
//  RamenShopApp
//
//  Created by Koro Saka on 2021-02-20.
//  Copyright © 2021 Koro Saka. All rights reserved.
//

import Foundation
import Firebase

struct Profile {
    var userName: String
    var icon: UIImage?
    
    init() {
        userName = Constants.NO_NAME
        icon = nil
    }
    
    init(userName: String) {
        self.userName = userName
        icon = nil
    }
    
    init(userName: String, icon: UIImage?) {
        self.userName = userName
        self.icon = icon
    }
}
