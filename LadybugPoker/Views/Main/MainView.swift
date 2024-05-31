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
                                
                            }
                            Task {
                                do {
                                    try await GameRoom.join(id: gameRoom.id)
                                    service.path.append(.gameRoom(gameRoomId: gameRoom.id))
                                } catch {
                                    print("JOINING ERROR")
                                    print(error)
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
    }
}

#Preview {
    MainView()
        .environmentObject(Service.shared)
}
