//
//  History.swift
//  LadybugPoker
//
//  Created by 박진서 on 5/25/24.
//

import Foundation

struct History: Codable, Identifiable {
    static let path = "HISTORY"
    
    let id: String
    let title: String
    let isWinner: Bool
    let maxUserCount: Int
    let userCount: Int
    let createdAt: String
    
    var toJson: [String: Any] {
        [
            "id": id,
            "title": title,
            "isWinner": isWinner,
            "maxUserCount": maxUserCount,
            "userCount": userCount,
            "createdAt": createdAt
        ]
    }
    
    init(id: String, title: String, isWinner: Bool, maxUserCount: Int, userCount: Int, createdAt: String) {
        self.id = id
        self.title = title
        self.isWinner = isWinner
        self.maxUserCount = maxUserCount
        self.userCount = userCount
        self.createdAt = createdAt
    }
    
    init?(data: [String: Any]) {
        guard let id = data["id"] as? String,
              let title = data["title"] as? String,
              let isWinner = data["isWinner"] as? Bool,
              let maxUserCount = data["maxUserCount"] as? Int,
              let userCount = data["userCount"] as? Int,
              let createdAt = data["createdAt"] as? String else {
            return nil
        }
        
        self.id = id
        self.title = title
        self.isWinner = isWinner
        self.maxUserCount = maxUserCount
        self.userCount = userCount
        self.createdAt = createdAt
    }
}

