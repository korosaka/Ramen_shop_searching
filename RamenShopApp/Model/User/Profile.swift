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
    private var userName: String
    private var icon: UIImage?
    
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
    
    func getUserName() -> String {
        return userName
    }
    
    func getIcon() -> UIImage? {
        return icon
    }
}
