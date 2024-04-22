//
//  GameRoomDetailView.swift
//  LadybugPoker
//
//  Created by 박진서 on 4/22/24.
//

import SwiftUI

struct GameRoomDetailView: View {
    @StateObject var viewModel = GameRoomDetailViewViewModel()
    @State private var showCardSelectedPopup: Bool = false
    @State private var amIReadied: Bool = false
    @State private var isHost: Bool = false
    @State private var myCards: [Card] = []
//    @State private var turnsStartTime:
    var body: some View {
        VStack {
            GameRoomDetailTopView()
            GameRoomDetailBottomView(amIReadied: $amIReadied, myCards: $myCards, showCardSelectedPopup: $showCardSelectedPopup)
        }
        .onAppear {
            myCards = viewModel.getUserCard(true)
        }
        
    }
}

#Preview {
    GameRoomDetailView()
}


