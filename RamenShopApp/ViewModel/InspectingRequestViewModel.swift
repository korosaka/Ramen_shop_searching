//
//  InspectingRequestViewModel.swift
//  RamenShopApp
//
//  Created by Koro Saka on 2021-01-13.
//  Copyright © 2021 Koro Saka. All rights reserved.
//

import Foundation
class InspectingRequestViewModel: ObservableObject {
    let requestedShop: Shop
    
    init(request: Shop) {
        requestedShop = request
    }
}
