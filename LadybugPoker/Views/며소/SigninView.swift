//
//  SigninView.swift
//  LadybugPoker
//
//  Created by 박진서 on 4/5/24.
//

import SwiftUI
import KakaoSDKAuth
import KakaoSDKUser


struct SigninView: View {
    @EnvironmentObject private var service: Service
    
    var body: some View {
        VStack {
            HStack {
                Spacer()
                
                Image("ladybug")
                
                Spacer()
            }
            .padding(.top, 100)
            
            Text("무당벌레 포커")
                .font(.sea(30))
                .padding(.top, 40)
            
            Spacer()
            
            
            Button {
                signInWithKakao()
            } label: {
                HStack {
                    Image("ic_kakao")
                        .padding(.leading, 10)
                    
                    Spacer()
                }
                .frame(height: 50)
                .background {
                    Color(hex: "FFEB3B")
                }
                .overlay {
                    Text("카카오 로그인")
                        .font(.sea(20))
                        .foregroundStyle(Color.black)
                }
                .clipShape(RoundedRectangle(cornerRadius: 10))
                .padding(.horizontal, 30)

            }
            
            Button {
                
            } label: {
                HStack {
                    Image("ic_apple")
                        .padding(.leading, 18)
                    
                    Spacer()
                }
                .frame(height: 50)
                .background {
                    Color.white
                }
                .overlay {
                    Text("Apple 로그인")
                        .font(.sea(20))
                        .foregroundStyle(Color.black)
                }
                .clipShape(RoundedRectangle(cornerRadius: 10))
                .overlay {
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(Color.black)
                }
                .padding(.horizontal, 30)
                .padding(.vertical, 20)
            }
            
        }
        .background {
            Color.bugLight
                .ignoresSafeArea()
        }
    }
    
    private func signInWithKakao() {
        if (UserApi.isKakaoTalkLoginAvailable()) {
            UserApi.shared.loginWithKakaoTalk {(oauthToken, error) in
                if let error = error {
                    print(error)
                } else {
                    print("loginWithKakaoTalk() success.")
                    
                    UserApi.shared.me { user, error in
                        if let error {
                            print("kakao error")
                            print(error)
                            return
                        } else {
                            if let user {
                                if let id = user.id {

                                    
                                                                
                                    
                                }
                            }
                        }
                    }
                }
            }
        } else {
            UserApi.shared.loginWithKakaoAccount {(oauthToken, error) in
                    if let error = error {
                        print(error)
                    }
                    else {
                        print("loginWithKakaoAccount() success.")

                        UserApi.shared.me { user, error in
                            if let error {
                                print("kakao error")
                                print(error)
                                return
                            } else {
                                if let user {
                                    if let id = user.id {
                                        
                                    }
                                }
                            }
                        }
                    }
                }
        }
    }
    
    private func signInOnFirebase(email: String, password: String) async {
        
    }
}

#Preview {
    SigninView()
}
