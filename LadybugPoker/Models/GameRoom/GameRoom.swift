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
    /// 공격자가 실제로 선택한 벌레
    var selectedCard: Bugs?
    /// 턴 시작 시간
    let turnStartTime: String?
    /// 공격자가 수비자에게 말한 벌레
    let questionCard: Bugs?
    let attackers: [Int]
    let createdAt: String
    let turnTime: Int
    
    var toJson: [String: Any] {
        var userGameData: [String: Any] = [:]
        for data in usersInGame {
            userGameData[data.key] = data.value.toJson
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
            "turnStartTime" : turnStartTime,
            "questionCard" : questionCard,
            "attackers" : attackers,
            "createdAt" : createdAt,
            "turnTime" : turnTime
        ]
    }
    
    init(id: String, hostId: String, title: String, password: String?, maxUserCount: Int, code: String, usersInGame: [String: UserInGame], whoseTurn: String? = nil, whoseGetting: String?, selectedCard: Bugs? = nil, turnStartTime: String?, questionCard: Bugs? = nil, attackers: [Int], createdAt: String, turnTime: Int) {
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
        self.questionCard = questionCard
        self.attackers = attackers
        self.createdAt = createdAt
        self.turnTime = turnTime
    }
    
    init?(data: [String: Any]) {
        guard let id = data["id"] as? String else {
            print(#function, #fileID, "wrongID")
            return nil
        }
        
        guard let hostId = data["hostId"] as? String else {
            print(#function, #fileID, "wrong Host Id")
            return nil
        }
        
        guard let title = data["title"] as? String else {
            print(#function, #fileID, "wrong Title")
            return nil
        }
        
        guard let maxUserCount = data["maxUserCount"] as? Int else {
            print(#function, #fileID, "wrong max user count")
            return nil
        }
        
        guard let code = data["code"] as? String else {
            print(#function, #fileID, "wrong code")
            
            return nil
        }
        
        guard let attackers = data["attackers"] as? [Int] else {
            return nil
        }
        
        guard let createdAt = data["createdAt"] as? String else {
            return nil
        }
        
        guard let turnTime = data["turnTime"] as? Int else {
            return nil
        }
        
        self.id = id
        self.hostId = hostId
        self.title = title
        self.maxUserCount = maxUserCount
        self.code = code
        self.password = data["password"] as? String
        self.whoseTurn = nil
        //TODO - users in game 처리
        self.usersInGame = [:]
        self.whoseGetting = nil
        self.turnStartTime = nil
        self.questionCard = nil
        self.attackers = attackers
        self.createdAt = createdAt
        self.turnTime = turnTime
    }
}
