//
//  User.swift
//  LadybugPoker
//
//  Created by 박진서 on 4/5/24.
//

import Foundation

struct User: Codable, Identifiable {
    static let path = "USERS"
    
    let id: String
    let displayName: String
    let profileUrl: String?
    let history: [String]
    var currentUserId: String?
}

/// 플레이어 역할(공격자, 수비자, 둘다 아님)
enum Player {
    /// 공격자
    case attacker
    /// 수비자
    case defender
    /// 그 외
    case others
}

struct History: Codable, Identifiable {
    static let path = "HISTORY"
    
    let id: String
    let title: String
    let isWinner: Bool
    let maxUserCount: Int
    let userCount: Int
    
    var toJson: [String: Any] {
        [
            "id": id,
            "title": title,
            "isWinner": isWinner,
            "maxUserCount": maxUserCount,
            "userCount": userCount
        ]
    }
}
