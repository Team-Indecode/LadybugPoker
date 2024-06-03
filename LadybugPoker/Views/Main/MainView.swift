//
//  MainView.swift
//  LadybugPoker
//
//  Created by 박진서 on 4/5/24.
//

import SwiftUI
import NukeUI

struct MainView: View {
    @EnvironmentObject private var service: Service
    @State private var gameRooms: [GameRoom] = []
    @State private var showPasswordView: GameRoom? = nil
    @State private var showWrongPasswordPopup = false
    @State private var showTooManyUserPopup = false
    
    @State private var password: String = ""
    
    var body: some View {
        VStack {
            HStack {
                Image("ladybug")
                    .resizable()
                    .frame(width: 27, height: 27)
                
                Text("무당벌레 포커")
                    .font(.sea(15))
                
                Spacer()
                
                Button {
                    if let user = service.myUserModel {
                        service.path.append(.myPage(id: user.id))
                    }
                } label: {
                    if let user = service.myUserModel {
                        Text(user.displayName)
                            .font(.sea(15))
                        
                        if let url = service.myUserModel.profileUrl {
                            LazyImage(source: url, resizingMode: .aspectFill)
                                .frame(width: 30, height: 30)
                                .clipShape(Circle())
                        } else {
                            Circle().fill(Color(hex: "D9D9D9"))
                                .frame(width: 30, height: 30)
                                .overlay {
                                    Image("default_profile")
                                        .resizable()
                                        .frame(width: 22, height: 22)
                                }
      
                        }
                    }
                }
                .foregroundStyle(Color.black)
            }
            .padding(.horizontal, 15)
            .padding(.vertical, 20)
            .background(Color.bugDarkMedium)
            
            ScrollView {
                LazyVStack {
                    ForEach(gameRooms) { gameRoom in
                        Button {
                            if let password = gameRoom.password, password.isEmpty == false {
                                showPasswordView = gameRoom
                            } else {
                                Task {
                                    do {
                                        try await GameRoom.join(id: gameRoom.id)
                                        service.path.append(.gameRoom(gameRoomId: gameRoom.id))
                                    } catch {
                                        print("JOINING ERROR")
                                        print(error)
                                    }
                                }
                            }
                        } label: {
                            GameRoomView(gameRoom: gameRoom)
                                .onAppear {
                                    if gameRoom == gameRooms.last {
                                        Task {
                                            gameRooms.append(contentsOf: try await GameRoom.fetchList(gameRoom))
                                        }
                                    }
                                }
                        }
                    }
                    .padding(.top, 1)
                }
            }
            
            Button {
                service.path.append(.createGameRoom)
            } label: {
                Color.bugDark
                    .clipShape(RoundedRectangle(cornerRadius: 10))
                    .overlay {
                        Text("방 만들기")
                            .font(.sea(20))
                            .foregroundStyle(Color.white)
                    }
            }
            .frame(height: 50)
            .padding(.horizontal, 20)
        }
        .background {
            Color.bugLight
                .ignoresSafeArea()
        }
        .onAppear {
            Task {
                gameRooms = try await GameRoom.fetchList(nil)
//                gameRooms = GameRoom.listPreview
                try await Task.sleep(nanoseconds: 1_000_000_000)
                
                if let user = service.myUserModel {
                    if let gameId = user.currentUserId {
                        service.path.append(.gameRoom(gameRoomId: gameId))
                    } else {
//                        service.path.append(.guide)
                    }
                }
            }
        }
        .refreshable {
            Task {
                gameRooms = try await GameRoom.fetchList(nil)
            }
        }
        .overlay {
            ZStack {
                if let gameRoom = showPasswordView {
                    ZStack {
                        Color.black
                            .opacity(0.3)
                        
                        VStack(spacing: 0) {
                            Text("비밀번호를 입력하세요.")
                                .font(.sea(23))
                                .padding(.top, 35)
                            
                            TextField("", text: $password)
                                .font(.sea(17))
                                .frame(height: 39)
                                .padding(.horizontal, 20)
                                .background {
                                    RoundedRectangle(cornerRadius: 10)
                                        .fill(Color.bugLightMedium)
                                        .overlay {
                                            RoundedRectangle(cornerRadius: 10)
                                                .stroke(Color.bugDark)
                                        }
                                }
                                .padding(.horizontal, 33)
                                .padding(.vertical, 25)
                            
                            Color.bugDark.frame(height: 1)
                            
                            HStack(spacing: 0) {
                                Button {
                                    withAnimation {
                                        showPasswordView = nil
                                    }
                                } label: {
                                    ZStack {
                                        Color.clear
                                        
                                        Text("취소")
                                    }
                                }
                                
                                Color.bugDark
                                    .frame(width: 1)
                                
                                Button {
                                    withAnimation {
                                        if password == gameRoom.password {
                                            showPasswordView = nil

                                            Task {
                                                do {
                                                    try await GameRoom.join(id: gameRoom.id)
                                                    service.path.append(.gameRoom(gameRoomId: gameRoom.id))
                                                } catch GameError.tooManyUsers {
                                                    showTooManyUserPopup.toggle()
                                                } catch {
                                                    print("JOINING ERROR")
                                                    print(error)
                                                }
                                            }
                                            
                                        } else {
                                            showWrongPasswordPopup.toggle()
                                        }
                                    }
                                } label: {
                                    ZStack {
                                        Color.clear
                                        
                                        Text("예")
                                    }
                                }
        
                            }
                            .frame(height: 45)
                            .font(.sea(15))
                            .foregroundStyle(Color.black)
                            
                        }
                        .background(Color.bugLight)
                        .clipShape(RoundedRectangle(cornerRadius: 15))
                        .padding(.horizontal, 40)
                    }
                }
                
                if showWrongPasswordPopup {
                    CommonPopupView($showWrongPasswordPopup, title: "잘못된 비밀번호입니다.", subTitle: "", yesButtonHandler: {})
                }
                
                if showTooManyUserPopup {
                    ZStack {
                        Color.black.opacity(0.3)
                        CommonPopupView($showTooManyUserPopup, title: "인원이 가득찬 게임입니다.", subTitle: "참가할 수 없습니다.", yesButtonHandler: {})
                    }
                }
            }
        }
        .overlay(alignment: .bottomTrailing) {
            Button {
                if let url = URL(string: "https://volcano-kayak-10a.notion.site/177f2d3110694ac3805b6c96862d4091?pvs=4") {
                   UIApplication.shared.open(url)
                }
            } label: {
                Circle()
                    .fill(Color.bugDark)
                    .frame(width: 63, height: 63)
                    .overlay {
                        Text("게임방법")
                            .font(.sea(13))
                    }
            }
            .foregroundStyle(Color.white)
            .padding(.trailing, 20)
            .padding(.bottom, 70)
        }
    }
}

#Preview {
    MainView()
        .environmentObject(Service.shared)
}
