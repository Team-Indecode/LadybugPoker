//
//  GuideView.swift
//  LadybugPoker
//
//  Created by 박진서 on 5/6/24.
//

import SwiftUI

struct GuideView: View {
    @EnvironmentObject private var service: Service
    
    @State private var users: [User] = []
    
    var body: some View {
        VStack {
            if users.count == 6 {
                HStack {
                    GuideView_PlayerBoardView(isLeft: true, user: users[0])
                    
                    Spacer()
                    
                    GuideView_PlayerBoardView(isLeft: true, user: users[1])
                }
                .padding(.horizontal, 10)
                
                HStack {
                    GuideView_PlayerBoardView(isLeft: true, user: users[2])
                    
                    Spacer()
                    
                    GuideView_PlayerBoardView(isLeft: true, user: users[3])
                }
                .padding(.horizontal, 10)
                
                HStack {
                    GuideView_PlayerBoardView(isLeft: true, user: users[4])
                    
                    Spacer()
                    
                    GuideView_PlayerBoardView(isLeft: true, user: users[5])
                }
                .padding(.horizontal, 10)
            }
            
            Spacer()
            
            Color(hex: "d9d9d9")
                .frame(height: 2)
            
            Text("게임시작 전 입니다.")
                .font(.sea(15))
            
            
            Text("준비 완료")
                .font(.sea(35))
                .padding(.vertical, 40)
            
            Text("준비 취소")
                .font(.sea(15))
        }
        .background(Color.bugLight)
        .overlay {
            ZStack {
                Color.black
                    .opacity(0.8)
                    .ignoresSafeArea()
                
                VStack {
                    Image("ladybug")
                        .padding(.bottom, 30)
                    
                    Text("무당벌레 포커에 오신 것을")
                    
                    Text("환영합니다 !")
                }
                .font(.sea(30))
                .foregroundStyle(Color.white)
            }
            .overlay(alignment: .bottom) {
                Button {
                    
                } label: {
                    Color.black
                        .frame(height: 38)
                }
                .clipShape(RoundedRectangle(cornerRadius: 20))
                .padding(.horizontal, 35)
                .padding()
            }
        }
        .onAppear {
            /// Test Code
            service.myUserModel = User.random()
            
            if let user = service.myUserModel {
                users.insert(user, at: 0)
            }
            
            for _ in 0..<5 {
                users.append(User.random())
            }
        }
    }
}

#Preview {
    VStack {
        GuideView()

    }
    .environmentObject(Service.shared)
}
