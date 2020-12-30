//
//  ProfileSettingViewModel.swift
//  RamenShopApp
//
//  Created by Koro Saka on 2020-12-29.
//  Copyright © 2020 Koro Saka. All rights reserved.
//

import Foundation
import SwiftUI
import Firebase
class ProfileSettingViewModel: ObservableObject {
    @Published var userProfile: Profile
    @Published var isEditingName = false
    @Published var newName = ""
    var db: FirebaseHelper
    var authentication: Authentication
    var userID: String?
    
    init() {
        db = .init()
        authentication = .init()
        userProfile = Profile(userName: "unnamed")
        db.delegate = self
        authentication.delegate = self
        authentication.checkCurrentUser()
    }
    
    //MARK: TODO is it right to return SwiftUI View to View from VM???
    func getIconImage() -> some View {
        guard let iconImage = userProfile.icon else {
            return AnyView(Image(systemName: "person.crop.circle.fill").symbolIconLargeStyle())
        }
        return AnyView(Image(uiImage: iconImage).iconLargeStyle())
    }
    
    func getUserName() -> String {
        return userProfile.userName
    }
    
    func updateUserName() {
        guard let _userID = userID else { return }
        db.updateUserName(userID: _userID, newName: newName)
        newName = ""
        isEditingName = false
    }
    
}

extension ProfileSettingViewModel: AuthenticationDelegate {
    func setUserInfo(user: User) {
        userID = user.uid
        db.fetchUserProfile(userID: user.uid)
    }
}

extension ProfileSettingViewModel: FirebaseHelperDelegate {
    func completedFetchingProfile(profile: Profile) {
        userProfile = profile
    }
    
    func completedUpdatingUserName(isSuccess: Bool) {
        //MARK: TODO Error handling
        guard let _userID = userID else { return }
        db.fetchUserProfile(userID: _userID)
    }
}
