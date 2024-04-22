//
//  User.swift
//  LadybugPoker
//
//  Created by 박진서 on 4/5/24.
//

import Foundation

struct User: Codable, Identifiable {
    let id: String
    let displayName: String
    let profileUrl: String?
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
