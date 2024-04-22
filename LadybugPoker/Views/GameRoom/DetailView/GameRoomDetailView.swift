//
//  GameRoomDetailView.swift
//  LadybugPoker
//
//  Created by 박진서 on 4/22/24.
//

import SwiftUI

struct GameRoomDetailView: View {
    var body: some View {
        VStack {
            GameRoomDetailTopView()
            
//            GameRoomDetailBottomView(gameStatus: <#T##Binding<GameStatus>#>, amIReadied: <#T##Binding<Bool>#>, allPlayerReadied: <#T##Bool#>, isHost: <#T##Bool#>, userInTurn: <#T##Binding<UserInGame>#>, myCards: <#T##Binding<[Card]>#>, secondsLeft: <#T##Binding<Int>#>, selectedCardType: <#T##Binding<Bugs?>#>, showCardSelectedPopup: <#T##Binding<Bool>#>)
        }
    }
}

#Preview {
    GameRoomDetailView()
}
