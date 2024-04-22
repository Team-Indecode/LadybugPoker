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
//    @State private var turnsStartTime:
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
        VStack {
            GameRoomDetailTopView()
            GameRoomDetailBottomView(amIReadied: $amIReadied, myCards: $myCards, showCardSelectedPopup: $showCardSelectedPopup)
        }
        .task {
            try? await viewModel.getGameData()
        }
    }
}

#Preview {
    GameRoomDetailView()
}


