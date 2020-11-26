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
                    let name = data["name"] as! String
                    let location = data["location"] as! GeoPoint
                    self.shops.append(Shop(shopID: document.documentID,
                                           name: name,
                                           location: location))
                }
                self.delegate?.completedGettingShop()
            }
        }
    }
}

protocol CloudFirestoreDelegate: class {
    func completedGettingShop()
}

struct Shop {
    let shopID: String
    let name: String
    let location: GeoPoint
}
