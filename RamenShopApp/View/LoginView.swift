//
//  LoginView.swift
//  RamenShopApp
//
//  Created by Koro Saka on 2020-11-07.
//  Copyright © 2020 Koro Saka. All rights reserved.
//

import SwiftUI

struct SignupView: View {
    
    @ObservedObject var viewModel: LoginViewModel
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        ZStack {
            VStack(spacing: 0) {
                CustomNavigationBar(additionalAction: nil)
                Spacer()
                TextField("email", text: $viewModel.email)
                    .basicStyle()
                TextField("passsword", text: $viewModel.password)
                    .basicStyle()
                    .padding(.init(top: 0,
                                   leading: 0,
                                   bottom: 20,
                                   trailing: 0))
                Button(action: {
                    self.viewModel.createAccount()
                }) {
                    Text("Create account")
                        .basicButtonTextStyle(Color.white, Color.yellow)
                }
                .alert(isPresented: $viewModel.isShowSignUpAlert) {
                    if viewModel.sentEmail {
                        return Alert(title: Text("Sent Email!"),
                                     message: Text("We sent Email to your adress, so please check it."),
                                     dismissButton: .default(Text("OK"),
                                                             action: {
                                                                self.viewModel.reset()
                                                                presentationMode.wrappedValue.dismiss()
                                                             }
                                     )
                        )
                    } else {
                        return Alert(title: Text("Signup Error"),
                                     message: Text(viewModel.errorMesaage),
                                     dismissButton: .default(Text("OK"),
                                                             action: { self.viewModel.reset() }))
                    }
                    
                }
                Spacer()
            }
            if viewModel.isShowingProgress {
                CustomedProgress()
            }
        }
        .background(Color.green)
        .navigationBarHidden(true)
    }
}


//MARK: TODO separate View
struct LoginView: View {
    
    @ObservedObject var viewModel: LoginViewModel
    
    var body: some View {
        NavigationView {
            ZStack {
                LinearGradient(gradient: Gradient(colors: [Color.pasteGreen, Color.whitePasteGreen]),
                               startPoint: .top,
                               endPoint: .bottom)
                    .edgesIgnoringSafeArea(.all)
                VStack {
                    Spacer().frame(height: UIScreen.main.bounds.height / 4)
                    Text("RAMEN SHOP MAP")
                        .foregroundColor(Color.strongRed)
                        .font(.system(size: 35, weight: .black, design: .default))
                        .italic()
                        .bold()
                        .shadow(color: .black, radius: 2, x: 2, y: 2)
                    Spacer().frame(height: 70)
                    if(viewModel.logined) {
                        if viewModel.isAdmin {
                            NavigationLink(destination: AdminPageView(viewModel: .init())) {
                                Text("admin")
                                    .containingSymbol(symbol: "person.3",
                                                      color: .purple)
                            }
                        } else {
                            NavigationLink(destination: MapTopView()) {
                                Text("start")
                                    .containingSymbol(symbol: "play.circle.fill",
                                                      color: .strongPink)
                            }
                        }
                        Spacer().frame(height: 35)
                        Button(action: {
                            self.viewModel.logout()
                        }) {
                            Text("logout")
                                .foregroundColor(.darkGray)
                                .underline()
                                .font(.title2)
                        }
                        .alert(isPresented: $viewModel.logoutError) {
                            Alert(title: Text("Logout Error"),
                                  message: Text(viewModel.errorMesaage),
                                  dismissButton: .default(Text("OK"),
                                                          action: { self.viewModel.reset() }))
                        }
                        Spacer()
                    } else {
                        VStack {
                            TextField("email", text: $viewModel.email)
                                .basicStyle()
                            Spacer().frame(height: 30)
                            TextField("passsword", text: $viewModel.password)
                                .basicStyle()
                            Spacer().frame(height: 40)
                            Button(action: {
                                self.viewModel.login()
                            }) {
                                Text("login")
                                    .containingSymbol(symbol: "key.fill",
                                                      color: .seaBlue)
                            }
                            .alert(isPresented: $viewModel.isShowLoginAlert) {
                                if viewModel.isEmailNotVerified {
                                    return Alert(title: Text("Your Email has not been verified."),
                                                 message: Text("We have sent a Email, so please check it."),
                                                 dismissButton: .default(Text("OK"),
                                                                         action: { self.viewModel.reset()
                                                                         }
                                                 )
                                    )
                                } else {
                                    return Alert(title: Text("Login Error"),
                                                 message: Text(viewModel.errorMesaage),
                                                 dismissButton: .default(Text("OK"),
                                                                         action: { self.viewModel.reset()
                                                                         }
                                                 )
                                    )
                                }
                            }
                        }
                        .onAppear() { self.viewModel.reset() }
                        Spacer()
                        NavigationLink(destination: SignupView(viewModel: viewModel)) {
                            HStack {
                                Spacer()
                                Text("sign up").foregroundColor(.white).bold().font(.title)
                                Spacer().frame(width: 15)
                                Image(systemName: "person.badge.plus").foregroundColor(.white).font(.title3)
                                Spacer()
                            }
                            .upDownPadding(size: 8)
                            .sidePadding(size: 25)
                            .background(Color.viridianGreen)
                            .cornerRadius(20)
                            .shadow(color: .black, radius: 2)
                            .sidePadding(size: 25)
                        }
                        .simultaneousGesture(TapGesture().onEnded{
                            self.viewModel.reset()
                        })
                        Spacer().frame(height: 20)
                    }
                }
                if viewModel.isShowingProgress {
                    CustomedProgress()
                }
            }
            .navigationBarHidden(true)
        }
    }
}

struct CustomedProgress: View {
    var body: some View {
        HStack {
            Spacer()
            ProgressView("in process")
                .foregroundColor(.white)
                .upDownPadding(size: 30)
            Spacer()
        }
        .background(Color.blue)
        .cornerRadius(20)
        .sidePadding(size: 30)
    }
}
