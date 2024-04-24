//
//  GameRoomDetailTopView.swift
//  LadybugPoker
//
//  Created by 김라영 on 2024/04/09.
//

import SwiftUI

struct GameRoomDetailTopView: View {
    @StateObject var viewModel = GameRoomDetailViewViewModel()
    let columns = [GridItem(.flexible()), GridItem(.flexible())]
    @Binding var usersInGame: [UserInGame]
    @State var userBoardCard: [Card] = []
//    let sampleText: [String] = ["11", "22", "33", "44", "55", "66"]
//    @StateObject var gameRoomData = GameRoomDetailTopViewViewModel()
    @State private var gameRoomData: GameRoom = GameRoom(id: "", hostId: "", title: "", password: "", maxUserCount: 0, code: "", usersInGame: [:], whoseTurn: "", whoseGetting: "", selectedCard: .bee, turnStartTime: .now)
    
    var body: some View {
        GeometryReader { proxy in
            LazyVGrid(columns: columns, spacing: 14) {
                ForEach(Array(zip(0..<usersInGame.count, usersInGame)), id: \.0) { index, userData in
                    PlayerBoardView(user: User(id: userData.userId, displayName: userData.displayName, profileUrl: userData.profileUrl, history: []), userCardCnt: viewModel.stringToCards(userData.boardCard).count, boardWidth: (proxy.size.width - 37) / 2, boardHeight: proxy.size.height / 3, cards: viewModel.stringToCards(userData.boardCard), userReadyOrNot: userData.readyOrNot, gameStart: true, isOdd: index % 2 == 0 ? true : false)
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(Color.bugLight)
        }
        .onChange(of: usersInGame) { newValue in
            print(#fileID, #function, #line, "- viewModel.gameRoomData: \(newValue)")
            
        }

    }
}

#Preview {
    GameRoomDetailTopView(usersInGame: .constant([]))
}


