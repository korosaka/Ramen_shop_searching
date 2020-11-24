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
    let db: Firestore!
    var shops: [Shop]!
    
    init() {
        db = Firestore.firestore()
        shops = [Shop]()
    }
    
    func getShops() {
        db.collection("shop").getDocuments() { (querySnapshot, err) in
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
                for document in querySnapshot!.documents {
                    let data = document.data()
                    let name = data["name"] as! String
                    let location = data["location"] as! GeoPoint
                    self.shops.append(Shop(name: name,
                                           location: location))
                }
            }
        }
    }
}

struct Shop {
    var name: String
    var location: GeoPoint
}
