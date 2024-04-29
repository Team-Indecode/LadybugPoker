//
//  GameError.swift
//  LadybugPoker
//
//  Created by 박진서 on 4/29/24.
//

import Foundation

enum GameError: Error {
    /// 로그인된 유저가 없음.
    case noCurrentUser
    
    /// 방이 가득참
    case tooManyUsers
}
