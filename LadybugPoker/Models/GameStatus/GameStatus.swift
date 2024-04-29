//
//  GameStatus.swift
//  LadybugPoker
//
//  Created by 박진서 on 4/9/24.
//

import Foundation

enum GameStatus: String {
    // 플레이어가 부족한 상태 1~2명
    case notEnoughUsers
    
    // 플레이어가 충분하지만 시작하지 않은 상태
    case notStarted
    
    // 게임 중
    case onAir
    
    // 게임 종료
    case finished
}
