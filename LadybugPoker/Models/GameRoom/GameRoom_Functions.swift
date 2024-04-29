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
    
    /// id로 GameRoom 불러옴
    static func fetch(id: String) async throws -> GameRoom {
        guard let documentData = try await Firestore.firestore().collection(path)
            .document(id)
            .getDocument().data() else { throw FirestoreError.noData }
        
        if let gameRoom = GameRoom(data: documentData) {
            return gameRoom
        }
        
        throw FirestoreError.parseError
    }
    
    /// 게임방 리스트 불러옴
    static func fetchList() async throws -> GameRooms {
        let documents = try await Firestore.firestore().collection(path)
            .order(by: "createdAt", descending: true)
            .limit(to: 30)
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
//                throw FirestoreError.parseError
            }
        }
        
        return rooms
    }
    
    /// GameRoom DB 의 UsersInGame 에 내 정보를 추가합니다.
    private static func addMySelfInGame(gameId: String, currentData: [String: UserInGame]) async throws {
        guard let myUserModel = Service.shared.myUserModel else {
            throw GameError.noCurrentUser
        }
        
        var indexes = [0, 1, 2, 3, 4, 5]
        for data in currentData.values {
            indexes.removeAll(where: { $0 == data.idx })
        }
        
        if indexes.isEmpty {
            throw GameError.tooManyUsers
        }
        
        var newData = currentData
        newData[myUserModel.id] = UserInGame(id: myUserModel.id,
                                 readyOrNot: false,
                                 handCard: "",
                                 boardCard: "",
                                 displayName: myUserModel.displayName,
                                 profileUrl: myUserModel.profileUrl,
                                 idx: indexes.first ?? 0,
                                 chat: "")
        
        try await Firestore.firestore().collection(path)
            .document(myUserModel.id)
            .updateData(["usersInGame": newData])
    }
    
    /// GameRoom DB 의 UsersInGame 에서 내 정보를 삭제합니다.
    private static func removeMySelfInGame(gameId: String, currentData: [String: UserInGame]) async throws {
        guard let myUserModel = Service.shared.myUserModel else {
            throw GameError.noCurrentUser
        }
        
        var newData = currentData
        newData[myUserModel.id] = nil
        
        try await Firestore.firestore().collection(path)
            .document(myUserModel.id)
            .updateData(["usersInGame": newData])
    }
    
    /// 새로운 게임방에 입장합니다.
    static func join(id: String) async throws {
        guard let myUserModel = Service.shared.myUserModel else {
            throw GameError.noCurrentUser
        }
        
        let gameRoom = try await fetch(id: id)
        
        /// User 현재 가득찼는지 판단
        if gameRoom.maxUserCount >= gameRoom.usersInGame.count { throw GameError.tooManyUsers }
        try await addMySelfInGame(gameId: id, currentData: gameRoom.usersInGame)
        
        try await User.changeCurrentGameId(id: id)
    }
    
    /// 게임방에서 퇴장합니다.
    static func leave(id: String) async throws {
        guard let myUserModel = Service.shared.myUserModel else {
            throw GameError.noCurrentUser
        }
        
        let gameRoom = try await fetch(id: id) //Refresh
        try await removeMySelfInGame(gameId: id, currentData: gameRoom.usersInGame)
        
        try await User.changeCurrentGameId(id: nil)
    }
}
