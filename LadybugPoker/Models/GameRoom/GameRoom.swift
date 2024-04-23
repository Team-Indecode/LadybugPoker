//
//  GameRoom.swift
//  LadybugPoker
//
//  Created by 박진서 on 4/5/24.
//

import Foundation

struct GameRoom: Codable, Identifiable, Equatable {
    static let path = "GAMEROOMS"
    
    let id: String
    /// 누가 방장인지
    let hostId: String
    let title: String
    let password: String?
    let maxUserCount: Int
    /// 방 식별자
    let code: String
    /// userId
//    let users: [String]
    /// 유저들의 게임 데이터
    var usersInGame: [UserInGame]
    /// 누구 턴인지
    var whoseTurn: String?
    /// 누구에게 카드를 건냈는지
    let whoseGetting: String?
    /// 어떤 카드를 줬는지
    var selectedCard: Bugs?
    /// 턴 시작 시간
    let turnStartTime: Date?
    
    var toJson: [String: Any] {
        [
            "id": id,
            "hostId": hostId,
            "title": title,
            "password": password,
            "maxUserCount": maxUserCount,
            "code": code,
//            "users": users,
            "usersInGame": usersInGame.map { $0.toJson },
            "whoseTurn": whoseTurn,
            "whoseGetting" : whoseGetting,
            "selectedCard" : selectedCard?.rawValue,
            "turnStartTime" : turnStartTime
        ]
    }
    
    init(id: String, hostId: String, title: String, password: String?, maxUserCount: Int, code: String, usersInGame: [UserInGame], whoseTurn: String? = nil, whoseGetting: String?, selectedCard: Bugs? = nil, turnStartTime: Date?) {
        self.id = id
        self.hostId = hostId
        self.title = title
        self.password = password
        self.maxUserCount = maxUserCount
        self.code = code
//        self.users = users
        self.usersInGame = usersInGame
        self.whoseTurn = whoseTurn
        self.whoseGetting = whoseGetting
        self.selectedCard = selectedCard
        self.turnStartTime = turnStartTime
    }
    
    init?(data: [String: Any]) {
        guard let id = data["id"] as? String,
              let hostId = data["hostId"] as? String,
              let title = data["title"] as? String,
              let maxUserCount = data["maxUserCount"] as? Int,
              let code = data["code"] as? String,
              let usersInGame = data["usersInGame"] as? [String] else { return nil }
        
        self.id = id
        self.hostId = hostId
        self.title = title
        self.maxUserCount = maxUserCount
        self.code = code
//        self.users = users
        self.password = data["password"] as? String
        self.whoseTurn = nil
        self.usersInGame = []
        self.whoseGetting = nil
        self.turnStartTime = nil
    }
}

struct UserInGame: Codable, Hashable {
    /// 게임 시작 준비가 되었는지 안되었는지
    var readyOrNot: Bool
    /// 손에 쥔 카드(ex, Sn3, L2, F3 etc)
    var handCard: String
    /// 깔린 카드(ex, Sn3, L2, F3 etc)
    var boardCard: String
    let userId: String
    /// 닉네임 -> 누구누구 턴입니다 할때 사용
    let displayName: String
    let profileUrl: String?
    
    var toJson: [String: Any] {
        [
            "readyOrNot": readyOrNot,
            "handCard": handCard,
            "boardCard": boardCard,
            "userId": userId,
            "displayName": displayName,
            "profileUrl": profileUrl
        ]
    }
    
    init(readyOrNot: Bool, handCard: String, boardCard: String, userId: String, displayName: String, profileUrl: String?) {
        self.readyOrNot = readyOrNot
        self.handCard = handCard
        self.boardCard = boardCard
        self.userId = userId
        self.displayName = displayName
        self.profileUrl = profileUrl
    }
    
    init?(data: [String: Any]) {
        guard let readyOrNot = data["readyOrNot"] as? Bool,
              let handCard = data["handCard"] as? String,
              let boardCard = data["boardCard"] as? String,
              let userId = data["userId"] as? String,
              let displayName = data["displayName"] as? String else { return nil }
        
        self.readyOrNot = readyOrNot
        self.handCard = handCard
        self.boardCard = boardCard
        self.userId = userId
        self.displayName = displayName
        self.profileUrl = data["profileUrl"] as? String
    }
}

