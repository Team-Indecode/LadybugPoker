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
                    
                    print(#fileID, #function, #line, "- myCards: \(myCards)")
                    let myId = Service.shared.myUserModel.id
                    if newValue[myId] == nil {
                        Service.shared.path.removeLast()
                    }
                    if viewModel.gameStatus == .notEnoughUsers || viewModel.gameStatus == .notStarted {
                        if let user = newValue[myId] {
                            amIReadied = user.readyOrNot
                        }
                    }
                    
                }
                .onChange(of: viewModel.gameRoomData.value.hostId) { oldValue, newValue in
                    isHost = Service.shared.myUserModel.id == newValue
                }
        } else {
            allContent
                .onChange(of: viewModel.gameRoomData.value.usersInGame) { newValue in
                    myCards = viewModel.getUserCard(true)
                }
                .onChange(of: viewModel.gameRoomData.value.hostId) { newValue in
                    isHost = Service.shared.myUserModel.id == newValue
                }
        }
    }
    
    var allContent: some View {
        GeometryReader(content: { proxy in
            VStack(spacing: 0) {
                GameRoomDetailTopView(usersInGame: $viewModel.gameRoomData.value.usersInGame, usersId: $viewModel.usersId)
                    .frame(height: proxy.size.height * 0.6706)
                    .environmentObject(viewModel)
                GameRoomDetailBottomView(amIReadied: $amIReadied, isHost: $isHost, myCards: $myCards, showCardSelectedPopup: $showCardSelectedPopup, gameType: $viewModel.gameType)
                    .frame(height: proxy.size.height * 0.3294)
                    .environmentObject(viewModel)
            }
            .transparentFullScreenCover(isPresented: $viewModel.showAttackerAndDefenderView, content: {
                GamePlayAttackDefenceView(showView: $viewModel.showAttackerAndDefenderView)
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .environmentObject(viewModel)
            })
            .transparentFullScreenCover(isPresented: $viewModel.showLoserView, content: {
                GameFinishView(isHost: viewModel.gameRoomData.value.hostId == Service.shared.myUserModel.id, userIndex: viewModel.gameRoomData.value.loser)
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .environmentObject(viewModel)
                    .environmentObject(Service.shared)
                
            })
            .task {
                print(#fileID, #function, #line, "- gameId gameRoomId: \(gameRoomId)")
                try? await viewModel.getGameData(gameRoomId)
            }
        })
        
    }
}

#Preview {
    GameRoomDetailView(gameRoomId: "")
}


