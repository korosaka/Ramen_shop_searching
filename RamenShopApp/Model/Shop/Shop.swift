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
    let id = UUID()
    private let shopID: String
    private let name: String
    private let location: GeoPoint
    private let totalReviewPoint: Int
    private let reviewCount: Int
    private let uploadUser: String
    private let reviewingStatus: ReviewingStatus
    
    init(shopID: String,
         name: String,
         location: GeoPoint,
         totalPoint: Int,
         reviewCount: Int,
         uploadUser: String,
         reviewingStatus: ReviewingStatus) {
        self.shopID = shopID
        self.name = name
        self.location = location
        self.totalReviewPoint = totalPoint
        self.reviewCount = reviewCount
        self.uploadUser = uploadUser
        self.reviewingStatus = reviewingStatus
    }
    
    var aveEvaluation: Float {
        return calcAveEvaluation(totalReviewPoint, reviewCount)
    }
    
    func getShopID() -> String {
        return shopID
    }
    
    func getName() -> String {
        return name
    }
    
    func getLocation() -> GeoPoint {
        return location
    }
    
    func getTotalPoint() -> Int {
        return totalReviewPoint
    }
    
    func getReviewCount() -> Int {
        return reviewCount
    }
    
    func getUploadUser() -> String {
        return uploadUser
    }
    
    func getReviewingStatus() -> ReviewingStatus {
        return reviewingStatus
    }
    
    
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
