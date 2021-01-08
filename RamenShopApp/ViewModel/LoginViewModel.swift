//
//  LoginViewModel.swift
//  RamenShopApp
//
//  Created by Koro Saka on 2020-11-07.
//  Copyright © 2020 Koro Saka. All rights reserved.
//

import Foundation
import Firebase

// MARK: TODO separate extention AuthenticationDelegate
class LoginViewModel: ObservableObject {
    var authentication: Authentication
    var db: FirebaseHelper
    
    @Published var email = ""
    @Published var password = ""
    @Published var logined = false
    @Published var loginError = false
    @Published var signUpError = false
    @Published var logoutError = false
    var errorMesaage = ""
    
    init() {
        authentication = .init()
        db = .init()
        authentication.delegate = self
        db.delegate = self
        checkCurrentUser()
    }
    
    func checkCurrentUser() {
        guard let _ = authentication.getUserUID() else { return }
        self.logined = true
    }
    
    func login() {
        authentication.login(email: email, password: password)
    }
    
    func createAccount() {
        authentication.createAccount(email: email, password: password)
    }
    
    func logout() {
        authentication.logout()
    }
    
    func reset() {
        email = ""
        password = ""
        loginError = false
        signUpError = false
        logoutError = false
        errorMesaage = ""
    }
}

extension LoginViewModel: AuthenticationDelegate {
    
    func afterLogin() {
        self.logined = true
    }
    
    func afterSignUp(userID: String) {
        db.uploadUserProfile(userID)
    }
    
    func loginError(error: Error?) {
        if error != nil {
            loginError = true
            errorMesaage = "error: \(error!)"
        }
    }
    
    func signUpError(error: Error?) {
        if error != nil {
            self.signUpError = true
            errorMesaage = "error: \(error!)"
        }
    }
    
    func logoutError(error: NSError?) {
        if error != nil {
            self.logoutError = true
            errorMesaage = "error: \(error!)"
        }
    }
    
    func afterLogout() {
        self.logined = false
    }
}

extension LoginViewModel: FirebaseHelperDelegate {
    func completedUpdatingUserProfile(isSuccess: Bool) {
        if isSuccess {
            self.logined = true
            checkCurrentUser()
        } else {
            self.signUpError = true
            errorMesaage = "signup error"
        }
    }
}
