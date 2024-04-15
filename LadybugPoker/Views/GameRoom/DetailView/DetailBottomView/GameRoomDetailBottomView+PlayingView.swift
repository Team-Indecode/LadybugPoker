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
        @Binding var userInTurn: UserInGame
        /// 내 카드 목록
        @Binding var myCards: [Card]
        /// 남은 시간...
        @Binding var secondsLeft: Int
        
        
        var body: some View {
            VStack {
                if Service.shared.myUserModel.id == userInTurn.userId {
                    HStack {
                        VStack(alignment: .leading) {
                            Text("내 차례입니다 !")
                                .font(.sea(10))
                            
                            Text("전달할 카드를 선택하세요.")
                                .font(.sea(12))
                                .foregroundStyle(Color.red)
                        }
                        
                        Spacer()
                    }
                    .padding(.horizontal, 20)
                    .overlay(alignment: .top) {
                        Text("남은 시간: \(secondsLeft)초")
                            .font(.sea(15))
                    }

                } else {
                    Text(userInTurn.userId + " 턴 입니다.")
                        .font(.sea(15))
                }

                
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
    GameRoomDetailBottomView.PlayingView(
        userInTurn: .constant(
            UserInGame(readyOrNot: true,
                       handCard: [],
                       boardCard: [],
                       userId: "hihi")
        ),
        myCards: .constant(
            [Card(bug: .bee, cardCnt: 3),
             Card(bug: .frog, cardCnt: 2),
             Card(bug: .ladybug, cardCnt: 3)]),
        secondsLeft: .constant(48)
    )
}
