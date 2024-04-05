//
//  GameRoom.swift
//  LadybugPoker
//
//  Created by 박진서 on 4/5/24.
//

import Foundation

struct GameRoom: Codable, Identifiable {
    let id: String
    let password: String?
    let code: String
    let users: [User]
    
}
