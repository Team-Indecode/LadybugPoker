//
//  GameRoomDetailView+ViewModel.swift
//  LadybugPoker
//
//  Created by 김라영 on 2024/04/22.
//

import Foundation
import Combine
import FirebaseFirestore

class GameRoomDetailViewViewModel: ObservableObject {
    @Published var gameRoomData: GameRoom? = nil
    func getGameData() {
        Firestore.firestore().collection(GameRoom.path)
            .document()
    }
}
