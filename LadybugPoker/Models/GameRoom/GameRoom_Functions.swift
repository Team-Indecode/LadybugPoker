//
//  GameRoom_Functions.swift
//  LadybugPoker
//
//  Created by 박진서 on 4/6/24.
//

import FirebaseFirestore
import Foundation

extension GameRoom {
    static func create(model: GameRoom) async throws {
        try await Firestore.firestore().collection(path)
            .document(model.id)
            .setData(model.toJson)
    }
}
