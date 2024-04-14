//
//  PlayerBoardView.swift
//  LadybugPoker
//
//  Created by 김라영 on 2024/04/12.
//

import SwiftUI

/// 한 플레이어의 보드판
struct PlayerBoardView: View {
    @StateObject var viewModel = GameRoomDetailTopViewViewModel()
//    let user: User
    let userId: String
    let userCardCnt: Int
    let boardWidth: CGFloat
    let boardHeight: CGFloat
    let cards: [Card]
    let userReadyOrNot: Bool
    let gameStart: Bool
    
    let columns = [GridItem(.flexible()), GridItem(.flexible()), GridItem(.flexible()), GridItem(.flexible())]
    
    var body: some View {
        VStack(spacing: 12) {
            if let userProfile = viewModel.userProfiles[userId] {
                UserProfileView(userImageUrl: userProfile.profileUrl ?? "", userNickname: userProfile.displayName, userCardCnt: userCardCnt)
            }
            if gameStart {
                userIsPlayGame
            } else {
                userIsNotPlayGame
            }
            Spacer()
        }
        .padding([.leading, .top], 5)
        .frame(width: boardWidth, height: boardHeight)
    }
    
    /// 유저 게임 중일때
    var userIsPlayGame: some View {
        LazyVGrid(columns: columns) {
            ForEach(self.cards, id: \.self) { card in
                CardView(card: card, cardWidthSize: boardWidth / 4 - 4, cardHeightSize: (boardHeight - 60) / 2, isBottomViewCard: false)
                    .padding(.bottom, 12)
            }
        }
        .frame(height: cards.count <= 4 ? (boardHeight - 60)/2 : boardHeight - 60)
    }
    
    /// 유저가 게임 준비중일떄
    var userIsNotPlayGame: some View {
        Text(userReadyOrNot ? "준비 완료" : "대기중...")
            .font(.sea(35))
            .padding(.top, 23)
    }
}

#Preview {
//    PlayerBoardView(user: User(id: "", displayName: "rayoung", profileUrl: "https://picsum.photos/200"), userCardCnt: 2, boardWidth: 250, boardHeight: 250, cards: [Card(bug: .bee, cardCnt: 3), Card(bug: .frog, cardCnt: 4), Card(bug: .ladybug, cardCnt: 5), Card(bug: .rat, cardCnt: 5), Card(bug: .snail, cardCnt: 5), Card(bug: .snake, cardCnt: 5)])
    PlayerBoardView(userId: "123", userCardCnt: 2, boardWidth: 250, boardHeight: 250, cards: [Card(bug: .bee, cardCnt: 3), Card(bug: .frog, cardCnt: 4), Card(bug: .ladybug, cardCnt: 5), Card(bug: .rat, cardCnt: 5), Card(bug: .snail, cardCnt: 5), Card(bug: .snake, cardCnt: 5)], userReadyOrNot: true, gameStart: true)
}
