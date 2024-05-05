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
    let userBoardIndex: Int
//    let userId: String
    @State private var userCardCnt: Int = 0
    let boardWidth: CGFloat
    let boardHeight: CGFloat
    @State private var cards: [Card] = []
    var cardsString: String
    let userReadyOrNot: Bool
    /// 짝수
    let isOdd: Bool
    @State private var userChat: String = ""
    @State private var userChatShow: Bool = false
    
    let columns = [GridItem(.flexible()), GridItem(.flexible()), GridItem(.flexible()), GridItem(.flexible())]
    
    var body: some View {
        ZStack {
            playerBoard
            if userChatShow {
                chatView()
            }
            
        }
        .padding(isOdd ? [.trailing, .top] : [.leading, .top], 5)
        .frame(width: boardWidth, height: boardHeight)
        .onChange(of: self.cardsString) { newValue in
            self.cards = viewModel.stringToCards(newValue)
        }
        .onChange(of: self.cards) { newValue in
            self.userCardCnt = newValue.count
        }
        .onChange(of: viewModel.usersChat[userBoardIndex]) { newValue in
            if let userChat = newValue {
                self.userChat = userChat
                self.userChatShow = true
                DispatchQueue.main.asyncAfter(deadline: .now() + 5.0, execute: {
                    self.userChatShow = false
                })
            }
            
        }
        .onAppear {
            self.cards = viewModel.stringToCards(self.cardsString)
        }
    }
    
    var playerBoard: some View {
        VStack(spacing: 10) {
            profile
            if viewModel.gameStatus == .onAir || viewModel.gameStatus == .finished {
                userIsPlayGame
            } else {
                userIsNotPlayGame
                    .frame(height: boardHeight - 60)
            }
            if (viewModel.gameStatus == .onAir || viewModel.gameStatus == .finished) && cards.count <= 4 {
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
    }
    
    //MARK: - 채팅 뷰
    func chatView() -> some View {
        VStack(spacing: 0) {
            Spacer()
                .frame(height: 37)
            HStack(spacing: 0) {
                Spacer()
                    .frame(width: isOdd ? 20 : boardWidth - 40)
                Image("triangle")
                    .resizable()
                    .frame(width: 12, height: 12)
                    .rotationEffect(.degrees(-180))
            }
            .frame(maxWidth: .infinity, alignment: .topLeading)
            Text(self.userChat)
                .multilineTextAlignment(.leading)
                .font(.sea(10))
                .frame(maxWidth: 124)
                .background(Color(hex: "EAD8C0"))
                .clipShape(RoundedRectangle(cornerRadius: 5))
                .frame(maxWidth: .infinity, alignment: isOdd ? .topLeading : .topTrailing)
        }
        
        .padding(.leading, 5)
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: isOdd ? .topLeading : .topTrailing)
        
    }
    
    /// 유저 프로필
    var profile: some View {
        if isOdd {
            return AnyView(HStack {
                BoardUserProfileView(userImageUrl: user.profileUrl, userNickname: user.displayName, userCardCnt: userCardCnt, isOdd: isOdd)
                Spacer()
                if viewModel.gameType == .selectUser && viewModel.gameRoomData.value.whoseTurn != user.id && !viewModel.gameRoomData.value.attackers.contains(userBoardIndex) {
                    arrowView
                }
            })
        } else {
            return AnyView(HStack {
                if viewModel.gameType == .selectUser && viewModel.gameRoomData.value.whoseTurn != user.id && !viewModel.gameRoomData.value.attackers.contains(userBoardIndex) {
                    arrowView
                }
                Spacer()
                BoardUserProfileView(userImageUrl: user.profileUrl, userNickname: user.displayName, userCardCnt: userCardCnt, isOdd: isOdd)
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
                .frame(width: 56, height: 40)
        }
        .disabled(viewModel.gameType != .selectUser)
    }
    
    /// 유저 게임 중일때
    var userIsPlayGame: some View {
        LazyVGrid(columns: columns) {
            ForEach(self.cards, id: \.self) { card in
                if card.cardCnt != 0 {
                    CardView(card: card, cardWidthSize: boardWidth / 4 - 4, cardHeightSize: (boardHeight - 60) / 2, isBottomViewCard: false)
                }
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
    PlayerBoardView(user: User(id: "dd", displayName: "dd", profileUrl: "", history: [], currentUserId: nil),userBoardIndex: 1, boardWidth: 250, boardHeight: 250, cardsString: "", userReadyOrNot: true, isOdd: true)
}
