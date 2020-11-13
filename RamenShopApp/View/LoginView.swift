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
        ZStack {
            Color.green
                .edgesIgnoringSafeArea(.all)
            VStack {
                TextField("email", text: $loginVM.email)
                    .basicStyle()
                TextField("passsword", text: $loginVM.password)
                    .basicStyle()
                    .padding(.init(top: 0,
                                   leading: 0,
                                   bottom: 20,
                                   trailing: 0))
                Button(action: {
                    self.loginVM.createAccount()
                }) {
                    Text("Create account")
                        .basicButtonTextStyle(Color.white, Color.yellow)
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
}

struct LoginView: View {
    
    @ObservedObject var loginVM: LoginViewModel
    
    
    var body: some View {
        NavigationView {
            ZStack {
                Color.green
                    .edgesIgnoringSafeArea(.all)
                VStack {
                    if(loginVM.logined) {
                        Text("Hello, \(loginVM.email)")
                            .font(.title)
                            .foregroundColor(Color.white)
                            .underline()
                            .padding()
                    }
                    Text("Ramen Search")
                        .foregroundColor(Color.white)
                        .font(.largeTitle)
                        .bold()
                        .frame(maxWidth: .infinity)
                        .padding(.init(top: 30,
                                       leading: 0,
                                       bottom: 30,
                                       trailing: 0))
                        .background(Color.red)
                    if(loginVM.logined) {
                        Button(action: {
                            self.loginVM.logout()
                        }) {
                            Text("Logout")
                                .basicButtonTextStyle(Color.white, Color.purple)
                                .padding(.init(top: 10,
                                               leading: 0,
                                               bottom: 0,
                                               trailing: 0))
                        }
                        .alert(isPresented: $loginVM.logoutError) {
                            Alert(title: Text("Logout Error"),
                                  message: Text(loginVM.errorMesaage),
                                  dismissButton: .default(Text("OK"),
                                                          action: { self.loginVM.reset() }))
                        }
                    } else {
                        VStack {
                            TextField("email", text: $loginVM.email)
                                .basicStyle()
                            TextField("passsword", text: $loginVM.password)
                                .basicStyle()
                                .padding(.init(top: 0,
                                               leading: 0,
                                               bottom: 20,
                                               trailing: 0))
                            Button(action: {
                                self.loginVM.login()
                            }) {
                                Text("Login")
                                    .basicButtonTextStyle(Color.white, Color.blue)
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
                            Text("Go to Ramen Search !").basicButtonTextStyle(Color.white, Color.red)
                        }
                    }
                    Spacer()
                    
                    if(!loginVM.logined) {
                        NavigationLink(destination: SignupView(loginVM: loginVM)) {
                            Text("Create new account")
                                .basicButtonTextStyle(Color.white, Color.yellow)
                                .padding(.init(top: 0,
                                               leading: 0,
                                               bottom: 10,
                                               trailing: 0))
                        }
                        .simultaneousGesture(TapGesture().onEnded{
                            self.loginVM.reset()
                        })
                    }
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
