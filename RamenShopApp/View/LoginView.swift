//
//  LoginView.swift
//  RamenShopApp
//
//  Created by Koro Saka on 2020-11-07.
//  Copyright © 2020 Koro Saka. All rights reserved.
//

import SwiftUI

struct SignupView: View {
    
    @ObservedObject var loginVM: LoginViewModel
    
    var body: some View {
        VStack {
            
            TextField("email", text: $loginVM.email)
            TextField("passsword", text: $loginVM.password)
            Button(action: {
                self.loginVM.createAccount()
            }) {
                Text("Create account")
            }
            .alert(isPresented: $loginVM.signUpError) {
                Alert(title: Text("Signup Error"),
                      message: Text(loginVM.errorMesaage),
                      dismissButton: .default(Text("OK"),
                                              action: { self.loginVM.reset() }))
            }
        }
    }
}

struct LoginView: View {
    
    @ObservedObject var loginVM: LoginViewModel
    
    
    var body: some View {
        NavigationView {
            VStack {
                if(loginVM.logined) {
                    Text("Hello,\(loginVM.email)")
                }
                Text("Ramen Search")
                    .foregroundColor(Color.white)
                    .font(.largeTitle)
                    .background(Color.red)
                if(loginVM.logined) {
                    Button(action: {
                        self.loginVM.logout()
                    }) {
                        Text("Logout")
                    }
                    .alert(isPresented: $loginVM.loginError) {
                        Alert(title: Text("Logout Error"),
                              message: Text(loginVM.errorMesaage),
                              dismissButton: .default(Text("OK"),
                                                      action: { self.loginVM.reset() }))
                    }
                } else {
                    VStack {
                        TextField("email", text: $loginVM.email)
                        TextField("passsword", text: $loginVM.password)
                        Button(action: {
                            self.loginVM.login()
                        }) {
                            Text("Login")
                        }
                        .alert(isPresented: $loginVM.loginError) {
                            Alert(title: Text("Login Error"),
                                  message: Text(loginVM.errorMesaage),
                                  dismissButton: .default(Text("OK"),
                                                          action: { self.loginVM.reset() }))
                        }
                    }.onAppear() { self.loginVM.reset() }
                }
                
                Spacer()
                if(loginVM.logined) {
                    NavigationLink(destination: MapSearchingView()) {
                        Text("Go to Ramen Search !")
                            .foregroundColor(Color.blue)
                    }
                }
                Spacer()
                
                if(!loginVM.logined) {
                    NavigationLink(destination: SignupView(loginVM: loginVM)) {
                        Text("Create new account")
                            .foregroundColor(Color.blue)
                    }.simultaneousGesture(TapGesture().onEnded{
                        self.loginVM.reset()
                    })
                }
            }
        }
    }
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView(loginVM: .init())
    }
}


struct Signup_Previews: PreviewProvider {
    static var previews: some View {
        SignupView(loginVM: .init())
    }
}
