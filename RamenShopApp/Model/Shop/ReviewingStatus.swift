//
//  ReviewingStatus.swift
//  RamenShopApp
//
//  Created by Koro Saka on 2021-02-20.
//  Copyright © 2021 Koro Saka. All rights reserved.
//

import Foundation
import SwiftUI
enum ReviewingStatus: Int {
    case inProcess = 0
    case approved = 1
    case rejected = -1
    func getStatus() -> String {
        switch self {
        case .inProcess:
            return "In process"
        case .approved:
            return "Approved!"
        default:
            return "Rejected!"
        }
    }
    
    func getStatusColor() -> Color {
        switch self {
        case .inProcess:
            return .gold
        case .approved:
            return .seaBlue
        default:
            return .strongRed
        }
    }
    
    func getSubMessage() -> String {
        switch self {
        case .inProcess:
            return "This will be done within a few days."
        case .approved:
            return "This shop has been added to this app!"
        default:
            return "Your request has been rejected."
        }
    }
    
    func getButtonMessage() -> String {
        switch self {
        case .inProcess:
            return "cancel this request"
        default:
            return "I've checked it"
        }
    }
    
    func getConfirmationMessage() -> String {
        switch self {
        case .inProcess:
            return "Are you sure to cancel this request?"
        default:
            return "Have you really checked this info?"
        }
    }
}
