//
//  Path.swift
//  LadybugPoker
//
//  Created by 박진서 on 4/6/24.
//

import Foundation

enum Path: Hashable {
    case createGameRoom
    case signup(email: String, password: String)
    case signin
    case main
<<<<<<< HEAD
    case gameRoom(gameRoomId: String)
=======
    case gameRoom
    case myPage(id: String)
>>>>>>> Signin
}
