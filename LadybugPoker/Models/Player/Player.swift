//
//  Player.swift
//  LadybugPoker
//
//  Created by 김라영 on 2024/06/06.
//

import Foundation

struct Player: Codable, Hashable {
    let id: String
    let profileUrl: String?
    let displayName: String
    
    var toJson: [String: Any] {
        [
            "id": id,
            "profileUrl": profileUrl,
            "displayName": displayName
        ]
    }
    
    
    init(id: String, profileUrl: String?, displayName: String) {
        self.id = id
        self.profileUrl = profileUrl
        self.displayName = displayName
    }
    
    init?(data: [String: Any]) {
        guard let id = data["id"] as? String,
              let displayName = data["displayName"] as? String else { return nil }
        
        self.id = id
        self.displayName = displayName
        self.profileUrl = data["profileUrl"] as? String
    }
}
