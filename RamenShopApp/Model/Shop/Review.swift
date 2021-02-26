//
//  Review.swift
//  RamenShopApp
//
//  Created by Koro Saka on 2021-02-20.
//  Copyright © 2021 Koro Saka. All rights reserved.
//

import Foundation
struct Review {
    let id = UUID()
    private let reviewID: String
    private let userID: String
    private let evaluation: Int
    private let comment: String
    private let imageCount: Int
    private let createdDate: Date
    
    init(reviewID: String,
         userID: String,
         evaluation: Int,
         comment: String,
         imageCount: Int,
         createdDate: Date) {
        self.reviewID = reviewID
        self.userID = userID
        self.evaluation = evaluation
        self.comment = comment
        self.imageCount = imageCount
        self.createdDate = createdDate
    }
    
    func getReviewID() -> String {
        return reviewID
    }
    
    func getUserID() -> String {
        return userID
    }
    
    func getEvaluation() -> Int {
        return evaluation
    }
    
    func getComment() -> String {
        return comment
    }
    
    func getImageCount() -> Int {
        return imageCount
    }
    
    func getCreatedDate() -> Date {
        return createdDate
    }
    
    func displayDate() -> String {
        let dateFormater = DateFormatter()
        dateFormater.dateFormat = "yyyy/MM/dd"
        return dateFormater.string(from: createdDate)
    }
}
