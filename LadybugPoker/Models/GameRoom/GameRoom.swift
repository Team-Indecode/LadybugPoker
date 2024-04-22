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
    var whoseTurn: String?
    /// 누구에게 카드를 건냈는지
    let whoseGetting: String?
    /// 어떤 카드를 줬는지
    var selectedCard: Bugs?
    /// 턴 시작 시간
    let turnStartTime: Date?
    
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
    var readyOrNot: Bool
    /// 손에 쥔 카드(ex, Sn3, L2, F3 etc)
    var handCard: String
    /// 깔린 카드(ex, Sn3, L2, F3 etc)
    var boardCard: String
    let userId: String
    /// 닉네임 -> 누구누구 턴입니다 할때 사용
    let displayName: String
}

