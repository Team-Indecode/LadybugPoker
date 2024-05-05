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
    var handCard: String?
    /// 깔린 카드(ex, Sn3, L2, F3 etc)
    var boardCard: String?
    /// 닉네임 -> 누구누구 턴입니다 할때 사용
    let displayName: String
    let profileUrl: String?
    /// 무조건 인덱스가 수정되지 않기 때문에 -> 게임방의 데이터가 변경될때마다 유저들의
    let idx: Int
    var chat: String?
    
    var toJson: [String: Any] {
        [
            "id": id,
            "readyOrNot": readyOrNot,
            "handCard": handCard,
            "boardCard": boardCard,
            "displayName": displayName,
            "profileUrl": profileUrl,
            "idx": idx,
            "chat": chat
        ]
    }
    
    init(id: String, readyOrNot: Bool, handCard: String?, boardCard: String?, displayName: String, profileUrl: String?, idx: Int, chat: String?) {
        self.id = id
        self.readyOrNot = readyOrNot
        self.handCard = handCard
        self.boardCard = boardCard
        self.displayName = displayName
        self.profileUrl = profileUrl
        self.idx = idx
        self.chat = chat
    }
    
    init?(data: [String: Any]) {
        guard let id = data["id"] as? String,
              let readyOrNot = data["readyOrNot"] as? Bool,
              let displayName = data["displayName"] as? String,
              let idx = data["idx"] as? Int else { return nil }
              
        
        self.id = id
        self.readyOrNot = readyOrNot
        self.handCard = data["handCard"] as? String
        self.boardCard = data["boardCard"] as? String
        self.displayName = displayName
        self.profileUrl = data["profileUrl"] as? String
        self.idx = idx
        self.chat = data["chat"] as? String
    }
}
