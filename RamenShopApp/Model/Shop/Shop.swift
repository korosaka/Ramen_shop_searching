//
//  Shop.swift
//  RamenShopApp
//
//  Created by Koro Saka on 2021-02-20.
//  Copyright © 2021 Koro Saka. All rights reserved.
//

import Foundation
import FirebaseFirestore
struct Shop {
    let shopID: String
    let name: String
    let location: GeoPoint
    let totalReview: Int
    let reviewCount: Int
    let uploadUser: String
    var aveEvaluation: Float {
        return calcAveEvaluation(totalReview, reviewCount)
    }
    let reviewingStatus: ReviewingStatus
    
    func roundEvaluatione() -> String {
        if aveEvaluation == Float(0.0) {
            return "---"
        }
        return String(format: "%.1f", aveEvaluation)
    }
    
    func calcAveEvaluation(_ totalPoint: Int, _ reviewCount: Int) -> Float {
        if totalPoint == 0 || reviewCount == 0 {
            return Float(0.0)
        }
        return Float(totalPoint) / Float(reviewCount)
    }
}
