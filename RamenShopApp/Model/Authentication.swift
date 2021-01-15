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
                self.delegate?.afterSignUp(userID: authResult!.user.uid)
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
        //MARK: TEST to get fcm token
//        Messaging.messaging().token { token, error in
//          if let error = error {
//            print("Error fetching FCM registration token: \(error)")
//          } else if let token = token {
//            print("FCM registration token: \(token)")
//          }
//        }
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
    func afterSignUp(userID: String)
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
    func afterSignUp(userID: String) {
        print("default implemented afterSignUp")
    }
}
