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
    /// 짝수
    let isOdd: Bool
    
    let columns = [GridItem(.flexible()), GridItem(.flexible()), GridItem(.flexible()), GridItem(.flexible())]
    
    var body: some View {
        VStack(spacing: 10) {
            if let userProfile = viewModel.userProfiles[userId] {
                profile(userProfile)
            }
            if gameStart {
                userIsPlayGame
            } else {
                userIsNotPlayGame
            }
            if cards.count < 4 {
                Spacer()
                    .frame(height: (boardHeight - 60) / 2)
            }
        }
        .padding(isOdd ? [.trailing, .top] : [.leading, .top], 5)
        .frame(width: boardWidth, height: boardHeight)
    }
    
    /// 유저 프로필
    func profile(_ userProfile: User) -> some View {
        if isOdd {
            return AnyView(
                HStack {
                    UserProfileView(userImageUrl: userProfile.profileUrl ?? "", userNickname: userProfile.displayName, userCardCnt: userCardCnt, isOdd: isOdd)
                    Spacer()
                    if viewModel.attackUser == userId {
                        Image(systemName: "arrowshape.left.fill")
                            .foregroundStyle(Color.orange)
                            .frame(width: 30)
                    }
                }
            )
        } else {
            return AnyView(
                HStack {
                    if viewModel.attackUser == userId {
                        Image(systemName: "arrowshape.right.fill")
                            .foregroundStyle(Color.orange)
                            .frame(width: 30)
                    }
                    Spacer()
                    UserProfileView(userImageUrl: userProfile.profileUrl ?? "", userNickname: userProfile.displayName, userCardCnt: userCardCnt, isOdd: isOdd)
                }
            )
        }
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
            .padding(.top, 23)
    }
}

#Preview {
//    PlayerBoardView(user: User(id: "", displayName: "rayoung", profileUrl: "https://picsum.photos/200"), userCardCnt: 2, boardWidth: 250, boardHeight: 250, cards: [Card(bug: .bee, cardCnt: 3), Card(bug: .frog, cardCnt: 4), Card(bug: .ladybug, cardCnt: 5), Card(bug: .rat, cardCnt: 5), Card(bug: .snail, cardCnt: 5), Card(bug: .snake, cardCnt: 5)])
    PlayerBoardView(userId: "123", userCardCnt: 2, boardWidth: 250, boardHeight: 250, cards: [Card(bug: .bee, cardCnt: 3), Card(bug: .frog, cardCnt: 4), Card(bug: .ladybug, cardCnt: 5), Card(bug: .rat, cardCnt: 5), Card(bug: .snail, cardCnt: 5), Card(bug: .snake, cardCnt: 5)], userReadyOrNot: true, gameStart: true, isOdd: true)
}
