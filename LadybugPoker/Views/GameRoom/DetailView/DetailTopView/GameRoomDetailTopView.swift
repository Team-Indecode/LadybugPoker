//
//  GameRoomDetailTopView.swift
//  LadybugPoker
//
//  Created by 김라영 on 2024/04/09.
//

import SwiftUI

struct GameRoomDetailTopView: View {
    @StateObject var viewModel: GameRoomDetailViewViewModel

    let columns = [GridItem(.flexible()), GridItem(.flexible())]
    @Binding var showExistAlert: Bool
    @Binding var existUserId: String
    @Binding var existUserDisplayName: String
    @State var userBoardCard: [Card] = []
    
    var body: some View {
        GeometryReader { proxy in
            LazyVGrid(columns: columns, spacing: 0) {
                ForEach(0..<viewModel.usersId.count, id: \.self) { idx in
                    if let userId = viewModel.usersId[idx] {
                        if let userData = viewModel.gameRoomData.value.usersInGame[userId] {
                            PlayerBoardView(viewModel: viewModel, user: User(id: userData.id, displayName: userData.displayName, profileUrl: userData.profileUrl, history: [], win: 0, lose: 0, currentUserId: nil), userBoardIndex: userData.idx, cardsString: userData.boardCard ?? "", handCardString: userData.handCard ?? "", boardWidth: (proxy.size.width - 37) / 2, boardHeight: proxy.size.height / 3, userReadyOrNot: userData.readyOrNot, isOdd: userData.idx % 2 == 0 ? true : false, showExitAlert: $showExistAlert, existUserId: $existUserId, existUserDisplayName: $existUserDisplayName)
                                .onChange(of: userData) { newValue in
                                    print(#fileID, #function, #line, "- userData: \(userData)")
                                }
                        } else {
                            Rectangle()
                                .fill(Color.bugLight)
                                .frame(width: (proxy.size.width) / 2, height: proxy.size.height / 3)
                        }
                    } else {
                        Rectangle()
                            .fill(Color.bugLight)
                            .frame(width: (proxy.size.width) / 2, height: (proxy.size.height / 3))
                    }
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(Color.bugLight)
            
        }
    }
}

#Preview {
//    GameRoomDetailTopView(usersInGame: .constant([:]), usersId: .constant([]), showExistAlert: .constant(false))
    GameRoomDetailTopView(viewModel: GameRoomDetailViewViewModel(), showExistAlert: .constant(false), existUserId: .constant(""), existUserDisplayName: .constant(""))
}


