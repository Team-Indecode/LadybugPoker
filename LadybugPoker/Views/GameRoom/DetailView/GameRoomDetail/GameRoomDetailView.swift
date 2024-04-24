//
//  GameRoomDetailView.swift
//  LadybugPoker
//
//  Created by 박진서 on 4/22/24.
//

import SwiftUI

struct GameRoomDetailView: View {
    @StateObject var viewModel = GameRoomDetailViewViewModel()
    @State private var showCardSelectedPopup: Bool = false
    @State private var amIReadied: Bool = false
    @State private var isHost: Bool = false
    @State private var myCards: [Card] = []
    let gameRoomId: String
    
    var body: some View {
        if #available(iOS 17, *) {
            allContent
                .onChange(of: viewModel.gameRoomData.usersInGame) { oldValue, newValue in
                    myCards = viewModel.getUserCard(true)
                }
        } else {
            allContent
                .onChange(of: viewModel.gameRoomData.usersInGame) { newValue in
                    myCards = viewModel.getUserCard(true)
                }
        }
    }
    
    var allContent: some View {
        GeometryReader(content: { proxy in
            VStack(spacing: 0) {
                GameRoomDetailTopView(usersInGame: $viewModel.gameRoomData.usersInGame)
                    .frame(height: proxy.size.height * 0.6706)
                GameRoomDetailBottomView(amIReadied: $amIReadied, myCards: $myCards, showCardSelectedPopup: $showCardSelectedPopup)
                    .frame(height: proxy.size.height * 0.3294)
            }
            .task {
                try? await viewModel.getGameData(gameRoomId)
            }
        })
        
    }
}

#Preview {
    GameRoomDetailView(gameRoomId: "")
}


