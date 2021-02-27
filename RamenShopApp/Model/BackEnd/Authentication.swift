//
//  Authentication.swift
//  RamenShopApp
//
//  Created by Koro Saka on 2020-11-07.
//  Copyright © 2020 Koro Saka. All rights reserved.
//

import Foundation
import Firebase

// MARK: this class shoud be refactored,,,,,
class Authentication {
    
    weak var delegate: AuthenticationDelegate?
    
    var isEmailVerified: Bool {
        guard let isVerified = Auth.auth().currentUser?.isEmailVerified
        else { return false }
        return isVerified
    }
    
    func getUserUID() -> String? {
        Auth.auth().currentUser?.uid
    }
    
    func getUserEmail() -> String? {
        Auth.auth().currentUser?.email
    }
    
    func createAccount(email: String, password: String) {
        Auth.auth().createUser(withEmail: email, password: password) { authResult, error in
            if error != nil {
                self.delegate?.signUpError(error: error)
            } else {
                Auth.auth().currentUser?.sendEmailVerification { (error) in
                    //MARK: TODO even when email adress is invalied, error is nil,,,,,,
                    self.delegate?.completedSendingEmail(isSuccess: error == nil)
                }
            }
        }
    }
    
    func deleteAccount() {
        Auth.auth().currentUser?.delete { error in
            self.delegate?.completedDeletingAccount(isSuccess: error == nil)
        }
    }
    
    func login(email: String, password: String) {
        Auth.auth().signIn(withEmail: email, password: password) { [weak self] authResult, error in
            guard let strongSelf = self else { return }
            if error == nil {
                strongSelf.checkEmailVerified()
            } else {
                strongSelf.delegate?.loginError(error: error)
            }
        }
    }
    
    func checkEmailVerified() {
        if isEmailVerified {
            delegate?.afterLogin()
        } else {
            delegate?.informEmailNotVerified()
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

//MARK: TODO rename functions' name, and bind success function and error function by set arg (Error?)
protocol AuthenticationDelegate: class {
    func afterLogin()
    func loginError(error: Error?)
    func signUpError(error: Error?)
    func logoutError(error: NSError?)
    func afterLogout()
    func informEmailNotVerified()
    func completedSendingEmail(isSuccess: Bool)
    func completedDeletingAccount(isSuccess: Bool)
}

extension AuthenticationDelegate {
    func afterLogin() {
        print("default implemented afterLogin")
    }
    func loginError(error: Error?) {
        print("default implemented loginError")
    }
    func signUpError(error: Error?) {
        print("default implemented signUpError")
    }
    func logoutError(error: NSError?) {
        print("default implemented logoutError")
    }
    func afterLogout() {
        print("default implemented afterLogout")
    }
    func informEmailNotVerified() {
        print("default implemented informEmailNotVerified")
    }
    func completedSendingEmail(isSuccess: Bool) {
        print("default implemented completedSendingEmail")
    }
    func completedDeletingAccount(isSuccess: Bool) {
        print("default implemented completedDeletingAccount")
    }
}
