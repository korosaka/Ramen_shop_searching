//
//  Review.swift
//  RamenShopApp
//
//  Created by Koro Saka on 2021-02-20.
//  Copyright © 2021 Koro Saka. All rights reserved.
//

import Foundation
struct Review {
    let reviewID: String
    let userID: String
    let evaluation: Int
    let comment: String
    let imageCount: Int
    let createdDate: Date
    
    func displayDate() -> String {
        let dateFormater = DateFormatter()
        dateFormater.dateFormat = "yyyy/MM/dd"
        return dateFormater.string(from: createdDate)
    }
}
