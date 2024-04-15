//
//  GameRoomDetailBottomView+PlayingView.swift
//  LadybugPoker
//
//  Created by 박진서 on 4/10/24.
//

import SwiftUI

extension GameRoomDetailBottomView {
    
    struct PlayingView: View {
        /// 현재 턴인 유저
        @Binding var userInTurn: User
        /// 내 카드 목록
        @Binding var myCards: [Card]
        
        var body: some View {
            VStack {
                Text(userInTurn.displayName + " 턴 입니다.")
                    .font(.sea(15))
                
                ScrollView(.horizontal) {
                    HStack {
                        ForEach(myCards) { card in
                            CardView(card: card, cardWidthSize: 60, cardHeightSize: 90, isBottomViewCard: false)
                                .padding(.leading, card == myCards.first ? 20 : 0)
                        }
                    }
                    .padding(.bottom, 15)
                }
                .padding(.bottom, 15)
            }
        }
    }
}


#Preview {
    GameRoomDetailBottomView.PlayingView(userInTurn: .constant(User(id: "idsjafkl", displayName: "진서", profileUrl: nil)), myCards: .constant([Card(bug: .bee, cardCnt: 3), Card(bug: .frog, cardCnt: 2), Card(bug: .ladybug, cardCnt: 3)]))
}
