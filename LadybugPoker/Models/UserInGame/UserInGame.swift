//
//  UserInGame.swift
//  LadybugPoker
//
//  Created by 박진서 on 4/24/24.
//

import Foundation

struct UserInGame: Codable, Hashable {
    let id: String
    /// 게임 시작 준비가 되었는지 안되었는지
    var readyOrNot: Bool
    /// 손에 쥔 카드(ex, Sn3, L2, F3 etc)
    var handCard: String
    /// 깔린 카드(ex, Sn3, L2, F3 etc)
    var boardCard: String
    /// 닉네임 -> 누구누구 턴입니다 할때 사용
    let displayName: String
    let profileUrl: String?
    
    var toJson: [String: Any] {
        [
            "id": id,
            "readyOrNot": readyOrNot,
            "handCard": handCard,
            "boardCard": boardCard,
            "displayName": displayName,
            "profileUrl": profileUrl
        ]
    }
    
    init(id: String, readyOrNot: Bool, handCard: String, boardCard: String, displayName: String, profileUrl: String?) {
        self.id = id
        self.readyOrNot = readyOrNot
        self.handCard = handCard
        self.boardCard = boardCard
        self.displayName = displayName
        self.profileUrl = profileUrl
    }
    
    init?(data: [String: Any]) {
        guard let id = data["id"] as? String,
              let readyOrNot = data["readyOrNot"] as? Bool,
              let handCard = data["handCard"] as? String,
              let boardCard = data["boardCard"] as? String,
              let displayName = data["displayName"] as? String else { return nil }
        
        self.id = id
        self.readyOrNot = readyOrNot
        self.handCard = handCard
        self.boardCard = boardCard
        self.displayName = displayName
        self.profileUrl = data["profileUrl"] as? String
    }
}