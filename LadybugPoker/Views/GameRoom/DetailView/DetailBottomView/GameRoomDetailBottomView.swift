//
//  GameRoomDetailBottomView.swift
//  LadybugPoker
//
//  Created by 박진서 on 4/9/24.
//

import SwiftUI

struct GameRoomDetailBottomView: View {
    @EnvironmentObject private var viewModel: GameRoomDetailViewViewModel
    
    private let beforeGameText = "게임시작 전 입니다."
    private let allPlayerReadied = "모든 플레이어가 준비되었습니다."
    private let hostWarningText = "시작하지 않으면 10초 뒤에 강퇴됩니다."
    private let readyText = "준비 완료"
    private let cancelText = "준비 취소"
    private let suggestReadyText = "준비 완료를 눌러주세요."
    private let suggestStartText = "게임 시작을 눌러주세요."
    private let notAllPlayerReadiedText = "아직 모든 플레이어가 준비되지 않았습니다."
    private let startText = "게임 시작"
    
    /// 내가 준비 했는지
    @Binding var amIReadied: Bool
    @State var chat: String = ""
    @State private var userDisplayName: String? = ""
    
    /// 내가 방장인지
    @Binding var isHost: Bool

    /// 내 카드 목록
    @Binding var myCards: [Card]
    /// 카드 선택 시 확인 팝업
    @Binding var showCardSelectedPopup: Bool
    @Binding var gameType: GameType?
    
    var body: some View {
        VStack(spacing: 0) {
            Color(hex: "d9d9d9")
                .frame(height: 2)
                .padding(.bottom, 12)
            
            if viewModel.gameStatus == .onAir {
                PlayingView(userInTurn: $viewModel.gameRoomData.value.whoseTurn,
                            userDisplayName: $userDisplayName,
                            myCards: $myCards,
                            secondsLeft: $viewModel.secondsLeft,
                            selectedCardType: $viewModel.gameRoomData.value.selectedCard,
                            showCardSelectedPopup: $showCardSelectedPopup,
                            bottomGameType: $gameType
                )
                .disabled(viewModel.gameRoomData.value.whoseTurn != Service.shared.myUserModel.id)
                .environmentObject(viewModel)
                .onChange(of: viewModel.gameRoomData.value.whoseTurn) { newValue in
                    if let userId = newValue {
                        self.userDisplayName = viewModel.gameRoomData.value.usersInGame[userId]?.displayName
                    }
                }
                .onAppear {
                    if let userId = viewModel.gameRoomData.value.whoseTurn {
                        self.userDisplayName = viewModel.gameRoomData.value.usersInGame[userId]?.displayName
                    }
                }
            } else {
                // 게임시작 전입니다., 게임 중입니다, 모든 플레이어가 준비되었습니다 Text
                if isHost {
                    if viewModel.gameStatus == .notStarted {
                        if viewModel.allPlayerReadied {
                            Text(allPlayerReadied)
                                .font(.sea(15))
                                .padding(.bottom, 10)
                            Text(hostWarningText)
                                .font(.sea(15))
                                .padding(.bottom, 20)
                        } else {
                            Text(beforeGameText)
                                .font(.sea(15))
                                .padding(.bottom, 30)
                        }
                    } else if viewModel.gameStatus == .notEnoughUsers {
                        Text(beforeGameText)
                            .font(.sea(15))
                            .padding(.bottom, 30)
                    } else {
                        Text("게임중 입니다.")
                            .font(.sea(15))
                            .padding(.bottom, 30)
                    }
                } else {
                    Text(viewModel.gameStatus == .notStarted || viewModel.gameStatus == .notEnoughUsers ? beforeGameText : "게임중 입니다.")
                        .font(.sea(15))
                        .padding(.bottom, 30)
                }
                

                // 게임시작을 눌러주세요, 준비완료를 눌러주세요 Text
                if isHost {
                    if viewModel.allPlayerReadied {
                        Text(suggestStartText)
                            .font(.sea(35))
                    } else {
                        Text(notAllPlayerReadiedText)
                            .font(.sea(20))
                    }
                } else {
                    if amIReadied == false {
                        Text(suggestReadyText)
                            .font(.sea(35))

                    } else {
                        Text(readyText)
                            .font(.sea(35))

                    }
                }
                // 게임 시작 버튼
                Button {
                    if isHost {
                        viewModel.cardDistribute()
                    } else {
                        amIReadied ? cancelReady() : ready()
                    }
                } label: {
                    if viewModel.gameRoomData.value.hostId == Service.shared.myUserModel.id {
                        Text(startText)
                            .opacity(viewModel.allPlayerReadied ? 1 : 0.5)
                    } else {
                        if amIReadied == false {
                            Text(readyText)
                        } else {
                            Text(cancelText)
                        }
                    }
                }
                .foregroundStyle(.black)
                .font(.sea(15))
                .padding(.top, 30)
                
                HStack(spacing: 5) {
                    Spacer()
                    
                    Image("ladybug")
                        .resizable()
                        .frame(width: 27, height: 27)
                    
                    Text("무당벌레 포커")
                        .font(.sea(15))
                }
                .padding(.trailing, 16)
                .padding(.top, 20)
                .padding(.bottom, 15)
            }
            Spacer()
            TextField("메세지를 입력해주세요.", text: $chat)
                .font(.sea(15))
                .frame(height: 38)
                .padding(.leading, 17)
                .background {
                    RoundedRectangle(cornerRadius: .infinity)
                        .stroke(Color.bugDarkMedium)
                }
                .overlay(alignment: .trailing) {
                    Button {
                        
                    } label: {
                        Image("send")
                    }
                    .padding(.trailing, 6)
                }
                .padding(.horizontal, 16)

        }
        .frame(maxHeight: .infinity)
        .background(Color.bugLight)
    }
    
    func ready() {
        withAnimation {
//            amIReadied = true
            viewModel.sendIamReady()
        }
    }
    
    func cancelReady() {
        withAnimation {
            amIReadied = false
        }
    }
    
}

#Preview {
    GameRoomDetailBottomView(
        amIReadied: .constant(false),
//        allPlayerReadied: false,
        isHost: .constant(false),
//        userInTurn: .constant(
//            UserInGame(readyOrNot: true,
//                       handCard: "",
//                       boardCard: "",
//                       userId: "hihi", displayName: "test")
//        ),
        myCards: .constant(
            [Card(bug: .bee, cardCnt: 3),
             Card(bug: .frog, cardCnt: 2),
             Card(bug: .ladybug, cardCnt: 3)]),
//        secondsLeft: .constant(48),
//        selectedCardType: .constant(nil),
        showCardSelectedPopup: .constant(false),
        gameType: .constant(.defender)
    )
}
