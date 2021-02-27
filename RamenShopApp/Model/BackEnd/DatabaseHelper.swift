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
    private let firestore: Firestore
    private let storage: Storage
    
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
        let name = shopData[Constants.FIELD_SHOP_NAME] as? String ?? Constants.EMPTY
        let location = shopData[Constants.FIELD_LOCATION] as! GeoPoint
        let reviewInfo = shopData[Constants.FIELD_REVIEW_INFO] as! [String: Any]
        let totalPoint = reviewInfo[Constants.FIELD_TOTAL_POINT] as? Int ?? 0
        let count = reviewInfo[Constants.FIELD_REVIEW_COUNT] as? Int ?? 0
        let userID = shopData[Constants.FIELD_UPLOAD_USER] as? String ?? Constants.EMPTY
        let inspectionStatus = shopData[Constants.FIELD_STATUS] as? Int ?? ReviewingStatus.rejected.rawValue
        
        return Shop(shopID: shopID,
                    name: name,
                    location: location,
                    totalPoint: totalPoint,
                    reviewCount: count,
                    uploadUser: userID,
                    reviewingStatus: ReviewingStatus(rawValue: inspectionStatus)!)
    }
    
    private func createShopsRef(_ target: ReviewingStatus) -> Query {
        firestore
            .collection(Constants.COLLECTION_SHOP)
            .whereField(Constants.FIELD_STATUS, isEqualTo: target.rawValue)
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
                .order(by: Constants.FIELD_CREATED_AT, descending: true)
                .limit(to: limitNum!)
                .getDocuments(completion: completionHandler)
        } else {
            reviewRef
                .order(by: Constants.FIELD_CREATED_AT, descending: true)
                .getDocuments(completion: completionHandler)
        }
    }
    
    func fetchUserReview(shopID: String, userID: String) {
        let userReviewRef = createReviewRef(shopID: shopID)
            .whereField(Constants.FIELD_USER_ID, isEqualTo: userID)
        
        userReviewRef.getDocuments { (querySnapshot, error) in
            if error != nil {
                return print("error happened in fetchUserReview !!")
            }
            for doc in querySnapshot!.documents {
                delegate?.completedFetchingUserReview(reviewID: doc.documentID,
                                                      imageCount: doc.data()[Constants.FIELD_IMAGE_COUNT] as? Int ?? 0,
                                                      evaluation: doc.data()[Constants.FIELD_EVALUATION] as? Int ?? nil)
                return
            }
        }
    }
    
    private func createReviewRef(shopID: String) -> CollectionReference {
        return firestore.collection(Constants.COLLECTION_SHOP)
            .document(shopID)
            .collection(Constants.COLLECTION_REVIEW)
    }
    
    func extractReviews(reviewQuery: QuerySnapshot) -> [Review] {
        var reviews = [Review]()
        for document in reviewQuery.documents {
            let data = document.data()
            let createdTimestamp = data[Constants.FIELD_CREATED_AT] as? Timestamp
            let review = Review(reviewID: document.documentID,
                                userID: data[Constants.FIELD_USER_ID] as? String ?? Constants.EMPTY,
                                evaluation: data[Constants.FIELD_EVALUATION] as? Int ?? 0,
                                comment: data[Constants.FIELD_COMMENT] as? String ?? Constants.EMPTY,
                                imageCount: data[Constants.FIELD_IMAGE_COUNT] as? Int ?? 0,
                                createdDate: createdTimestamp!.dateValue())
            reviews.append(review)
        }
        return reviews
    }
    
    func fetchUserProfile(userID: String) {
        let userRef = firestore.collection(Constants.COLLECTION_USER)
            .document(userID)
        
        userRef.getDocument { (document, error) in
            if error != nil {
                return print("error happened in fetchUserProfile !!")
            }
            if let data = document?.data() {
                let userName = data[Constants.FIELD_USER_NAME] as? String ?? Constants.NO_NAME
                let profile = Profile(userName: userName)
                if data[Constants.FIELD_HAS_ICON] as? Bool ?? false {
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
    
    private func fetchUserIcon(_ userID: String, _ profile: Profile) {
        createUserIconRef(userID).getData(maxSize: 1 * 1024 * 1024) { data, error in
            // MARK: asynchronous
            if let error = error {
                print("Error getting data: \(error)")
                delegate?.completedFetchingProfile(profile: profile)
            } else {
                let iconProfile = Profile(userName: profile.getUserName(),
                                          icon: UIImage(data: data!))
                delegate?.completedFetchingProfile(profile: iconProfile)
            }
        }
    }
    
    func uploadUserProfile(_ userID: String) {
        let userRef = firestore
            .collection(Constants.COLLECTION_USER)
            .document(userID)
        userRef.setData([
            Constants.FIELD_USER_NAME: Constants.NO_NAME,
            Constants.FIELD_HAS_ICON : false
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
        return storage.reference().child("\(Constants.USER_ICON)/\(userID)/\(Constants.ICON_FILE_NAME)")
    }
    
    func updateUserIconInfo(_ userID: String, _ hasProfileAlready: Bool) {
        let userRef = firestore.collection(Constants.COLLECTION_USER)
            .document(userID)
        if hasProfileAlready {
            userRef.updateData([
                Constants.FIELD_HAS_ICON: true
            ]) { err in
                delegate?.completedUpdatingUserProfile(isSuccess: err == nil)
            }
        } else {
            userRef.setData([
                Constants.FIELD_USER_NAME: Constants.NO_NAME,
                Constants.FIELD_HAS_ICON : true
            ]) { err in
                delegate?.completedUpdatingUserProfile(isSuccess: err == nil)
            }
        }
    }
    
    func updateUserName(userID: String, name: String, _ hasProfileAlready: Bool) {
        let userRef = firestore.collection(Constants.COLLECTION_USER)
            .document(userID)
        
        if hasProfileAlready {
            userRef.updateData([
                Constants.FIELD_USER_NAME: name
            ]) { err in
                delegate?.completedUpdatingUserProfile(isSuccess: (err == nil))
            }
        } else {
            userRef.setData([
                Constants.FIELD_USER_NAME: name,
                Constants.FIELD_HAS_ICON : false
            ]) { err in
                delegate?.completedUpdatingUserProfile(isSuccess: (err == nil))
            }
        }
    }
    
    func fetchPictureReviews(shopID: String, limit: Int?) {
        // MARK: TODO use createReviewRef(shopID: String)
        let reviewStoreRef =
            firestore.collection(Constants.COLLECTION_SHOP)
            .document(shopID)
            .collection(Constants.COLLECTION_REVIEW)
        var pictureReviewRef = reviewStoreRef.whereField(Constants.FIELD_IMAGE_COUNT, isGreaterThan: 0)
        // MARK: TODO .order(by: Constants.CREATED_AT, descending: true)
        // let test = pictureReviewRef.order(by: Constants.CREATED_AT, descending: true)
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
        fetchReviewImage(id: review.getReviewID(), completion: completionHandler)
    }
    
    private func fetchReviewImage(id reviewID: String, completion: @escaping ([UIImage]) -> Void) {
        var reviewImages = [UIImage]()
        let reviewStorageRef = storage.reference().child("\(Constants.REVIEW_PICTURE)/\(reviewID)")
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
    
    private func uploadReviewPics(_ pics: [UIImage],
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
    
    private func deletePreviousReviewPics(_ newPicCount: Int,
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
    
    private func createReviewPicRef(_ reviewID: String, _ index: Int) -> StorageReference {
        return storage.reference().child("\(Constants.REVIEW_PICTURE)/\(reviewID)/review_image_\(index).jpeg")
    }
    
    /**
     setData() will overwrite self previous review contents when it exists.
     when it doesn't, it will create a new document
     */
    func updateReview(shopID: String, review: Review) {
        let timeStamp: Timestamp = .init(date: review.getCreatedDate())
        // MARK: TODO use createReviewRef(shopID: String)?
        let reviewRef = firestore
            .collection(Constants.COLLECTION_SHOP)
            .document(shopID)
            .collection(Constants.COLLECTION_REVIEW)
            .document(review.getReviewID())
        reviewRef.setData([
            Constants.FIELD_USER_ID: review.getUserID(),
            Constants.FIELD_EVALUATION: review.getEvaluation(),
            Constants.FIELD_COMMENT: review.getComment(),
            Constants.FIELD_IMAGE_COUNT: review.getImageCount(),
            Constants.FIELD_CREATED_AT: timeStamp
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
        
        let shopRef = firestore.collection(Constants.COLLECTION_SHOP).document(shopID)
        shopRef.updateData([
            Constants.FIELD_REVIEW_INFO: [ Constants.FIELD_TOTAL_POINT: newTotalPoint,
                                     Constants.FIELD_REVIEW_COUNT: newReviewCount ]
        ]) { err in
            if let err = err {
                print("Error updating document: \(err)")
            }
            delegate?.completedUpdatingShopEvaluation()
        }
    }
    
    func updateUserLocation(userID: String, location: CLLocationCoordinate2D) {
        let userRef = firestore.collection(Constants.COLLECTION_USER).document(userID)
        let geoPoint = GeoPoint(latitude: location.latitude,
                                longitude: location.longitude)
        
        userRef.updateData([
            Constants.FIELD_LAST_LOCATION: geoPoint
        ]) { err in
            if let err = err {
                print("Error updating document: \(err)")
            }
        }
    }
    
    func fetchNearUsers(shopLocation: GeoPoint, requesterID: String) {
        var tokens = [String]()
        firestore.collection(Constants.COLLECTION_USER).getDocuments() { (querySnapshot, err) in
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
                for doc in querySnapshot!.documents {
                    if doc.documentID == requesterID { continue }
                    guard let userLocation = doc.data()[Constants.FIELD_LAST_LOCATION] as? GeoPoint else { continue }
                    
                    if isNearUser(shopLocation, userLocation) {
                        guard let token = doc.data()[Constants.FILED_FCM_TOKEN] as? String else { continue }
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
        let shopRef = firestore.collection(Constants.COLLECTION_SHOP).document(shopID)
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
        let shopRef = firestore.collection(Constants.COLLECTION_SHOP).document(shopID)
        shopRef.getDocument { (document, error) in
            if let _error = error {
                print("Error happen :\(_error)")
                return
            }
            guard let shopData = document?.data(),
                  let rejectReason = shopData[Constants.FIELD_REJECT_REASON] as? String
            else { return }
            delegate?.completedFetchingRejectReason(reason: rejectReason)
        }
    }
    
    func deleteShopRequest(shopID: String) {
        let shopRef = firestore.collection(Constants.COLLECTION_SHOP).document(shopID)
        shopRef.delete() { err in
            delegate?.completedDeletingingShopRequest(isSuccess: err == nil)
        }
    }
    
    func uploadShopRequest(shopName: String, location: GeoPoint, userID: String) {
        let shopID = UUID().uuidString
        let shopRef = firestore.collection(Constants.COLLECTION_SHOP).document(shopID)
        shopRef.setData([
            Constants.FIELD_SHOP_NAME: shopName,
            Constants.FIELD_LOCATION: location,
            Constants.FIELD_REVIEW_INFO: [ Constants.FIELD_TOTAL_POINT: 0,
                                     Constants.FIELD_REVIEW_COUNT: 0 ],
            Constants.FIELD_STATUS: ReviewingStatus.inProcess.rawValue,
            Constants.FIELD_REJECT_REASON: Constants.EMPTY,
            Constants.FIELD_UPLOAD_USER: userID
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
        let shopRef = firestore.collection(Constants.COLLECTION_SHOP).document(shopID)
        shopRef.updateData([
            Constants.FIELD_STATUS: ReviewingStatus.approved.rawValue
        ]) { err in
            delegate?.completedUpdatingRequestStatus(isSuccess: err == nil, status: .approved)
        }
    }
    
    func rejectRequest(_ shopID: String, reason: String) {
        let shopRef = firestore.collection(Constants.COLLECTION_SHOP).document(shopID)
        shopRef.updateData([
            Constants.FIELD_STATUS: ReviewingStatus.rejected.rawValue,
            Constants.FIELD_REJECT_REASON: reason
        ]) { err in
            delegate?.completedUpdatingRequestStatus(isSuccess: err == nil, status: .rejected)
        }
    }
    
    func uploadRequestUserInfo(_ shopID: String, _ userID: String) {
        let userRef = firestore.collection(Constants.COLLECTION_USER).document(userID)
        userRef.updateData([
            Constants.FIELD_REQUEST_SHOP: shopID
        ]) { err in
            delegate?.completedUplodingShopRequest(isSuccess: err == nil)
        }
    }
    
    func deleteRequestUserInfo(userID: String) {
        let userRef = firestore.collection(Constants.COLLECTION_USER).document(userID)
        userRef.updateData([
            Constants.FIELD_REQUEST_SHOP: FieldValue.delete(),
        ]) { err in
            delegate?.completedDeletingRequestUserInfo(isSuccess: err == nil)
        }
    }
    
    func fetchRequestedShopID(userID: String) {
        let userRef = firestore.collection(Constants.COLLECTION_USER).document(userID)
        userRef.getDocument { (document, error) in
            if let _error = error {
                print("Error happen :\(_error)")
                delegate?.completedFetchingRequestedShopID(shopID: nil)
                return
            }
            guard let userData = document?.data(),
                  let requestedShopID = userData[Constants.FIELD_REQUEST_SHOP] as? String
            else {
                delegate?.completedFetchingRequestedShopID(shopID: nil)
                return
            }
            delegate?.completedFetchingRequestedShopID(shopID: requestedShopID)
        }
    }
    
    func registerTokenToUser(token: String, to userID: String) {
        let userRef = firestore.collection(Constants.COLLECTION_USER).document(userID)
        userRef.updateData([
            Constants.FILED_FCM_TOKEN: token
        ]) { err in
            delegate?.completedRegisteringToken(isSuccess: err == nil)
        }
    }
    
    func fetchUserToken(of userID: String) {
        let userRef = firestore.collection(Constants.COLLECTION_USER).document(userID)
        userRef.getDocument { (document, error) in
            if let _error = error {
                print("Error happen :\(_error)")
                return
            }
            guard let userData = document?.data(),
                  let token = userData[Constants.FILED_FCM_TOKEN] as? String
            else { return }
            
            delegate?.completedFetchingToken(token: token)
        }
    }
    
    func fetchFavoriteFlag(_ userID: String, _ shopID: String) {
        let userRef = firestore.collection(Constants.COLLECTION_USER).document(userID)
        userRef.getDocument { (document, error) in
            if let _error = error {
                print("Error happen :\(_error)")
                delegate?.completedFetchingFavoFlag(flag: false)
                return
            }
            guard let userData = document?.data(),
                  let favorites = userData[Constants.FIELD_FAVO_SHOPS] as? [String]
            else {
                delegate?.completedFetchingFavoFlag(flag: false)
                return
            }
            delegate?.completedFetchingFavoFlag(flag: favorites.contains(shopID))
        }
    }
    
    func updateFavoriteFlag(_ userID: String, _ shopID: String, favoFlag: Bool) {
        let userRef = firestore.collection(Constants.COLLECTION_USER).document(userID)
        if favoFlag {
            //MARK: arrayUnion https://firebase.google.com/docs/firestore/manage-data/add-data
            userRef.updateData([
                Constants.FIELD_FAVO_SHOPS: FieldValue.arrayUnion([shopID])
            ])
        } else {
            userRef.updateData([
                Constants.FIELD_FAVO_SHOPS: FieldValue.arrayRemove([shopID])
            ])
        }
    }
    
    func fetchUserFavorites(of userID: String) {
        let userRef = firestore.collection(Constants.COLLECTION_USER).document(userID)
        userRef.getDocument { (document, error) in
            if let _error = error {
                print("Error happen :\(_error)")
                return
            }
            guard let userData = document?.data(),
                  let favorites = userData[Constants.FIELD_FAVO_SHOPS] as? [String]
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
