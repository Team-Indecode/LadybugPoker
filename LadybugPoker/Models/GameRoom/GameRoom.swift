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
    /// 유저들의 게임 데이터
    var usersInGame: [String: UserInGame]
    /// 누구 턴인지
    var whoseTurn: String?
    /// 누구에게 카드를 건냈는지
    let whoseGetting: String?
    /// 어떤 카드를 줬는지
    var selectedCard: Bugs?
    /// 턴 시작 시간
    let turnStartTime: Date?
    
    var toJson: [String: Any] {
        var userGameData: [String: Any] = [:]
        for data in usersInGame {
            userGameData[data.key] = data.value
        }
        
        return [
            "id": id,
            "hostId": hostId,
            "title": title,
            "password": password,
            "maxUserCount": maxUserCount,
            "code": code,
            "usersInGame": userGameData,
            "whoseTurn": whoseTurn,
            "whoseGetting" : whoseGetting,
            "selectedCard" : selectedCard?.rawValue,
            "turnStartTime" : turnStartTime
        ]
    }
    
    init(id: String, hostId: String, title: String, password: String?, maxUserCount: Int, code: String, usersInGame: [String: UserInGame], whoseTurn: String? = nil, whoseGetting: String?, selectedCard: Bugs? = nil, turnStartTime: Date?) {
        self.id = id
        self.hostId = hostId
        self.title = title
        self.password = password
        self.maxUserCount = maxUserCount
        self.code = code
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
        self.password = data["password"] as? String
        self.whoseTurn = nil
        self.usersInGame = [:]
        self.whoseGetting = nil
        self.turnStartTime = nil
    }
}
