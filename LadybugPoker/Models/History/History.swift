//
//  History.swift
//  LadybugPoker
//
//  Created by 박진서 on 5/25/24.
//

import Foundation
import FirebaseFirestore

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

extension History {
    static func fetchList(_ last: History?) async throws -> [History] {
        var documents = [QueryDocumentSnapshot]()
//        if let last {
//            print(last.createdAt, last.title)
//            
//            documents = try await Firestore.firestore().collection(path)
//                .whereField("createdAt", isLessThan: last.createdAt)
//                .order(by: "createdAt", descending: true)
//                .limit(to: 10)
//                .getDocuments()
//                .documents
//        } else {
//            documents = try await Firestore.firestore().collection(path)
//                .order(by: "createdAt", descending: true)
//                .limit(to: 10)
//                .getDocuments()
//                .documents
//        }
//        
//        print(#fileID, #function, #line, "- doccousnt: \(documents.count)")
        var histories = [History]()
//        print(#fileID, #function, #line, "- document checking⭐️: \(documents)")
//        for document in documents {
//            print(#fileID, #function, #line, "- document: \(document)")
//            if let room = GameRoom(data: document.data()) {
////            if let room = try? document.data(as: GameRoom.self) {
//                print(room.id, room.createdAt)
//                histories.append(room)
//            } else {
////                throw FirestoreError.parseError
//            }
//        }
        
        return histories
    }
}
