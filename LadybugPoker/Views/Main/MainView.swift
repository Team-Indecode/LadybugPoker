//
//  MainView.swift
//  LadybugPoker
//
//  Created by 박진서 on 4/5/24.
//

import SwiftUI

struct MainView: View {
    @EnvironmentObject private var service: Service
    @State private var gameRooms: [GameRoom] = []
    
    var body: some View {
        NavigationStack(path: $service.path) {
            VStack {
                ForEach(gameRooms) { gameRoom in
                    GameRoomView(gameRoom: gameRoom)
                }
                
                Spacer()
                
                
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
            .navigationDestination(for: Path.self) { path in
                switch path {
                case .createGameRoom:
                    GameRoomCreateView()
                        .navigationBarBackButtonHidden()
                }
            }
        }
        .onAppear {
            gameRooms = GameRoom.listPreview
        }
    }
}

#Preview {
    MainView()
        .environmentObject(Service.shared)
}
