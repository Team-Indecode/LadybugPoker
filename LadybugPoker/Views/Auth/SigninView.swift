//
//  SigninView.swift
//  LadybugPoker
//
//  Created by 박진서 on 4/5/24.
//

import SwiftUI
import KakaoSDKAuth
import KakaoSDKUser
import FirebaseAuth
import AuthenticationServices

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
            
            SignInWithAppleButton { request in
                request.requestedScopes = [.email, .fullName]
            } onCompletion: { result in
                switch result {
                case .success(let authResult):
                    switch authResult.credential {
                    case let appleIDCredential as ASAuthorizationAppleIDCredential:
                        // 계정 정보 가져오기
                        let id = appleIDCredential.user
                        let email = appleIDCredential.email
                        service.path.append(.signup(email: email ?? "", password: id))
                    default:
                        break
                        
                    }
                case .failure(let error):
                    print(error.localizedDescription)
                    print("error")
                
                }
                
            }
            .frame(height: 50)
            .padding(.horizontal, 30)
            .clipShape(RoundedRectangle(cornerRadius: 10))
            .signInWithAppleButtonStyle(.white)
            .padding(.top, 10)
            
            Button {
                
            } label: {
                HStack {
                    Text("로그인 없이 시작하기")
                        .font(.sea(20))
                        .foregroundStyle(Color.black)
                }
                .frame(height: 50)
                .padding(.horizontal, 30)
                .padding(.vertical, 10)
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
                                if let id = user.id, 
                                    let email = user.kakaoAccount?.email {
                                    Task {
                                        await signInOnFirebase(email: email, password: "\(id)")
                                    }
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
                                        if let id = user.id,
                                            let email = user.kakaoAccount?.email {
                                            Task {
                                                await signInOnFirebase(email: email, password: "\(id)")
                                            }
                                        }
                                    }
                                }
                            }
                        }
                    }
                }
        }
    }
    
    private func signInOnFirebase(email: String, password: String) async {
        do {
            _ = try await Auth.auth().signIn(withEmail: email, password: password)
            
            if let user = Auth.auth().currentUser {
                //TODO: 로그인 성공
                Task {
                    service.myUserModel = try await User.fetch(id: user.uid)
                    print(service.myUserModel)
                    service.path = [.main]
                }
            } else {
                service.path.append(.signup(email: email, password: password))
            }
        } catch {
            print(error)
            service.path.append(.signup(email: email, password: password))
        }
    }
}

#Preview {
    SigninView()
}
