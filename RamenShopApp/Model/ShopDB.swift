//
//  ShopDB.swift
//  RamenShopApp
//
//  Created by Koro Saka on 2020-11-23.
//  Copyright © 2020 Koro Saka. All rights reserved.
//

import Firebase
import FirebaseFirestore

// MARK: this class name should be changed,,,,?
struct CloudFirestore {
    let db: Firestore
    
    weak var delegate: CloudFirestoreDelegate?
    
    init() {
        db = Firestore.firestore()
    }
    
    func fetchShops() {
        var shops = [Shop]()
        db.collection("shop").getDocuments() { (querySnapshot, err) in
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
                for document in querySnapshot!.documents {
                    let data = document.data()
                    let name = data["name"] as? String ?? ""
                    let location = data["location"] as! GeoPoint
                    let reviewInfo = data["review_info"] as! [String: Any]
                    shops.append(Shop(shopID: document.documentID,
                                      name: name,
                                      location: location,
                                      aveEvaluation: self.calcAveEvaluation(reviewInfo)))
                }
                self.delegate?.completedFetchingShop(shops: shops)
            }
        }
    }
    
    func fetchLatestReviews(shopID: String) {
        // MARK: to judge to show "more" in LatestReviews in ShopDetailView (only 2reviews will be shown in ShopDetail)
        let numOfReview = 3
        var reviews = [Review]()
        
        let reviewRef =
            db.collection("shop")
            .document(shopID)
            .collection("review")
        reviewRef.order(by: "created_at", descending: true).limit(to: numOfReview).getDocuments() { (querySnapshot, err) in
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
                for document in querySnapshot!.documents {
                    let data = document.data()
                    let images = data["picture"] as? [String] ?? [String]()
                    let review = Review(reviewID: document.documentID,
                                        userID: data["user_id"] as? String ?? "",
                                        evaluation: data["evaluation"] as? Int ?? 0,
                                        comment: data["comment"] as? String ?? "",
                                        imageCount: images.count)
                    reviews.append(review)
                }
                self.delegate?.completedFetchingLatestReviews(reviews: reviews)
            }
        }
    }
    
    func calcAveEvaluation(_ reviewInfo: [String: Any]) -> Float {
        let totalEvaluation = reviewInfo["total_point"] as? Int ?? 0
        let reviewCount = reviewInfo["count"] as? Int ?? 0
        
        if totalEvaluation == 0 || reviewCount == 0 {
            return Float(0.0)
        }
        return Float(totalEvaluation) / Float(reviewCount)
    }
}

protocol CloudFirestoreDelegate: class {
    func completedFetchingShop(shops: [Shop])
    func completedFetchingLatestReviews(reviews: [Review])
}

extension CloudFirestoreDelegate {
    func completedFetchingShop(shops: [Shop]) {
        print("default implemented completedGettingShop")
    }
    func completedFetchingLatestReviews(reviews: [Review]) {
        print("default implemented completedGettingLatestReviews")
    }
}

struct Shop {
    let shopID: String
    let name: String
    let location: GeoPoint
    let aveEvaluation: Float
    
    func roundEvaluatione() -> String {
        if aveEvaluation == Float(0.0) {
            return "---"
        }
        return String(format: "%.1f", aveEvaluation)
    }
}

struct Review {
    let reviewID: String
    let userID: String
    let evaluation: Int
    let comment: String
    let imageCount: Int
}
