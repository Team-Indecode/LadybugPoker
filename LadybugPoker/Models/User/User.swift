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
    var profileUrl: String?
    let history: [String]
    let win: Int
    let lose: Int
    var currentUserId: String?
}

/// 플레이어 역할(공격자, 수비자, 둘다 아님)
enum PlayerRole {
    /// 공격자
    case attacker
    /// 수비자
    case defender
    /// 그 외
    case others
}

