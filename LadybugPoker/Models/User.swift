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

enum Player {
    case attacker
    case defender
    case others
}
