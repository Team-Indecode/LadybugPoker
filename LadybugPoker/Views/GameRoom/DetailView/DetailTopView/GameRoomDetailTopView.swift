//
//  GameRoomDetailTopView.swift
//  LadybugPoker
//
//  Created by 김라영 on 2024/04/09.
//

import SwiftUI

struct GameRoomDetailTopView: View {
    let columns = [GridItem(.flexible()), GridItem(.flexible())]
    let sampleText: [String] = ["11", "22", "33", "44", "55", "66"]
//    @StateObject var gameRoomData = GameRoomDetailTopViewViewModel()
    @State private var gameRoomData: GameRoom = GameRoom(id: "", hostId: "", title: "", password: "", maxUserCount: 0, code: "", users: [], usersInGame: [], whoseTurn: "", whoseGetting: "", selectedCard: .bee, turnStartTime: .now)
    
    var body: some View {
        GeometryReader { proxy in
            LazyVGrid(columns: columns) {
                ForEach(gameRoomData.usersInGame, id: \.self) { usersData in
                    PlayerBoardView(userId: usersData.userId, userCardCnt: usersData.handCard.count, boardWidth: (proxy.size.width - 74) / 2, boardHeight: (proxy.size.height * 0.6706) / 3, cards: usersData.boardCard, userReadyOrNot: true, gameStart: true)
                }
            }
        }
        .onAppear(perform: {
            gameRoomData = GameRoom.listPreview[0]
        })
    }
}

#Preview {
    GameRoomDetailTopView()
}


