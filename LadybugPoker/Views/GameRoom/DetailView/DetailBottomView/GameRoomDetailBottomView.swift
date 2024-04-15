//
//  GameRoomDetailBottomView.swift
//  LadybugPoker
//
//  Created by 박진서 on 4/9/24.
//

import SwiftUI

struct GameRoomDetailBottomView: View {
    @StateObject private var viewModel = ViewModel()
    
    private let beforeGameText = "게임시작 전 입니다."
    private let readyText = "준비 완료"
    private let cancelText = "준비 취소"
    private let suggestReadyText = "준비 완료를 눌러주세요."
    private let suggestStartText = "게임 시작을 눌러주세요."
    private let notAllPlayerReadiedText = "아직 모든 플레이어가 준비되지 않았습니다."
    private let startText = "게임 시작"
        
    @Binding var gameStatus: GameStatus
    
    /// 내가 준비 했는지
    @Binding var amIReadied: Bool
    
    /// 모든 플레이어가 준비했는지 (방장용)
    @State var allPlayerReadied: Bool
    
    @State private var chat: String = ""
    
    /// 내가 방장인지
    @State var isHost: Bool
    /// 누구 턴인지
    @Binding var userInTurn: User
    /// 내 카드 목록
    @Binding var myCards: [Card]
    
    var body: some View {
        VStack(spacing: 0) {
            Spacer()
            
            Color(hex: "d9d9d9")
                .frame(height: 2)
                .padding(.bottom, 12)
            
            if gameStatus == .onAir {
                PlayingView(userInTurn: $userInTurn, myCards: $myCards)

            } else {
                Text(gameStatus == .notStarted || gameStatus == .notEnoughUsers ? beforeGameText : "게임중 입니다.")
                    .font(.sea(15))
                    .padding(.bottom, 30)

                
                if isHost {
                    if allPlayerReadied {
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
                
                Button {
                    if isHost {
                        
                    } else {
                        amIReadied ? cancelReady() : ready()
                    }
                } label: {
                    if isHost {
                        Text(startText)
                            .opacity(allPlayerReadied ? 1 : 0.5)
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
        .background(Color.bugLight)
    }
    
    func ready() {
        withAnimation {
            amIReadied = true
        }
    }
    
    func cancelReady() {
        withAnimation {
            amIReadied = false
        }
    }
    
}

#Preview {
    GameRoomDetailBottomView(gameStatus: .constant(.onAir), amIReadied: .constant(false), allPlayerReadied: false, isHost: true, userInTurn: .constant(User(id: "hihi", displayName: "shawn", profileUrl: nil)), myCards: .constant([Card(bug: .bee, cardCnt: 3), Card(bug: .frog, cardCnt: 2), Card(bug: .ladybug, cardCnt: 3)]))
}
