//
//  ShopDB.swift
//  RamenShopApp
//
//  Created by Koro Saka on 2020-11-23.
//  Copyright © 2020 Koro Saka. All rights reserved.
//

import Firebase
import FirebaseFirestore

class CloudFirestore {
    let db: Firestore
    var shops: [Shop]
    
    weak var delegate: CloudFirestoreDelegate?
    
    init() {
        db = Firestore.firestore()
        shops = [Shop]()
    }
    
    func getShops() {
        db.collection("shop").getDocuments() { (querySnapshot, err) in
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
                self.shops.removeAll()
                for document in querySnapshot!.documents {
                    let data = document.data()
                    let name = data["name"] as? String ?? ""
                    let location = data["location"] as! GeoPoint
                    let reviewInfo = data["review_info"] as! [String: Any]
                    self.shops.append(Shop(shopID: document.documentID,
                                           name: name,
                                           location: location,
                                           aveEvaluation: self.calcAveEvaluation(reviewInfo)))
                }
                self.delegate?.completedGettingShop()
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
    func completedGettingShop()
}

struct Shop {
    let shopID: String
    let name: String
    let location: GeoPoint
    let aveEvaluation: Float
}
