//
//  Authentication.swift
//  RamenShopApp
//
//  Created by Koro Saka on 2020-11-07.
//  Copyright © 2020 Koro Saka. All rights reserved.
//

import Foundation
import Firebase

class Authentication {
    
    var delegate: AuthenticationDelegate?
    
    func checkCurrentUser() {
        if Auth.auth().currentUser != nil {
            delegate?.afterLogin()
            let user = Auth.auth().currentUser
            delegate?.setUserInfo(email: user?.email)
        }
    }
    
    func createAccount(email: String, password: String) {
        Auth.auth().createUser(withEmail: email, password: password) { authResult, error in
            if error != nil {
                self.delegate?.signUpError(error: error)
            } else {
                self.delegate?.afterSignUp()
            }
        }
    }
    
    func login(email: String, password: String) {
        Auth.auth().signIn(withEmail: email, password: password) { [weak self] authResult, error in
            guard let strongSelf = self else { return }
            if error == nil {
                strongSelf.delegate?.afterLogin()
            } else {
                strongSelf.delegate?.loginError(error: error)
            }
        }
    }
    
    func logout() {
        do {
            try Auth.auth().signOut()
            self.delegate?.afterLogout()
            
            // MARK: how to happen "logout error" ??
        } catch let signOutError as NSError {
            self.delegate?.logoutError(error: signOutError)
        }
    }
}


// MARK: to notice ViewModel
protocol AuthenticationDelegate {
    func afterLogin()
    func loginError(error: Error?)
    func signUpError(error: Error?)
    func logoutError(error: NSError?)
    func afterLogout()
    func setUserInfo(email: String?)
    func afterSignUp()
}
