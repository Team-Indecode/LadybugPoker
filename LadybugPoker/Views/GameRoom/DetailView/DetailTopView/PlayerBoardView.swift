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
    /// 플레이어가 보드판에서 위치가 어디인지
    let userBoardIndex: Int
    /// 플레어의 보드판 위에 있는 카드들 스트링(이거에 따라서 view변경이 아니므로 state가 아님)
    var cardsString: String
    var handCardString: String
    /// 플레이어의가 손에 가지고 있는 카드 수
    @State private var userCardCnt: Int = 0
    /// 플레이어의 보드판 카드들
    @State private var cards: [Card] = []
    /// 보드판 가로 크기
    let boardWidth: CGFloat
    /// 보드판 세로 크기
    let boardHeight: CGFloat
    /// 유저가 준비됬는지 아닌지
    let userReadyOrNot: Bool
    /// 유저가 보드판에서 왼쪽인지 오른쪽에 위치하는지
    let isOdd: Bool
    @State private var userChat: Chat = Chat(msg: "", time: "")
    @State private var userChatShow: Bool = false
    @Binding var showExitAlert: Bool
    @Binding var existUserId: String
    @Binding var existUserDisplayName: String
    
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
            print(#fileID, #function, #line, "- self.cardsString⭐️: \(newValue)")
            self.cards = viewModel.stringToCards(newValue)
        }
        .onChange(of: self.handCardString) { newValue in
            print(#fileID, #function, #line, "- handCardString: \(handCardString)")
            self.userCardCnt = viewModel.userHandCardCntChecking(newValue)
        }
        .onChange(of: self.cards) { newValue in
            if viewModel.gameStatus != .finished {
                viewModel.userIsLoserChecking(userBoardIndex, newValue)
            }
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
            self.userCardCnt = viewModel.userHandCardCntChecking(self.handCardString)
        }
    }
    
    var playerBoard: some View {
        VStack(spacing: 10) {
            profile
            if viewModel.gameStatus == .onAir || viewModel.gameStatus == .finished {
                userIsPlayGame
            } else {
                if viewModel.gameRoomData.value.hostId == Service.shared.myUserModel.id {
                    hostUserIsNotPlayGame
                        .frame(height: boardHeight - 80)
                } else {
                    userIsNotPlayGame
                        .frame(height: boardHeight - 80)
                }
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
            if let msg = self.userChat.msg {
                Text(msg)
                    .multilineTextAlignment(.leading)
                    .font(.sea(10))
                    .frame(maxWidth: 124)
                    .background(Color(hex: "EAD8C0"))
                    .clipShape(RoundedRectangle(cornerRadius: 5))
                    .frame(maxWidth: .infinity, alignment: isOdd ? .topLeading : .topTrailing)
            }
            
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
                // 유저 선택일 경우인 경우 & whoseTurn인 유저 제외 & attackers에 담겨져 있는 유저 제외
                if viewModel.gameType == .selectUser && viewModel.gameRoomData.value.whoseTurn != user.id && !viewModel.gameRoomData.value.attackers.contains(userBoardIndex) {
                    arrowView
//                        .blinking()
                }
            })
        } else {
            return AnyView(HStack {
                // 유저 선택일 경우인 경우 & whoseTurn인 유저 제외 & attackers에 담겨져 있는 유저 제외
                if viewModel.gameType == .selectUser && viewModel.gameRoomData.value.whoseTurn != user.id && !viewModel.gameRoomData.value.attackers.contains(userBoardIndex) {
                    arrowView
//                        .blinking()
                }
                Spacer()
                BoardUserProfileView(userImageUrl: user.profileUrl, userNickname: user.displayName, userCardCnt: userCardCnt, isOdd: isOdd)
            })
        }
    }
    
    var arrowView: some View {
        Button {
            var attackers: [Int] = viewModel.gameRoomData.value.attackers
            
            // 수비자의 idx를 attackers에 넣어준다
            if !attackers.contains(userBoardIndex) {
                attackers.append(userBoardIndex)
            }
            
//            if let whoseTurnIndex = viewModel.usersId.firstIndex(of: viewModel.gameRoomData.value.whoseTurn ?? "") {
//                if !attackers.contains(whoseTurnIndex) {
//                    attackers.append(whoseTurnIndex)
//                }
//            }
//            
            viewModel.gameroomDataUpdate(.whoseGetting, user.id, attackers)
        } label: {
            Image(systemName: self.isOdd ? "arrowshape.left.fill" : "arrowshape.right.fill")
                .resizable()
                .foregroundStyle(Color.orange)
                .frame(width: 56, height: 32)
                .blinking()
        }
        .disabled(viewModel.gameType != .selectUser)
        .disabled(viewModel.gameRoomData.value.whoseTurn == Service.shared.myUserModel.id ? false : true)
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
    
    /// 게임 방의 유저가 호스트가 게임 준비 중일 때
    var hostUserIsNotPlayGame: some View {
        VStack(spacing: 5) {
            Text(userReadyOrNot ? "준비 완료" : "대기중...")
                .font(.sea(35))
            if viewModel.gameRoomData.value.hostId != user.id {
                exitButton
            }
        }
    }
    
    var exitButton: some View {
        Button {
            print(#fileID, #function, #line, "- 퇴장 버튼 클릭⭐️")
            existUserId = user.id
            existUserDisplayName = user.displayName
            showExitAlert.toggle()
        } label: {
            Text("퇴장")
                .font(.sea(12))
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
}

#Preview {
//    PlayerBoardView(user: User(id: "", displayName: "rayoung", profileUrl: "https://picsum.photos/200"), userCardCnt: 2, boardWidth: 250, boardHeight: 250, cards: [Card(bug: .bee, cardCnt: 3), Card(bug: .frog, cardCnt: 4), Card(bug: .ladybug, cardCnt: 5), Card(bug: .rat, cardCnt: 5), Card(bug: .snail, cardCnt: 5), Card(bug: .snake, cardCnt: 5)])
    
//    PlayerBoardView(user: User(id: "dd", displayName: "dd", profileUrl: "", history: [], currentUserId: nil), userBoardIndex: 1, cardsString: "", boardWidth: 250, boardHeight: 250, userReadyOrNot: false, isOdd: false, showExitAlert: .constant(false))
    PlayerBoardView(user: User(id: "dd", displayName: "dd", profileUrl: "", history: [], currentUserId: nil), userBoardIndex: 1, cardsString: "", handCardString: "", boardWidth: 250, boardHeight: 250, userReadyOrNot: false, isOdd: false, showExitAlert: .constant(false), existUserId: .constant(""), existUserDisplayName: .constant(""))
}
