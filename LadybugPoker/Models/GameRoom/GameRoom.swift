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
    let hostId: String
    let title: String
    let password: String?
    let maxUserCount: Int
    let code: String
    let users: [String]
    
    
    var toJson: [String: Any] {
        [
            "hostId": hostId,
            "title": title,
            "password": password,
            "maxUserCount": maxUserCount,
            "code": code,
            "users": users
        ]
    }
}
