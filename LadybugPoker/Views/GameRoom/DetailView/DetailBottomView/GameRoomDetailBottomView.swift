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
    private let startText = "게임 시작"
    
    @Binding var gameStatus: GameStatus
    
    @State private var chat: String = ""
    
    var body: some View {
        VStack(spacing: 0) {
            Spacer()
            
            Color(hex: "d9d9d9")
                .frame(height: 2)
                .padding(.bottom, 12)
            
            Text(gameStatus == .notStarted || gameStatus == .notEnoughUsers ? beforeGameText : "게임중 입니다.")
                .font(.sea(15))
            
            Button {
                
            } label: {
                Text(readyText)
                    .font(.sea(35))
            }
            .foregroundStyle(.black)
            .padding(.top, 30)
            
            Button {
                
            } label: {
                Text(cancelText)
                    .font(.sea(15))
            }
            .foregroundStyle(.black)
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
}

#Preview {
    GameRoomDetailBottomView(gameStatus: .constant(.notStarted))
}
