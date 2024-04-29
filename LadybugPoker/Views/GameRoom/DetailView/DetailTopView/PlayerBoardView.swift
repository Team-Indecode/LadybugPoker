//
//  PlayerBoardView.swift
//  LadybugPoker
//
//  Created by 김라영 on 2024/04/12.
//

import SwiftUI

/// 한 플레이어의 보드판
struct PlayerBoardView: View {
    @EnvironmentObject var viewModel: GameRoomDetailViewViewModel
    let user: User
//    let userId: String
    let userCardCnt: Int
    let boardWidth: CGFloat
    let boardHeight: CGFloat
    var cards: [Card]
    let userReadyOrNot: Bool
    /// 짝수
    let isOdd: Bool
    
    let columns = [GridItem(.flexible()), GridItem(.flexible()), GridItem(.flexible()), GridItem(.flexible())]
    
    var body: some View {
        VStack(spacing: 10) {
            profile
            if viewModel.gameStatus == .onAir {
                userIsPlayGame
            } else {
                userIsNotPlayGame
                    .frame(height: boardHeight - 60)
            }
            if viewModel.gameStatus == .onAir && cards.count < 4 {
                if cards.count == 0 {
                    Spacer()
                        .frame(height: boardHeight - 60)
                        .background(Color.blue)
                } else {
                    Spacer()
                        .frame(height: (boardHeight - 60) / 2)
                }
            }
        }
        .padding(isOdd ? [.trailing, .top] : [.leading, .top], 5)
        .frame(width: boardWidth, height: boardHeight)
        .onChange(of: self.cards) { newValue in
            print(#fileID, #function, #line, "- cards⭐️: \(cards)")
        }

    }
    
    /// 유저 프로필
    var profile: some View {
        if isOdd {
            return AnyView(HStack {
                UserProfileView(userImageUrl: user.profileUrl, userNickname: user.displayName, userCardCnt: userCardCnt, isOdd: isOdd)
                Spacer()
                if viewModel.gameBottomType == .selectUser && viewModel.gameRoomData.value.whoseTurn != user.id {
                    arrowView
                }
                
//                if viewModel.gameRoomData.value.whoseTurn == user.id {
//                    arrowView
//                }
            })
        } else {
            return AnyView(HStack {
                if viewModel.gameBottomType == .selectUser && viewModel.gameRoomData.value.whoseTurn != user.id {
                    arrowView
                }
                Spacer()
                UserProfileView(userImageUrl: user.profileUrl, userNickname: user.displayName, userCardCnt: userCardCnt, isOdd: isOdd)
            })
        }
    }
    
    var arrowView: some View {
        Button {
            viewModel.gameroomDataUpdate(.whoseGetting, user.id)
        } label: {
            Image(systemName: self.isOdd ? "arrowshape.left.fill" : "arrowshape.right.fill")
                .resizable()
                .foregroundStyle(Color.orange)
                .frame(width: 56)
        }
        .disabled(viewModel.gameBottomType != .selectUser)
    }
    
    /// 유저 게임 중일때
    var userIsPlayGame: some View {
        LazyVGrid(columns: columns) {
            ForEach(self.cards, id: \.self) { card in
                CardView(card: card, cardWidthSize: boardWidth / 4 - 4, cardHeightSize: (boardHeight - 60) / 2, isBottomViewCard: false)
            }
        }
    }
    
    /// 유저가 게임 준비중일떄
    var userIsNotPlayGame: some View {
        Text(userReadyOrNot ? "준비 완료" : "대기중...")
            .font(.sea(35))
//            .padding(.top, 23)
    }
}

#Preview {
//    PlayerBoardView(user: User(id: "", displayName: "rayoung", profileUrl: "https://picsum.photos/200"), userCardCnt: 2, boardWidth: 250, boardHeight: 250, cards: [Card(bug: .bee, cardCnt: 3), Card(bug: .frog, cardCnt: 4), Card(bug: .ladybug, cardCnt: 5), Card(bug: .rat, cardCnt: 5), Card(bug: .snail, cardCnt: 5), Card(bug: .snake, cardCnt: 5)])
    PlayerBoardView(user: User(id: "dd", displayName: "dd", profileUrl: "", history: [], currentUserId: nil), userCardCnt: 2, boardWidth: 250, boardHeight: 250, cards: [Card(bug: .bee, cardCnt: 3), Card(bug: .frog, cardCnt: 4), Card(bug: .ladybug, cardCnt: 5), Card(bug: .rat, cardCnt: 5), Card(bug: .snail, cardCnt: 5), Card(bug: .snake, cardCnt: 5)], userReadyOrNot: true, isOdd: true)
}
