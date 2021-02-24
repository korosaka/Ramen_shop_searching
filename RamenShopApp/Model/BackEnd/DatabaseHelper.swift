//
//  ShopDB.swift
//  RamenShopApp
//
//  Created by Koro Saka on 2020-11-23.
//  Copyright © 2020 Koro Saka. All rights reserved.
//

import Firebase
import FirebaseFirestore
import GoogleMaps
import CoreLocation

struct DatabaseHelper {
    let firestore: Firestore
    let storage: Storage
    
    weak var delegate: FirebaseHelperDelegate?
    
    init() {
        firestore = Firestore.firestore()
        storage = Storage.storage()
    }
    
    func fetchShops(target: ReviewingStatus) {
        var shops = [Shop]()
        createShopsRef(target).getDocuments() { (querySnapshot, err) in
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
                for document in querySnapshot!.documents {
                    let shop = extractShop(shopID: document.documentID,
                                           shopData: document.data())
                    shops.append(shop)
                }
                self.delegate?.completedFetchingShops(shops: shops)
            }
        }
    }
    
    func extractShop(shopID: String, shopData: [String : Any]) -> Shop {
        let name = shopData["name"] as? String ?? Constants.EMPTY
        let location = shopData["location"] as! GeoPoint
        let reviewInfo = shopData["review_info"] as! [String: Any]
        let totalPoint = reviewInfo["total_point"] as? Int ?? 0
        let count = reviewInfo["count"] as? Int ?? 0
        let userID = shopData["upload_user"] as? String ?? Constants.EMPTY
        let inspectionStatus = shopData["inspection_status"] as? Int ?? -1
        
        return Shop(shopID: shopID,
                    name: name,
                    location: location,
                    totalReview: totalPoint,
                    reviewCount: count,
                    uploadUser: userID,
                    reviewingStatus: ReviewingStatus(rawValue: inspectionStatus)!)
    }
    
    func createShopsRef(_ target: ReviewingStatus) -> Query {
        firestore
            .collection("shop")
            .whereField("inspection_status", isEqualTo: target.rawValue)
    }
    
    func fetchLatestReviews(shopID: String) {
        // MARK: to judge to show "more" in LatestReviews in ShopDetailView (only 2reviews will be shown in ShopDetail)
        let numOfReview = 3
        fetchShopReviews(shopID: shopID, limitNum: numOfReview)
    }
    
    func fetchAllReview(shopID: String) {
        fetchShopReviews(shopID: shopID, limitNum: nil)
    }
    
    func fetchShopReviews(shopID: String, limitNum: Int?) {
        let reviewRef = createReviewRef(shopID: shopID)
        
        let completionHandler = { (querySnapshot: QuerySnapshot?, err: Error?) in
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
                let reviews = extractReviews(reviewQuery: querySnapshot!)
                self.delegate?.completedFetchingReviews(reviews: reviews)
            }
        }
        
        if limitNum != nil {
            reviewRef
                .order(by: "created_at", descending: true)
                .limit(to: limitNum!)
                .getDocuments(completion: completionHandler)
        } else {
            reviewRef
                .order(by: "created_at", descending: true)
                .getDocuments(completion: completionHandler)
        }
    }
    
    func fetchUserReview(shopID: String, userID: String) {
        let userReviewRef = createReviewRef(shopID: shopID)
            .whereField("user_id", isEqualTo: userID)
        
        userReviewRef.getDocuments { (querySnapshot, error) in
            if error != nil {
                return print("error happened in fetchUserReview !!")
            }
            for doc in querySnapshot!.documents {
                delegate?.completedFetchingUserReview(reviewID: doc.documentID,
                                                      imageCount: doc.data()["image_number"] as? Int ?? 0,
                                                      evaluation: doc.data()["evaluation"] as? Int ?? nil)
                return
            }
        }
    }
    
    func createReviewRef(shopID: String) -> CollectionReference {
        return firestore.collection("shop")
            .document(shopID)
            .collection("review")
    }
    
    func extractReviews(reviewQuery: QuerySnapshot) -> [Review] {
        var reviews = [Review]()
        for document in reviewQuery.documents {
            let data = document.data()
            let createdTimestamp = data["created_at"] as? Timestamp
            let review = Review(reviewID: document.documentID,
                                userID: data["user_id"] as? String ?? Constants.EMPTY,
                                evaluation: data["evaluation"] as? Int ?? 0,
                                comment: data["comment"] as? String ?? Constants.EMPTY,
                                imageCount: data["image_number"] as? Int ?? 0,
                                createdDate: createdTimestamp!.dateValue())
            reviews.append(review)
        }
        return reviews
    }
    
    func fetchUserProfile(userID: String) {
        let userRef = firestore.collection("user")
            .document(userID)
        
        userRef.getDocument { (document, error) in
            if error != nil {
                return print("error happened in fetchUserProfile !!")
            }
            if let data = document?.data() {
                let userName = data["user_name"] as? String ?? "unnamed"
                let profile = Profile(userName: userName, icon: nil)
                if data["has_icon"] as? Bool ?? false {
                    fetchUserIcon(userID, profile)
                } else {
                    delegate?.completedFetchingProfile(profile: profile)
                }
            } else {
                delegate?.completedFetchingProfile(profile: nil)
                return
            }
        }
    }
    
    fileprivate func fetchUserIcon(_ userID: String, _ profile: Profile) {
        createUserIconRef(userID).getData(maxSize: 1 * 1024 * 1024) { data, error in
            // MARK: asynchronous
            if let error = error {
                print("Error getting data: \(error)")
                delegate?.completedFetchingProfile(profile: profile)
            } else {
                let iconProfile = Profile(userName: profile.userName,
                                          icon: UIImage(data: data!))
                delegate?.completedFetchingProfile(profile: iconProfile)
            }
        }
    }
    
    func uploadUserProfile(_ userID: String) {
        let userRef = firestore
            .collection("user")
            .document(userID)
        userRef.setData([
            "user_name": "unnamed",
            "has_icon" : false
        ]) { err in
            delegate?.completedUpdatingUserProfile(isSuccess: err == nil)
        }
    }
    
    func updateUserIcon(_ userID: String, _ iconImage: UIImage, _ hasProfileAlready: Bool) {
        guard let data: Data = iconImage.jpegData(compressionQuality: 0.1) else { return }
        createUserIconRef(userID).putData(data, metadata: nil) { (metadata, error) in
            if error != nil {
                delegate?.completedUpdatingUserProfile(isSuccess: false)
                return
            }
            updateUserIconInfo(userID, hasProfileAlready)
        }
    }
    
    func createUserIconRef(_ userID: String) -> StorageReference {
        return storage.reference().child("user_icon/\(userID)/icon_image.jpeg")
    }
    
    func updateUserIconInfo(_ userID: String, _ hasProfileAlready: Bool) {
        let userRef = firestore.collection("user")
            .document(userID)
        if hasProfileAlready {
            userRef.updateData([
                "has_icon": true
            ]) { err in
                delegate?.completedUpdatingUserProfile(isSuccess: err == nil)
            }
        } else {
            userRef.setData([
                "user_name": "unnamed",
                "has_icon" : true
            ]) { err in
                delegate?.completedUpdatingUserProfile(isSuccess: err == nil)
            }
        }
    }
    
    func updateUserName(userID: String, name: String, _ hasProfileAlready: Bool) {
        let userRef = firestore.collection("user")
            .document(userID)
        
        if hasProfileAlready {
            userRef.updateData([
                "user_name": name
            ]) { err in
                delegate?.completedUpdatingUserProfile(isSuccess: (err == nil))
            }
        } else {
            userRef.setData([
                "user_name": name,
                "has_icon" : false
            ]) { err in
                delegate?.completedUpdatingUserProfile(isSuccess: (err == nil))
            }
        }
    }
    
    func fetchPictureReviews(shopID: String, limit: Int?) {
        // MARK: TODO use createReviewRef(shopID: String)
        let reviewStoreRef =
            firestore.collection("shop")
            .document(shopID)
            .collection("review")
        var pictureReviewRef = reviewStoreRef.whereField("image_number", isGreaterThan: 0)
        // MARK: TODO .order(by: "created_at", descending: true)
        // let test = pictureReviewRef.order(by: "created_at", descending: true)
        if let _limit = limit {
            pictureReviewRef = pictureReviewRef.limit(to: _limit)
        }
        pictureReviewRef.getDocuments() { (querySnapshot, err) in
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
                self.fetchImageFromReviewDocs(imageReviewsQS: querySnapshot!, shopID)
            }
        }
    }
    
    // MARK: to get images of a shop (used for ShopDetail)
    func fetchImageFromReviewDocs(imageReviewsQS: QuerySnapshot, _ shopID: String) {
        var totalPictures = [UIImage]()
        let totalImageReviewCount = imageReviewsQS.documents.count
        if totalImageReviewCount == 0 {
            self.delegate?.completedFetchingPictures(pictures: totalPictures,
                                                     shopID: shopID)
        }
        var readImageReviewCount = 0
        
        let completionHandler = { (pictures: [UIImage]) -> Void in
            totalPictures += pictures
            readImageReviewCount += 1
            // MARK: completed getting images of every review?
            if readImageReviewCount == totalImageReviewCount {
                self.delegate?.completedFetchingPictures(pictures: totalPictures,
                                                         shopID: shopID)
            }
        }
        
        for reviewDoc in imageReviewsQS.documents {
            fetchReviewImage(id: reviewDoc.documentID, completion: completionHandler)
        }
    }
    
    // MARK: to get images of a review (used for ReviewDetail)
    func fetchImageFromReview(review: Review) {
        let completionHandler = { (pictures: [UIImage]) -> Void in
            self.delegate?.completedFetchingPictures(pictures: pictures,
                                                     shopID: nil)
        }
        fetchReviewImage(id: review.reviewID, completion: completionHandler)
    }
    
    private func fetchReviewImage(id reviewID: String, completion: @escaping ([UIImage]) -> Void) {
        var reviewImages = [UIImage]()
        let reviewStorageRef = storage.reference().child("review_picture/\(reviewID)")
        reviewStorageRef.listAll { (result, error) in
            // MARK: asynchronous
            if let error = error {
                print("Error getting data: \(error)")
            }
            let totalImageCount = result.items.count
            var readImageCount = 0
            for item in result.items {
                item.getData(maxSize: 1 * 1024 * 1024) { data, error in
                    // MARK: asynchronous
                    if let error = error {
                        print("Error getting data: \(error)")
                    } else {
                        let image = UIImage(data: data!)
                        reviewImages.append(image!)
                    }
                    readImageCount += 1
                    // MARK: completed getting images of 1 review?
                    if readImageCount == totalImageCount {
                        completion(reviewImages)
                    }
                }
            }
        }
    }
    
    /**
     if there have been files which name is same already, putData() will overwrite the file.
     This is because these old files don't have to be deleted except when old pictures' count is learger than new pictures' one
     */
    func updateReviewPics(pics: [UIImage],
                          reviewID: String,
                          prePicCount: Int) {
        uploadReviewPics(pics, reviewID)
        deletePreviousReviewPics(pics.count, prePicCount, reviewID)
    }
    
    fileprivate func uploadReviewPics(_ pics: [UIImage],
                                      _ reviewID: String) {
        if pics.count == 0 {
            delegate?.completedUploadingReviewPics()
            return
        }
        
        var uploadCount = 0
        for picIndex in 0..<pics.count {
            guard let data: Data = pics[picIndex].jpegData(compressionQuality: 0.1) else { continue }
            createReviewPicRef(reviewID, picIndex)
                .putData(data, metadata: nil) { (metadata, error) in
                    if let _error = error {
                        print("Error uploadPictures: \(_error)")
                    }
                    uploadCount += 1
                    if uploadCount == pics.count {
                        delegate?.completedUploadingReviewPics()
                    }
                }
        }
    }
    
    fileprivate func deletePreviousReviewPics(_ newPicCount: Int,
                                              _ prePicCount: Int,
                                              _ reviewID: String) {
        if newPicCount >= prePicCount {
            delegate?.completedDeletingReviewPics()
            return
        }
        
        var deleteCount = 0
        let countToDelete = prePicCount - newPicCount
        for picIndex in newPicCount..<prePicCount {
            createReviewPicRef(reviewID, picIndex)
                .delete { error in
                    if let error = error {
                        print("Error on deleting: \(error)")
                    }
                    deleteCount += 1
                    if deleteCount == countToDelete {
                        delegate?.completedDeletingReviewPics()
                    }
                }
        }
    }
    
    fileprivate func createReviewPicRef(_ reviewID: String, _ index: Int) -> StorageReference {
        return storage.reference().child("review_picture/\(reviewID)/review_image_\(index).jpeg")
    }
    
    /**
     setData() will overwrite self previous review contents when it exists.
     when it doesn't, it will create a new document
     */
    func updateReview(shopID: String, review: Review) {
        let timeStamp: Timestamp = .init(date: review.createdDate)
        // MARK: TODO use createReviewRef(shopID: String)?
        let reviewRef = firestore
            .collection("shop")
            .document(shopID)
            .collection("review")
            .document(review.reviewID)
        reviewRef.setData([
            "user_id": review.userID,
            "evaluation": review.evaluation,
            "comment": review.comment,
            "image_number": review.imageCount,
            "created_at": timeStamp
        ]) { err in
            //MARK: without network, this call back never happen, but data is changed only on local db,,,,,,,
            delegate?.completedUpdatingReview(isSuccess: (err == nil))
        }
    }
    
    func updateShopEvaluation(shopID: String, newEva: Int, preEva: Int?, totalPoint: Int, reviewCount: Int) {
        let isFirstReview = preEva == nil
        let pulsEvaForTotal = isFirstReview ? newEva : (newEva - preEva!)
        let newTotalPoint = totalPoint + pulsEvaForTotal
        let newReviewCount = isFirstReview ? (reviewCount + 1) : reviewCount
        
        let shopRef = firestore.collection("shop").document(shopID)
        shopRef.updateData([
            "review_info": [ "total_point": newTotalPoint,
                             "count": newReviewCount ]
        ]) { err in
            if let err = err {
                print("Error updating document: \(err)")
            }
            delegate?.completedUpdatingShopEvaluation()
        }
    }
    
    func updateUserLocation(userID: String, location: CLLocationCoordinate2D) {
        let userRef = firestore.collection("user").document(userID)
        let geoPoint = GeoPoint(latitude: location.latitude,
                                longitude: location.longitude)
        
        userRef.updateData([
            "last_location": geoPoint
        ]) { err in
            if let err = err {
                print("Error updating document: \(err)")
            }
        }
    }
    
    func fetchNearUsers(shopLocation: GeoPoint, requesterID: String) {
        var tokens = [String]()
        firestore.collection("user").getDocuments() { (querySnapshot, err) in
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
                for doc in querySnapshot!.documents {
                    if doc.documentID == requesterID { continue }
                    guard let userLocation = doc.data()["last_location"] as? GeoPoint else { continue }
                    
                    if isNearUser(shopLocation, userLocation) {
                        guard let token = doc.data()["fcm_token"] as? String else { continue }
                        tokens.append(token)
                    }
                }
                delegate?.completedFetchingNearUsers(tokens: tokens)
            }
        }
    }
    
    func isNearUser(_ shopLocation: GeoPoint, _ userLocation: GeoPoint) -> Bool {
        let p1 = CLLocation(latitude: shopLocation.latitude,
                            longitude:shopLocation.longitude)
        let p2 = CLLocation(latitude: userLocation.latitude,
                            longitude:userLocation.longitude)
        //MARK: unit: meters
        let distance = p1.distance(from: p2)
        let limitDistance = 10000.0
        return distance < limitDistance
    }
    
    func fetchShop(shopID: String) {
        let shopRef = firestore.collection("shop").document(shopID)
        shopRef.getDocument { (document, error) in
            if let _error = error {
                print("Error happen :\(_error)")
                return
            }
            guard let shopData = document?.data() else { return }
            let shop = extractShop(shopID: shopID, shopData: shopData)
            delegate?.completedFetchingShop(fetchedShopData: shop)
        }
    }
    
    func fetchRejectReason(shopID: String) {
        let shopRef = firestore.collection("shop").document(shopID)
        shopRef.getDocument { (document, error) in
            if let _error = error {
                print("Error happen :\(_error)")
                return
            }
            guard let shopData = document?.data(),
                  let rejectReason = shopData["reject_reason"] as? String
            else { return }
            delegate?.completedFetchingRejectReason(reason: rejectReason)
        }
    }
    
    func deleteShopRequest(shopID: String) {
        let shopRef = firestore.collection("shop").document(shopID)
        shopRef.delete() { err in
            delegate?.completedDeletingingShopRequest(isSuccess: err == nil)
        }
    }
    
    func uploadShopRequest(shopName: String, location: GeoPoint, userID: String) {
        let shopID = UUID().uuidString
        let shopRef = firestore.collection("shop").document(shopID)
        shopRef.setData([
            "name": shopName,
            "location": location,
            "review_info": [ "total_point": 0,
                             "count": 0 ],
            "inspection_status": 0,
            "reject_reason": Constants.EMPTY,
            "upload_user": userID
        ]) { err in
            if err != nil {
                delegate?.completedUplodingShopRequest(isSuccess: false)
                return
            }
            //MARK: TODO separate this function
            uploadRequestUserInfo(shopID, userID)
        }
    }
    
    func approveRequest(_ shopID: String) {
        let shopRef = firestore.collection("shop").document(shopID)
        shopRef.updateData([
            "inspection_status": ReviewingStatus.approved.rawValue
        ]) { err in
            delegate?.completedUpdatingRequestStatus(isSuccess: err == nil, status: .approved)
        }
    }
    
    func rejectRequest(_ shopID: String, reason: String) {
        let shopRef = firestore.collection("shop").document(shopID)
        shopRef.updateData([
            "inspection_status": ReviewingStatus.rejected.rawValue,
            "reject_reason": reason
        ]) { err in
            delegate?.completedUpdatingRequestStatus(isSuccess: err == nil, status: .rejected)
        }
    }
    
    func uploadRequestUserInfo(_ shopID: String, _ userID: String) {
        let userRef = firestore.collection("user").document(userID)
        userRef.updateData([
            "request_shop": shopID
        ]) { err in
            delegate?.completedUplodingShopRequest(isSuccess: err == nil)
        }
    }
    
    func deleteRequestUserInfo(userID: String) {
        let userRef = firestore.collection("user").document(userID)
        userRef.updateData([
            "request_shop": FieldValue.delete(),
        ]) { err in
            delegate?.completedDeletingRequestUserInfo(isSuccess: err == nil)
        }
    }
    
    func fetchRequestedShopID(userID: String) {
        let userRef = firestore.collection("user").document(userID)
        userRef.getDocument { (document, error) in
            if let _error = error {
                print("Error happen :\(_error)")
                delegate?.completedFetchingRequestedShopID(shopID: nil)
                return
            }
            guard let userData = document?.data(),
                  let requestedShopID = userData["request_shop"] as? String
            else {
                delegate?.completedFetchingRequestedShopID(shopID: nil)
                return
            }
            delegate?.completedFetchingRequestedShopID(shopID: requestedShopID)
        }
    }
    
    func registerTokenToUser(token: String, to userID: String) {
        let userRef = firestore.collection("user").document(userID)
        userRef.updateData([
            "fcm_token": token
        ]) { err in
            delegate?.completedRegisteringToken(isSuccess: err == nil)
        }
    }
    
    func fetchUserToken(of userID: String) {
        let userRef = firestore.collection("user").document(userID)
        userRef.getDocument { (document, error) in
            if let _error = error {
                print("Error happen :\(_error)")
                return
            }
            guard let userData = document?.data(),
                  let token = userData["fcm_token"] as? String
            else { return }
            
            delegate?.completedFetchingToken(token: token)
        }
    }
    
    func fetchFavoriteFlag(_ userID: String, _ shopID: String) {
        let userRef = firestore.collection("user").document(userID)
        userRef.getDocument { (document, error) in
            if let _error = error {
                print("Error happen :\(_error)")
                delegate?.completedFetchingFavoFlag(flag: false)
                return
            }
            guard let userData = document?.data(),
                  let favorites = userData["favorite_shops"] as? [String]
            else {
                delegate?.completedFetchingFavoFlag(flag: false)
                return
            }
            delegate?.completedFetchingFavoFlag(flag: favorites.contains(shopID))
        }
    }
    
    func updateFavoriteFlag(_ userID: String, _ shopID: String, favoFlag: Bool) {
        let userRef = firestore.collection("user").document(userID)
        if favoFlag {
            //MARK: arrayUnion https://firebase.google.com/docs/firestore/manage-data/add-data
            userRef.updateData([
                "favorite_shops": FieldValue.arrayUnion([shopID])
            ])
        } else {
            userRef.updateData([
                "favorite_shops": FieldValue.arrayRemove([shopID])
            ])
        }
    }
    
    func fetchUserFavorites(of userID: String) {
        let userRef = firestore.collection("user").document(userID)
        userRef.getDocument { (document, error) in
            if let _error = error {
                print("Error happen :\(_error)")
                return
            }
            guard let userData = document?.data(),
                  let favorites = userData["favorite_shops"] as? [String]
            else {
                return
            }
            delegate?.completedFetchingUserFavorites(favoriteIDs: favorites)
        }
    }
}

protocol FirebaseHelperDelegate: class {
    func completedFetchingShops(shops: [Shop])
    func completedFetchingReviews(reviews: [Review])
    func completedFetchingPictures(pictures: [UIImage], shopID: String?)
    func completedFetchingProfile(profile: Profile?)
    func completedFetchingUserReview(reviewID: String, imageCount: Int, evaluation: Int?)
    func completedUpdatingReview(isSuccess: Bool)
    func completedUploadingReviewPics()
    func completedDeletingReviewPics()
    func completedFetchingShop(fetchedShopData: Shop)
    func completedUpdatingShopEvaluation()
    func completedUpdatingUserProfile(isSuccess: Bool)
    func completedUplodingShopRequest(isSuccess: Bool)
    func completedDeletingingShopRequest(isSuccess: Bool)
    func completedUpdatingRequestStatus(isSuccess: Bool, status: ReviewingStatus)
    func completedFetchingRequestedShopID(shopID: String?)
    func completedDeletingRequestUserInfo(isSuccess: Bool)
    func completedFetchingRejectReason(reason: String)
    func completedRegisteringToken(isSuccess: Bool)
    func completedFetchingToken(token: String)
    func completedFetchingNearUsers(tokens: [String])
    func completedFetchingFavoFlag(flag: Bool)
    func completedFetchingUserFavorites(favoriteIDs: [String])
}

// MARK: default implements
extension FirebaseHelperDelegate {
    func completedFetchingShops(shops: [Shop]) {
        print("default implemented completedFetchingShop")
    }
    func completedFetchingReviews(reviews: [Review]) {
        print("default implemented completedFetchingReviews")
    }
    func completedFetchingPictures(pictures: [UIImage], shopID: String?) {
        print("default implemented completedFetchingPictures")
    }
    func completedFetchingProfile(profile: Profile?) {
        print("default implemented completedFetchingProfile")
    }
    //MARK: TODO the arg should be Review ?
    func completedFetchingUserReview(reviewID: String, imageCount: Int, evaluation: Int?) {
        print("default implemented completedFetchingUserReview")
    }
    func completedUpdatingReview(isSuccess: Bool) {
        print("default implemented completedUploadingReview")
    }
    func completedUploadingReviewPics() {
        print("default implemented completedUploadingReviewPics")
    }
    func completedDeletingReviewPics() {
        print("default implemented completedDeletingReviewPics")
    }
    func completedFetchingShop(fetchedShopData: Shop) {
        print("default implemented completedFetchingShopEvaluation")
    }
    func completedUpdatingShopEvaluation() {
        print("default implemented completedUpdatingShopEvaluation")
    }
    func completedUpdatingUserProfile(isSuccess: Bool) {
        print("default implemented completedUpdatingUserName")
    }
    func completedUplodingShopRequest(isSuccess: Bool) {
        print("default implemented completedUplodingShopRequest")
    }
    func completedDeletingingShopRequest(isSuccess: Bool) {
        print("default implemented completedDeletingingShopRequest")
    }
    func completedUpdatingRequestStatus(isSuccess: Bool, status: ReviewingStatus) {
        print("default implemented completedUpdatingRequestStatus")
    }
    func completedFetchingRequestedShopID(shopID: String?) {
        print("default implemented completedFetchingRequestedShopID")
    }
    func completedDeletingRequestUserInfo(isSuccess: Bool) {
        print("default implemented deleteRequestUserInfo")
    }
    func completedFetchingRejectReason(reason: String) {
        print("default implemented completedFetchingRejectReason")
    }
    func completedRegisteringToken(isSuccess: Bool) {
        print("default implemented completedRegisteringToken")
    }
    func completedFetchingToken(token: String) {
        print("default implemented completedFetchingToken")
    }
    func completedFetchingNearUsers(tokens: [String]) {
        print("default implemented completedFetchingNearUsers")
    }
    func completedFetchingFavoFlag(flag: Bool) {
        print("default implemented completedFetchingFavoFlag")
    }
    func completedFetchingUserFavorites(favoriteIDs: [String]) {
        print("default implemented completedFetchingUserFavorites")
    }
}
