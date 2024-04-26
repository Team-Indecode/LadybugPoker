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
                .onChange(of: viewModel.gameRoomData.value.usersInGame) { oldValue, newValue in
                    myCards = viewModel.getUserCard(true)
                }
                .onChange(of: viewModel.gameRoomData.value.hostId) { oldValue, newValue in
                    isHost = Service.shared.myUserModel.id == newValue
                    print(#fileID, #function, #line, "- userId: \(Service.shared.myUserModel.id)")
                }
        } else {
            allContent
                .onChange(of: viewModel.gameRoomData.value.usersInGame) { newValue in
                    myCards = viewModel.getUserCard(true)
                }
                .onChange(of: viewModel.gameRoomData.value.hostId) { newValue in
                    isHost = Service.shared.myUserModel.id == newValue
                    print(#fileID, #function, #line, "- userId: \(Service.shared.myUserModel.id)")
                }
        }
    }
    
    var allContent: some View {
        GeometryReader(content: { proxy in
            VStack(spacing: 0) {
                GameRoomDetailTopView(usersInGame: $viewModel.gameRoomData.value.usersInGame, usersId: $viewModel.usersId)
                    .frame(height: proxy.size.height * 0.6706)
                    .environmentObject(viewModel)
                GameRoomDetailBottomView(amIReadied: $amIReadied, isHost: $isHost, myCards: $myCards, showCardSelectedPopup: $showCardSelectedPopup)
                    .frame(height: proxy.size.height * 0.3294)
                    .environmentObject(viewModel)
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


