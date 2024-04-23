//
//  User_Functions.swift
//  LadybugPoker
//
//  Created by 박진서 on 4/22/24.
//

import FirebaseFirestore

extension User {
    static func create(id: String, displayName: String) async throws {
        try await Firestore.firestore().collection(path)
            .document(id)
            .setData([
                "id": id,
                "displayName": displayName,
                "history": [],
                "profileUrl": nil
            ])
    }
    
    static func fetch(id: String) async throws -> User {
        let document = try await Firestore.firestore().collection(path)
            .document(id)
            .getDocument()
        
        guard let data = document.data() else { throw FirestoreError.noData }
        
        guard let displayName = data["displayName"] as? String,
              let id = data["id"] as? String,
              let history = data["history"] as? [String] else {
                  throw UserError.invalidData
              }
        
        let profileUrl = data["profileUrl"] as? String
        
        return User(id: id,
                    displayName: displayName,
                    profileUrl: profileUrl,
                    history: history)
    }
}
