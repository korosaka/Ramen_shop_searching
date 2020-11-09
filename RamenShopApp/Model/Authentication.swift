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
    
    func createAccount(email: String, password: String) {
        Auth.auth().createUser(withEmail: email, password: password) { authResult, error in
            //            print(authResult)
            //            print(error)
            //            print("signup!")
        }
    }
    
    func login(email: String, password: String) {
        Auth.auth().signIn(withEmail: email, password: password) { [weak self] authResult, error in
            guard let strongSelf = self else { return }
            //            print("email:\(email), pass:\(password)")
            //            print(authResult)
            //            print(error)
            if error == nil {
                //                print("success!")
                strongSelf.delegate?.afterLogin()
            } else {
                strongSelf.delegate?.loginError()
            }
        }
    }
    
    func logout() {
        do {
            try Auth.auth().signOut()
        } catch {
            print("error happened")
        }
    }
}


// MARK: to notice ViewModel
protocol AuthenticationDelegate {
    func afterLogin()
    func loginError()
    func afterLogout()
}
