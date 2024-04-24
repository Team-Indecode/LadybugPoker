//
//  UserInGame.swift
//  LadybugPoker
//
//  Created by 박진서 on 4/24/24.
//

import Foundation

struct UserInGame: Codable, Hashable {
    /// 게임 시작 준비가 되었는지 안되었는지
    var readyOrNot: Bool
    /// 손에 쥔 카드(ex, Sn3, L2, F3 etc)
    var handCard: String
    /// 깔린 카드(ex, Sn3, L2, F3 etc)
    var boardCard: String
    let userId: String
    /// 닉네임 -> 누구누구 턴입니다 할때 사용
    let displayName: String
    let profileUrl: String?
    
    var toJson: [String: Any] {
        [
            "readyOrNot": readyOrNot,
            "handCard": handCard,
            "boardCard": boardCard,
            "userId": userId,
            "displayName": displayName,
            "profileUrl": profileUrl
        ]
    }
    
    init(readyOrNot: Bool, handCard: String, boardCard: String, userId: String, displayName: String, profileUrl: String?) {
        self.readyOrNot = readyOrNot
        self.handCard = handCard
        self.boardCard = boardCard
        self.userId = userId
        self.displayName = displayName
        self.profileUrl = profileUrl
    }
    
    init?(data: [String: Any]) {
        guard let readyOrNot = data["readyOrNot"] as? Bool,
              let handCard = data["handCard"] as? String,
              let boardCard = data["boardCard"] as? String,
              let userId = data["userId"] as? String,
              let displayName = data["displayName"] as? String else { return nil }
        
        self.readyOrNot = readyOrNot
        self.handCard = handCard
        self.boardCard = boardCard
        self.userId = userId
        self.displayName = displayName
        self.profileUrl = data["profileUrl"] as? String
    }
}
