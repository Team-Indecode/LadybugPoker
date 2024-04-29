//
//  GameRoomDetailBottomView+PlayingView.swift
//  LadybugPoker
//
//  Created by 박진서 on 4/10/24.
//

import SwiftUI

extension GameRoomDetailBottomView {
    
    struct PlayingView: View {
        @EnvironmentObject private var viewModel: GameRoomDetailViewViewModel
        /// 현재 턴인 유저
//        @Binding var userInTurn: UserInGame
        @Binding var userInTurn: String?
        /// 내 카드 목록
        @Binding var myCards: [Card]
        /// 남은 시간...
        @Binding var secondsLeft: Int
        @Binding var selectedCardType: String?
        
        @Binding var showCardSelectedPopup: Bool
        @Binding var bottomGameType: GameType?
        
        var body: some View {
            VStack(spacing: 0) {
//                if Service.shared.myUserModel.id == userInTurn.userId {
                if Service.shared.myUserModel.id == userInTurn {
                    HStack {
                        VStack(alignment: .leading) {
                            Text("내 차례입니다 !")
                                .font(.sea(10))
                            if bottomGameType == .selectCard {
                                Text("전달할 카드를 선택하세요.")
                                    .font(.sea(12))
                                    .foregroundStyle(Color.red)
                                    .frame(maxWidth: .infinity, alignment: .leading)
                            } else if bottomGameType == .selectUser {
                                Text("카드를 누구에게 전달할까요?")
                                    .font(.sea(12))
                                    .foregroundStyle(Color.red)
                                    .frame(maxWidth: .infinity, alignment: .leading)
                            } else {
                                EmptyView()
                            }
                        }
                        Spacer()
                    }
                    .padding(.horizontal, 20)
                    .overlay(alignment: .top) {
                        Text("남은 시간: \(viewModel.secondsLeft)초")
                            .font(.sea(15))
                    }
                } else {
                    if let userInTurn = userInTurn {
                        Text(userInTurn + " 턴 입니다.")
                            .font(.sea(15))
                    }
                }
                VStack(spacing: 0) {
                    Spacer()
                    ScrollView(.horizontal) {
                        HStack {
                            ForEach(myCards) { card in
                                Button {
//                                    if bottomGameType == .selectUser {
//                                        withAnimation {
//                                            showCardSelectedPopup.toggle()
//                                        }
//                                    }
                                    guard let whoseTurn = viewModel.gameRoomData.value.whoseTurn else { return }
                                    viewModel.gameroomDataUpdate(.selectedCard, card.bug.cardString)
                                    viewModel.userCardCardChange(card.bug, myCards, true, whoseTurn)
                                } label: {
                                    if card.cardCnt != 0 {
                                        CardView(card: card, cardWidthSize: 60, cardHeightSize: 90, isBottomViewCard: true)
                                    }

                                }
                                .padding(.leading, card == myCards.first ? 20 : 0)
                            }
                        }
                        .padding(.bottom, 15)
                    }
                }
                .padding(.bottom, 15)
                .opacity(bottomGameType == .defender ? 0.7 : 1.0)
            }
        }
    }
}


#Preview {
    GameRoomDetailBottomView.PlayingView(
        userInTurn: .constant(
            "123"
        ),
        myCards: .constant(
            [Card(bug: .bee, cardCnt: 3),
             Card(bug: .frog, cardCnt: 2),
             Card(bug: .ladybug, cardCnt: 3)]),
        secondsLeft: .constant(48),
        selectedCardType: .constant(nil),
        showCardSelectedPopup: .constant(false),
        bottomGameType: .constant(nil)
    )
}
