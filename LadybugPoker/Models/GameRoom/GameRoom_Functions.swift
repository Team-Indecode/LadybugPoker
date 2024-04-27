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
    
    /// 게임방 리스트 불러옴
    static func fetchList() async throws -> GameRooms {
        let documents = try await Firestore.firestore().collection(path)
            .getDocuments()
            .documents
        print(#fileID, #function, #line, "- doccousnt: \(documents.count)")
        var rooms = [GameRoom]()
        print(#fileID, #function, #line, "- document checking⭐️: \(documents)")
        for document in documents {
            print(#fileID, #function, #line, "- document: \(document)")
            if let room = GameRoom(data: document.data()) {
//            if let room = try? document.data(as: GameRoom.self) {
                print(room.id)
                rooms.append(room)
            } else {
                print("wrong data")
            }
        }
        
        return rooms
    }
}
