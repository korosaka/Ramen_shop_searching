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
    @Published var isShowAlertForName = false
    var activeAlertForName: ActiveAlert = .confirmation
    var isNameEdited: Bool { isEditingName && newName != "" }
    var hasProfileAlready = false
    
    init() {
        db = .init()
        authentication = .init()
        //MARK: TODO refactoring (profile init)
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
        db.updateUserName(userID: _userID, name: newName, hasProfileAlready)
        newName = ""
        isEditingName = false
    }
    
    func resetAlertData() {
        activeAlertForName = .confirmation
    }
}

extension ProfileSettingViewModel: AuthenticationDelegate {
    func setUserInfo(user: User) {
        userID = user.uid
        db.fetchUserProfile(userID: user.uid)
    }
}

extension ProfileSettingViewModel: FirebaseHelperDelegate {
    func completedFetchingProfile(profile: Profile?) {
        guard let _profile = profile else { return }
        userProfile = _profile
        hasProfileAlready = true
    }
    
    func completedUpdatingUserName(isSuccess: Bool) {
        if isSuccess {
            if !hasProfileAlready { hasProfileAlready = true }
            activeAlertForName = .completion
        } else {
            activeAlertForName = .error
        }
        isShowAlertForName = true
        guard let _userID = userID else { return }
        db.fetchUserProfile(userID: _userID)
    }
}
