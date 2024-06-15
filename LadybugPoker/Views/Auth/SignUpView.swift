//
//  SignUpView.swift
//  LadybugPoker
//
//  Created by 박진서 on 4/22/24.
//

import SwiftUI
import FirebaseAuth

struct SignUpView: View {
    @EnvironmentObject private var service: Service
    
    @State private var displayName: String = ""
    @State private var tempEmail: String = ""
    
    @State var email: String
    var password: String
    
    let domains = ["@gmail.com", "@naver.com", "@daum.net", "@empal.com", "@nate.com"]
    
    var body: some View {
        VStack(spacing: 0) {
            HStack(spacing: 12) {
                Image("ladybug")
                    .resizable()
                    .frame(width: 27, height: 27)
                    .padding(.leading, 15)
                
                Text("무당벌레 포커")
                    .font(.sea(15))
                    
                
                Spacer()
            }
            .frame(height: 69)
            .background(Color.bugDarkMedium)
            
            if email.isEmpty {
                Text("사용할 이메일을 입력해주세요.")
                    .font(.sea(20))
                    .padding(.top, 30)
                
                TextField("이메일", text: $tempEmail)
                    .multilineTextAlignment(.center)
                    .frame(height: 40)
                    .font(.sea(20))
                    .padding(.horizontal, 20)
                    .background {
                        Color.bugLightMedium
                    }
                    .clipShape(RoundedRectangle(cornerRadius: 10))
                    .overlay {
                        RoundedRectangle(cornerRadius: 10)
                            .stroke(Color.bugDark)
                    }
                    .padding(.horizontal, 20)
                    .padding(.top, 100)
                
                if tempEmail.isEmpty == false && tempEmail.contains("@") == false {
                    VStack(spacing: 0) {
                        ForEach(domains, id: \.self) { domain in
                            Button {
                                withAnimation {
                                    self.email = tempEmail + domain
                                }
                            } label: {
                                HStack {
                                    Spacer()
                                    
                                    Text(tempEmail + domain)
                                        .font(.sea(15))
                                        .padding(.vertical, 10)
                                    
                                    Spacer()
                                }

                            }
                            .foregroundStyle(Color.black)
                            .overlay(alignment: .bottom) {
                                if domain != domains.last {
                                    Color.black
                                        .frame(height: 1)
                                        .opacity(0.3)
                                }
                            }
                        }
                    }
                    .background {
                        Color.white
                    }
                    .clipShape(RoundedRectangle(cornerRadius: 10))
                    .padding(.horizontal, 20)
                    .padding(.top, 1)
                }
                
            } else {
                Text("사용할 닉네임을 입력해주세요.")
                    .font(.sea(20))
                    .padding(.top, 30)
                
                TextField("강동구무당벌레", text: $displayName)
                    .multilineTextAlignment(.center)
                    .frame(height: 40)
                    .font(.sea(20))
                    .padding(.horizontal, 20)
                    .background {
                        Color.bugLightMedium
                    }
                    .clipShape(RoundedRectangle(cornerRadius: 10))
                    .overlay {
                        RoundedRectangle(cornerRadius: 10)
                            .stroke(Color.bugDark)
                    }
                    .padding(.horizontal, 20)
                    .padding(.top, 80)
                
                HStack {
                    Spacer()
                    
                    Text("\(displayName.count) / 7")
                        .padding(.horizontal, 20)
                        .font(.sea(10))
                }
            }
            
            Spacer()
            
            Button {
                Task {
                    _ = try await Auth.auth().createUser(withEmail: email, password: password)
                    if let user = Auth.auth().currentUser {
                        print("user: \(user.uid)")
                        service.myUserModel = try await User.create(id: user.uid, displayName: displayName)
                        service.path = [.main]
                    }
                }
            } label: {
                ZStack {
                    displayName.count > 1 && displayName.count < 8 ?
                        Color.bugDark
                            .ignoresSafeArea()
                    :
                    Color(hex: "d9d9d9")
                        .ignoresSafeArea()

                    Text("다음")
                        .font(.sea(20))
                        .foregroundStyle(Color.white)
                }
            }
            .frame(height: 65)
            
        }
        .background {
            Color.bugLight
                .ignoresSafeArea()
        }
    }
}

#Preview {
    SignUpView(email: "", password: "")
}


//gmrjt9d6js@privaterelay.appleid.com
