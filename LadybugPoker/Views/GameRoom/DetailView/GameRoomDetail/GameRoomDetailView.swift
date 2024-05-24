//
//  GameRoomDetailView.swift
//  LadybugPoker
//
//  Created by 박진서 on 4/22/24.
//

import SwiftUI

struct GameRoomDetailView: View {
    @StateObject var viewModel = GameRoomDetailViewViewModel()
    @StateObject var keyboardHeightHelper = KeyboardHeightHelper()
    @State private var showCardSelectedPopup: Bool = false
    @State private var amIReadied: Bool = false
    @State private var isHost: Bool = false
    @State private var myCards: [Card] = []
    @State var showExistAlert: Bool = false
    @State var existUserId: String = ""
    @State var existUserDisplayName: String = ""
    /// 이 게임방 퇴장
    @State private var showExistThisRoom: Bool = false
    @State var gameRoomId: String
    @State var chat: String = ""
    @State var safeareaBottomSize: CGFloat = 0
    @FocusState var focusField: Bool
    
    var body: some View {
        if #available(iOS 17, *) {
            allContent
                .ignoresSafeArea(.keyboard)
                .onChange(of: viewModel.gameRoomData.value.usersInGame) { oldValue, newValue in
                    myCards = viewModel.getUserCard(true)
                    print(#fileID, #function, #line, "- myCards: \(myCards)")
                    let myId = Service.shared.myUserModel.id
                    if newValue[myId] == nil {
                        Service.shared.path.removeLast()
                    }
                    if viewModel.gameStatus == .notEnoughUsers || viewModel.gameStatus == .notStarted {
                        if let user = newValue[myId] {
                            amIReadied = user.readyOrNot
                        }
                    }
                }
                .onChange(of: viewModel.gameRoomData.value.hostId) { oldValue, newValue in
                    isHost = Service.shared.myUserModel.id == newValue
                }
                .onChange(of: viewModel.gameRoomId) { _, viewGameRoomId in
                    gameRoomId = viewGameRoomId
                    Task {
                        print(#fileID, #function, #line, "- new gameRoomId⭐️: \(gameRoomId)")
                        try? await viewModel.getGameData(gameRoomId)
                    }
                }

        } else {
            allContent
                .onChange(of: viewModel.gameRoomData.value.usersInGame) { newValue in
                    myCards = viewModel.getUserCard(true)
                }
                .onChange(of: viewModel.gameRoomData.value.hostId) { newValue in
                    isHost = Service.shared.myUserModel.id == newValue
                }
        }
    }
    
    var allContent: some View {
        GeometryReader(content: { proxy in
            VStack(spacing: 0) {
                GameRoomDetailTopView(usersInGame: $viewModel.gameRoomData.value.usersInGame, usersId: $viewModel.usersId, showExistAlert: $showExistAlert, existUserId: $existUserId, existUserDisplayName: $existUserDisplayName, isHost: $isHost)
                    .frame(height: proxy.size.height * 0.6706)
                    .environmentObject(viewModel)
                GameRoomDetailBottomView(amIReadied: $amIReadied, isHost: $isHost, myCards: $myCards, showCardSelectedPopup: $showCardSelectedPopup, gameType: $viewModel.gameType, safeareaBottomSize: $safeareaBottomSize, focusField: $focusField)
                    .frame(height: proxy.size.height * 0.3294)
                    .environmentObject(viewModel)
                    .environmentObject(keyboardHeightHelper)
            }
            .overlay(content: {
                if focusField {
                    Color.clear
                        .contentShape(Rectangle())
                        .onTapGesture {
                            self.hideKeyboard()
                        }
                } else {
                    EmptyView()
                }
            })
            .onAppear(perform: {
                safeareaBottomSize = proxy.safeAreaInsets.bottom
            })
            .onChange(of: self.keyboardHeightHelper.keyboardHeight, perform: { newValue in
                print(#fileID, #function, #line, "- keyboardHeight: \(newValue)")
            })
            .navigationBarTitleDisplayMode(.inline)
            .navigationTitle(viewModel.gameRoomData.value.title)
            .toolbarBackground(Color.bugDarkMedium, for: .navigationBar)
            .toolbarBackground(.visible, for: .navigationBar)
            .toolbar(content: {
                if viewModel.gameStatus == .notStarted || viewModel.gameStatus == .notEnoughUsers {
                    ToolbarItem(placement: .topBarLeading) {
                        navigationBackButton
                    }
                }
            })
            .transparentFullScreenCover(isPresented: $viewModel.showAttackerAndDefenderView, content: {
                GamePlayAttackDefenceView(showView: $viewModel.showAttackerAndDefenderView)
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .environmentObject(viewModel)
            })
            .transparentFullScreenCover(isPresented: $viewModel.showLoserView, content: {
                GameFinishView(isHost: viewModel.gameRoomData.value.hostId == Service.shared.myUserModel.id, loserIndex: viewModel.gameRoomData.value.loser)
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .environmentObject(viewModel)
                    .environmentObject(Service.shared)
                
            })
            .customAlert(title: "\(existUserDisplayName)를 퇴장 시키시겠습니까?", subTitle: "이 행동은 되돌릴 수 없습니다.", isPresented: $showExistAlert, yesButtonHandler: {
                viewModel.deleteUserInGameRoom(existUserId)
            })
            .customAlert(title: "게임방이 삭제됩니다", subTitle: "정말로 나가시겠습니까?", isPresented: $showExistThisRoom, yesButtonHandler: {
                print(#fileID, #function, #line, "- 방삭제")
                viewModel.deleteGameRoom()
            })
            .task {
                print(#fileID, #function, #line, "- gameId gameRoomId: \(gameRoomId)")
                viewModel.gameRoomId = gameRoomId
                try? await viewModel.getGameData(gameRoomId)
            }
        })
    }
    
    var navigationBackButton: some View {
        Button {
            if viewModel.gameRoomData.value.hostId == Service.shared.myUserModel.id {
                showExistThisRoom = true
            } else {
                Service.shared.path.removeLast()
                viewModel.deleteUserInGameRoom(Service.shared.myUserModel.id)
            }
        } label: {
            Image(systemName: "chevron.backward")
                .foregroundStyle(Color.black)
        }
    }
}

//#Preview {
//    GameRoomDetailView(gameRoomId: "")
//}
