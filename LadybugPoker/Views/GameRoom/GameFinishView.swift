//
//  GameFinishView.swift
//  LadybugPoker
//
//  Created by 김라영 on 2024/05/04.
//

import SwiftUI

struct GameFinishView: View {
    @EnvironmentObject private var service: Service
    @EnvironmentObject var viewModel: GameRoomDetailViewViewModel
    
    @State private var user: UserInGame = UserInGame(id: "", readyOrNot: false, handCard: nil, boardCard: nil, displayName: "", profileUrl: nil, idx: 0, chat: nil)
    
    let isHost: Bool
    let userIndex: Int?
    
    var body: some View {
        GeometryReader { proxy in
            VStack(spacing: 0) {
                topView
                    .frame(height: proxy.size.height * 0.6706)
                    .frame(maxWidth: .infinity)
                    .background(Color.black.opacity(0.5))
//                bottomView
                Spacer()
                    .frame(height: proxy.size.height * 0.3294)
                    .background(Color.black.opacity(0.0))
            }
            
        }
        .onAppear {
            guard let userIndex = userIndex else { return }
            let userId = viewModel.usersId[userIndex]
            if userId != "" {
                guard let userData =  viewModel.gameRoomData.value.usersInGame[userId] else {
                    return
                }
                self.user = userData
            }
        }
    }
    
    var topView: some View {
        VStack(spacing: 0) {
            Spacer()
            UserProfileView(user: user)
//            Text(user.idx == loser ? "😭" : "😀")
            Text("😭")
                .font(.sea(50))
                .padding(.top, 15)
            Text("패배")
                .font(.sea(50))
                .padding(.top, 10)
            Text("새로운 게임을 기다리고 있습니다.")
                .font(.sea(25))
                .padding(.top, 15)
            outRoomOrNewGame
                .padding(.top, 15)
            Spacer()
        }
    }
    @ViewBuilder
    var outRoomOrNewGame: some View {
        if isHost {
            HStack {
                outRoom
                Spacer()
                newGame
            }
            .padding(.horizontal, 20)
        } else {
            outRoom
        }
    }
    
    var outRoom: some View {
        Button {
            print(#fileID, #function, #line, "- 방 나가기")
            viewModel.showLoserView = false
            service.path.removeLast()
        } label: {
            Text("방 나가기")
                .font(.sea(25))
                .foregroundStyle(Color.white)
                .padding(.horizontal, 10)
                .padding(.vertical, 5)
                .background(Color.black)
                .clipShape(.capsule)
                .overlay {
                    Capsule()
                        .stroke(.white, lineWidth: 1)
                }
        }
        
    }
    
    var newGame: some View {
        Button {
            print(#fileID, #function, #line, "- 새 게임")
        } label: {
            Text("새 게임")
                .foregroundStyle(Color.white)
                .font(.sea(25))
                .padding(.horizontal, 10)
                .padding(.vertical, 5)
                .background(Color.black)
                .clipShape(.capsule)
                .overlay {
                    Capsule()
                        .stroke(.white, lineWidth: 1)
                }
        }
    }
    
    var bottomView: some View {
        VStack {
            Text("게임이 종료되었습니다")
        }
    }
}

#Preview {
    GameFinishView(isHost: false, userIndex: 0)
}
