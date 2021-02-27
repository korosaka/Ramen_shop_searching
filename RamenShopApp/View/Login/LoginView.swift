//
//  LoginView.swift
//  RamenShopApp
//
//  Created by Koro Saka on 2020-11-07.
//  Copyright © 2020 Koro Saka. All rights reserved.
//

import SwiftUI

struct LoginView: View {
    
    @ObservedObject var viewModel: LoginViewModel
    
    var body: some View {
        NavigationView {
            ZStack {
                BackGroundView()
                    .edgesIgnoringSafeArea(.all)
                VStack {
                    Spacer().frame(height: UIScreen.main.bounds.height / 4)
                    Text(Constants.SHOP_MAP).largestTitleStyle()
                    Spacer().frame(height: 70)
                    if(viewModel.logined) {
                        if viewModel.isAdmin {
                            NavigationLink(destination: AdminPageView(viewModel: .init())) {
                                Text(Constants.ADMIN)
                                    .containingSymbol(symbol: "person.3",
                                                      color: .purple,
                                                      textFont: .title,
                                                      symbolFont: .title3)
                            }
                        } else {
                            NavigationLink(destination: MapTopView()) {
                                Text(Constants.START)
                                    .containingSymbol(symbol: "play.circle.fill",
                                                      color: .strongPink,
                                                      textFont: .title,
                                                      symbolFont: .title3)
                            }
                        }
                        Spacer().frame(height: 45)
                        Button(action: {
                            self.viewModel.logout()
                        }) {
                            Text(Constants.LOGOUT)
                                .foregroundColor(.darkGray)
                                .underline()
                                .font(.title2)
                        }
                        .alert(isPresented: $viewModel.logoutError) {
                            Alert(title: Text(Constants.LOGOUT_ERROR),
                                  message: Text(viewModel.errorMesaage),
                                  dismissButton: .default(Text(Constants.OK),
                                                          action: { self.viewModel.reset() }))
                        }
                        Spacer()
                    } else {
                        VStack {
                            TextField(Constants.EMAIL, text: $viewModel.email)
                                .basicStyle()
                            Spacer().frame(height: 30)
                            TextField(Constants.PASSWORD, text: $viewModel.password)
                                .basicStyle()
                            Spacer().frame(height: 40)
                            Button(action: {
                                self.viewModel.login()
                            }) {
                                Text(Constants.LOGIN)
                                    .containingSymbol(symbol: "key.fill",
                                                      color: .seaBlue,
                                                      textFont: .title,
                                                      symbolFont: .title3)
                            }
                            .alert(isPresented: $viewModel.isShowLoginAlert) {
                                if viewModel.isEmailNotVerified {
                                    return Alert(title: Text(Constants.NOT_VERIFIED_TITLE),
                                                 message: Text(Constants.NOT_VERIFIED_MESSAGE),
                                                 dismissButton: .default(Text(Constants.OK),
                                                                         action: { self.viewModel.reset()
                                                                         }
                                                 )
                                    )
                                } else {
                                    return Alert(title: Text(Constants.LOGIN_ERROR),
                                                 message: Text(viewModel.errorMesaage),
                                                 dismissButton: .default(Text(Constants.OK),
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
                            Text(Constants.SIGNUP)
                                .containingSymbolWide(symbol: "chevron.right",
                                                      color: .viridianGreen,
                                                      textFont: .title,
                                                      symbolFont: .title3)
                                .sidePadding(size: 20)
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
        .navigationViewStyle(StackNavigationViewStyle())
    }
}
