//
//  NotificationReceiver.swift
//  RamenShopApp
//
//  Created by Koro Saka on 2021-02-20.
//  Copyright © 2021 Koro Saka. All rights reserved.
//

import Foundation
enum NotificationReceiver: String {
    case requester = "requester"
    case allUser = "all_user"
    
    var title: String {
        switch self {
        case .requester:
            return "Reviewing has been done!"
        default:
            return "New shop has been registered near you!"
        }
    }
    
    var body: String {
        switch self {
        case .requester:
            return "Your adding shop request has been reviewed. Please check it in app."
        default:
            return "Let's check it!"
        }
    }
}
