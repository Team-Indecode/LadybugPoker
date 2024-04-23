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
        var model = model
        model.usersInGame.append(UserInGame(readyOrNot: true,
                                            handCard: "",
                                            boardCard: "",
                                            userId: Service.shared.myUserModel.id, 
                                            displayName: Service.shared.myUserModel.displayName,
                                            profileUrl: Service.shared.myUserModel.profileUrl))
        
        try await Firestore.firestore().collection(path)
            .document(model.id)
            .setData(model.toJson)
    }
    
    static func fetchList() async throws -> GameRooms {
        let documents = try await Firestore.firestore().collection(path)
            .getDocuments()
            .documents
        var rooms = [GameRoom]()
        
        for document in documents {
            if let room = GameRoom(data: document.data()) {
                print(room.id)
                rooms.append(room)
            } else {
                print("wrong data")
            }
        }
        
        return rooms
    }
}
