//
//  GameRoomDetailTopView.swift
//  LadybugPoker
//
//  Created by 김라영 on 2024/04/09.
//

import SwiftUI

struct GameRoomDetailTopView: View {
    @EnvironmentObject var viewModel: GameRoomDetailViewViewModel
    let columns = [GridItem(.flexible()), GridItem(.flexible())]
    @Binding var usersInGame: [String : UserInGame]
    @Binding var usersId: [Int : String]
    @State var userBoardCard: [Card] = []
//    let sampleText: [String] = ["11", "22", "33", "44", "55", "66"]
//    @StateObject var gameRoomData = GameRoomDetailTopViewViewModel()
//    @State private var gameRoomData: GameRoom = GameRoom(id: "", hostId: "", title: "", password: "", maxUserCount: 0, code: "", usersInGame: [:], whoseTurn: "", whoseGetting: "", selectedCard: "", turnStartTime: "", questionCard:  nil, attackers: [], createdAt: "", turnTime: 0)
    
    var body: some View {
        GeometryReader { proxy in
            LazyVGrid(columns: columns, spacing: 14) {
                ForEach(0..<6, id: \.self) { index in
                    if let userId = usersId[index] {
                        if let userData = usersInGame[userId] {
                            PlayerBoardView(user: User(id: userData.id, displayName: userData.displayName, profileUrl: userData.profileUrl, history: []), userCardCnt: viewModel.stringToCards(userData.boardCard).count, boardWidth: (proxy.size.width - 37) / 2, boardHeight: proxy.size.height / 3, cards: viewModel.stringToCards(userData.boardCard), userReadyOrNot: userData.readyOrNot, isOdd: index % 2 == 0 ? true : false)
                                .environmentObject(viewModel)
                        }
                    } else {
                        Rectangle()
                            .fill(Color.bugLight)
                            .frame(width: (proxy.size.width) / 2, height: proxy.size.height / 3)
                    }
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(Color.bugLight)
        }
        .onChange(of: viewModel.allPlayerReadied) { newValue in
            print(#fileID, #function, #line, "- viewModel.gameRoomData: \(newValue)")
            
        }

    }
}

#Preview {
    GameRoomDetailTopView(usersInGame: .constant([:]), usersId: .constant([:]))
}


