//
//  PlayerBoardView.swift
//  LadybugPoker
//
//  Created by 김라영 on 2024/04/12.
//

import SwiftUI

/// 한 플레이어의 보드판
struct PlayerBoardView: View {
    let user: User
    let userCardCnt: Int
    let boardWidth: CGFloat
    let boardHeight: CGFloat
    let cards: [Card]
    
    let columns = [GridItem(.flexible()), GridItem(.flexible()), GridItem(.flexible()), GridItem(.flexible())]
    var body: some View {
        VStack(spacing: 8) {
            UserProfileView(userImageUrl: user.profileUrl ?? "", userNickname: user.displayName, userCardCnt: userCardCnt)
            LazyVGrid(columns: columns) {
                ForEach(self.cards, id: \.self) { card in
                    CardView(card: card, cardWidthSize: 40, cardHeightSize: 60, isBottomViewCard: false)
                        .padding(.bottom, 12)
                }
            }
            .frame(height: cards.count <= 4 ? (boardHeight - 60)/2 : boardHeight - 60)
            Spacer()
        }
        .padding([.leading, .top], 5)
        .frame(width: boardWidth, height: boardHeight)
    }
}

#Preview {
    PlayerBoardView(user: User(id: "", displayName: "rayoung", profileUrl: "https://picsum.photos/200"), userCardCnt: 2, boardWidth: 250, boardHeight: 250, cards: [Card(bug: .bee, cardCnt: 3), Card(bug: .frog, cardCnt: 4), Card(bug: .ladybug, cardCnt: 5), Card(bug: .rat, cardCnt: 5), Card(bug: .snail, cardCnt: 5), Card(bug: .snake, cardCnt: 5)])
}
