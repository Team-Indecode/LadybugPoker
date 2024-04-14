//
//  GameRoom.swift
//  LadybugPoker
//
//  Created by 박진서 on 4/5/24.
//

import Foundation

struct GameRoom: Codable, Identifiable {
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
    let users: [String]
    /// 유저들의 게임 데이터
    let usersInGame: [UserInGame]
    /// 누구 턴인지
    let whoseTurn: String
    /// 누구에게 카드를 건냈는지
    let whoseGetting: String
    /// 어떤 카드를 줬는지
    let selectedCard: Bugs
    /// 턴 시작 시간
    let turnStartTime: Date
    
    var toJson: [String: Any] {
        [
            "hostId": hostId,
            "title": title,
            "password": password,
            "maxUserCount": maxUserCount,
            "code": code,
            "users": users,
            "usersInGame": usersInGame,
            "whoseTurn": whoseTurn,
            "whoseGetting" : whoseGetting,
            "selectedCard" : selectedCard,
            "turnStartTime" : turnStartTime
        ]
    }
}

struct UserInGame: Codable, Hashable {
    /// 게임 시작 준비가 되었는지 안되었는지
    let readyOrNot: Bool
    /// 손에 쥔 카드
    let handCard: [Card]
    /// 깔린 카드
    let boardCard: [Card]
    let userId: String
}

