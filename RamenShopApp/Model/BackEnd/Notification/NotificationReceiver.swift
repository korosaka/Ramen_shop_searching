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
            return Constants.DONE_REVIEWING_REQUEST
        default:
            return Constants.NEW_SHOP_INFO
        }
    }
    
    var body: String {
        switch self {
        case .requester:
            return Constants.DONE_REVIEWING_REQUEST_MESSAGE
        default:
            return Constants.CHECK_IT
        }
    }
}
