//
//  GameRoomDetailView.swift
//  LadybugPoker
//
//  Created by 박진서 on 4/22/24.
//

import SwiftUI
import AVFoundation

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
    @FocusState var focusField: Bool
    @State var showError: Bool = false
    
    var body: some View {
        if #available(iOS 17, *) {
            allContent
                .ignoresSafeArea(.keyboard)
                .onChange(of: viewModel.gameRoomData.value.usersInGame) { oldValue, newValue in
                    myCards = viewModel.getUserCard(true)
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
                .onChange(of: viewModel.gameRoomId) { _, viewGameRoomId in
                    gameRoomId = viewGameRoomId
                    Task {
                        try? await viewModel.getGameData(gameRoomId)
                    }
                }
                .onChange(of: viewModel.errorMessage, { _, errorMessage in
                    self.showError.toggle()
                })
                .onChange(of: viewModel.gameStatus) { old, new in
                    if  viewModel.isMusicPlaying && (new == .notStarted || (new == .onAir && old == .notStarted)) {
                        viewModel.preparePlayMusic()
                        viewModel.playMusic()
                    }
                }
                .onChange(of: viewModel.gameRoomData.value.hostId) { _, hostId in
                    isHost = Service.shared.myUserModel.id == hostId
                }

        } else {
            allContent
                .onChange(of: viewModel.gameRoomData.value.usersInGame) { newValue in
                    myCards = viewModel.getUserCard(true)
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
                .onChange(of: viewModel.errorMessage, perform: { errorMessage in
                    self.showError.toggle()
                })
                .onChange(of: viewModel.gameStatus, perform: { new in
                    if  viewModel.isMusicPlaying && (new == .notStarted || (new == .onAir)) {
                        viewModel.preparePlayMusic()
                        viewModel.playMusic()
                    }
                })
                .onChange(of: viewModel.gameRoomData.value.hostId) { newValue in
                    isHost = Service.shared.myUserModel.id == newValue
                }
        }
    }
    
    var allContent: some View {
        GeometryReader(content: { proxy in
            VStack(spacing: 0) {
                GameRoomDetailTopView(viewModel: viewModel, showExistAlert: $showExistAlert, existUserId: $existUserId, existUserDisplayName: $existUserDisplayName)
                    .frame(height: proxy.size.height * 0.6706)
                    .overlay(content: {
                        if viewModel.gameType == .selectCard && viewModel.gameRoomData.value.whoseTurn == Service.shared.myUserModel.id {
                            Rectangle()
                                .fill(Color.black.opacity(0.5))
                        }
                    })
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
                    
                GameRoomDetailBottomView(viewModel: viewModel,amIReadied: $amIReadied, isHost: $isHost, myCards: $myCards, showCardSelectedPopup: $showCardSelectedPopup, gameType: $viewModel.gameType, focusField: $focusField)
                    .frame(height: proxy.size.height * 0.3294)
                    .environmentObject(keyboardHeightHelper)
            }
            
            .onAppear(perform: {
                viewModel.preparePlayMusic()
                viewModel.playMusic()
            })
            .onDisappear(perform: {
                print(#fileID, #function, #line, "- deinit")
                viewModel.stopMusic()
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
                GamePlayAttackDefenceView(viewModel: viewModel, showView: $viewModel.showAttackerAndDefenderView)
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
            })
            .transparentFullScreenCover(isPresented: $viewModel.showLoserView, content: {
                GameFinishView(viewModel: viewModel, isHost: viewModel.gameRoomData.value.hostId == Service.shared.myUserModel.id, loserId: viewModel.gameRoomData.value.loser)
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .environmentObject(Service.shared)
                
            })
            .customAlert(title: "\(existUserDisplayName)를 퇴장 시키시겠습니까?", subTitle: "이 행동은 되돌릴 수 없습니다.", isPresented: $showExistAlert, yesButtonHandler: {
                viewModel.deleteUserInGameRoom(existUserId)
            })
            .customAlert(title: viewModel.gameRoomData.value.usersInGame.count > 1 ? "방장이 위임됩니다." : "게임방이 삭제됩니다.", subTitle: "정말로 나가시겠습니까?", isPresented: $showExistThisRoom, yesButtonHandler: {
                if viewModel.gameRoomData.value.usersInGame.count > 1 {
                    viewModel.changeHost()
                } else {
                    viewModel.deleteGameRoom()
                }
            })
            .customCheckAlert(title: "방장이 되었습니다.", subTitle: "", isPresented: $viewModel.showHostChange)
            .customCheckAlert(title: "에러가 발생했습니다", subTitle: viewModel.errorMessage, isPresented: self.$showError)
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
