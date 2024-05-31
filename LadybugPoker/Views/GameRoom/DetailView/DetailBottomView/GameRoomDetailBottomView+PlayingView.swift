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
        @EnvironmentObject private var bottomViewModel: GameRoomBottomViewModel
        /// 현재 턴인 유저id
        @Binding var userInTurn: String?
        /// 현재 턴인 유저 별명
        @Binding var userDisplayName: String?
        /// 내 카드 목록
        @Binding var myCards: [Card]
        /// 남은 시간...
        @Binding var secondsLeft: Int
        @Binding var selectedCardType: String?
        
        @Binding var showCardSelectedPopup: Bool
        @Binding var bottomGameType: GameType?
        @State private var selectedCard: Card? = nil
        
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
                                    .blinking()
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
                        Text("남은 시간: \(self.viewModel.secondsLeft > 0 ? self.viewModel.secondsLeft : 0)초")
                            .font(.sea(15))
                            .padding(.trailing)
                    }
                } else {
                    if let userDisplayName = userDisplayName {
                        VStack(spacing: 0) {
                            HStack(spacing: 0) {
                                Text(userDisplayName + " 턴 입니다")
                                    .font(.sea(15))
                                ForEach(0..<bottomViewModel.dots % 5, id:\.self) { _ in
                                    Text(".")
                                        .font(.sea(15))
                                        .foregroundStyle(Color.black)
                                }
                            }
                            Text("남은 시간: \(self.viewModel.secondsLeft > 0 ? self.viewModel.secondsLeft : 0)초")
                                .foregroundStyle(viewModel.showAttackerAndDefenderView ? Color.bugLight : Color.black)
                                .font(.sea(15))
                                .frame(maxWidth: .infinity, alignment: .trailing)
                                .padding(.trailing, 5)
                        }
                        
                        
                    }
                        
                }
                VStack(spacing: 0) {
                    Spacer()
                    ScrollView(.horizontal) {
                        HStack {
                            ForEach(myCards) { card in
                                Button {
                                    self.selectCardLogic(card)
                                } label: {
                                    if card.cardCnt != 0 {
                                        if selectedCard == nil {
                                            CardView(card: card, cardWidthSize: 60, cardHeightSize: 90, isBottomViewCard: true)
                                        } else {
                                            withAnimation(.easeInOut(duration: 0.5)) {
                                                CardView(card: card, cardWidthSize: 60, cardHeightSize: 90, isBottomViewCard: true)
                                                    .opacity(card == selectedCard ? 1 : 0.5)
                                            }
                                        }
                                        
                                    }
                                }
                                .disabled(viewModel.gameRoomData.value.whoseTurn == Service.shared.myUserModel.id ? false : true)
                                .padding(.leading, card == myCards.first ? 20 : 0)
                            }
                        }
                        .padding([.bottom, .top], 6)
                    }
                }
                .opacity(bottomGameType == .defender ? 0.7 : 1.0)
            }
        }
        
        func selectCardLogic(_ card: Card) {
            guard let whoseTurn = viewModel.gameRoomData.value.whoseTurn else { return }
            selectedCard = card
            viewModel.gameroomDataUpdate(.selectedCard, card.bug.cardString)
            DispatchQueue.main.asyncAfter(deadline: .now() + 1, execute: {
                viewModel.userCardChange(card.bug, myCards, true, whoseTurn)
                selectedCard = nil
            })
        }
    }
}


#Preview {
    GameRoomDetailBottomView.PlayingView(
        userInTurn: .constant(
            "123"
        ),
        userDisplayName: .constant("fkdud"),
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
