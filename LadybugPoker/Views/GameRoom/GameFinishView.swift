//
//  GameFinishView.swift
//  LadybugPoker
//
//  Created by 김라영 on 2024/05/04.
//

import SwiftUI

struct GameFinishView: View {
    @EnvironmentObject private var service: Service
    @StateObject var viewModel: GameRoomDetailViewViewModel
    
    @State private var loserProfile: Player = Player(id: "", profileUrl: nil, displayName: "")
    @State private var winnersProfile: [Player] = []
    
    let isHost: Bool
    let loserId: String?
    
    let columns = [GridItem(.flexible()), GridItem(.flexible())]
    
    var body: some View {
        GeometryReader { proxy in
            VStack(spacing: 0) {
                topView
                    .frame(height: proxy.size.height * 0.69)
                    .frame(maxWidth: .infinity)
                    .background(Color.black.opacity(0.5))
                Spacer()
                    .frame(height: proxy.size.height * 0.31)
                    .background(Color.black.opacity(0.0))
            }
        }
        .onAppear {
            guard let loserId = loserId else { return }
            self.winnersProfile = []
            for idx in 0..<6 {
                let userId = viewModel.usersId[idx]
                if let userId = userId {
                    guard let userData =  viewModel.getUserData(userId) else {
                        return
                    }
                    if loserId == userId {
                        self.loserProfile = userData
                    } else {
                        self.winnersProfile.append(userData)
                    }
                }
            }
        }
    }
    
    var topView: some View {
        VStack(spacing: 0) {
            Spacer()
            loserView
            winnersView
            Text("새로운 게임을 기다리고 있습니다.")
                .font(.sea(25))
                .foregroundStyle(Color.white)
//                .padding(.top, 15)
            outRoomOrNewGame
                .padding(.top, 15)
            Spacer()
        }
    }
    
    var loserView: some View {
        HStack(spacing: 0) {
            VStack(spacing: 5) {
                Text("😭")
                    .font(.sea(30))
                Text("패배")
                    .font(.sea(40))
                    .foregroundStyle(Color.white)
            }
            Spacer()
            UserProfileView(user: loserProfile, needOpacity: viewModel.gameRoomData.value.usersInGame.contains(where: { $0.key == loserProfile.id }) == false)
        }
        .padding(.horizontal, 20)
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
    }
    
    var winnersView: some View {
        HStack(spacing: 0) {
            VStack(spacing: 0) {
                Text("😆")
                    .font(.sea(30))
                Text("승리")
                    .font(.sea(40))
                    .foregroundStyle(Color.white)
            }
            Spacer()
                .frame(width: 40)
            LazyVGrid(columns: columns, spacing: 4) {
                ForEach(self.winnersProfile, id: \.self) { profile in
                    UserProfileView(user: profile, profileWidth: 118, profileHeight: 33, profileFontSize: 15, profileImageSize: 30, needOpacity: viewModel.gameRoomData.value.usersInGame.contains(where: { $0.key == profile.id }) == false)
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
        }
        .padding(.horizontal, 20)
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
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
            viewModel.updateUserCurrentGameId(nil)
            viewModel.deleteUserInGameRoom(Service.shared.myUserModel.id)
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
            Task {
                await viewModel.makeNewGameRoom()
            }
            
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
}

//#Preview {
//    GameFinishView(isHost: false, loserId: "")
//}
