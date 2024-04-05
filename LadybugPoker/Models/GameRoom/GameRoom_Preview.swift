//
//  GameRoom_Preview.swift
//  LadybugPoker
//
//  Created by 박진서 on 4/5/24.
//

import Foundation

extension GameRoom {
    static var preview: Self {
        GameRoom(id: "testId", password: "123456", code: "A2F5E2", users: [])
    }
}
