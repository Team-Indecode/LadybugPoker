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
            .addDocument(data: [
                "id": id,
                "displayName": displayName,
                "history": [],
                "profileUrl": nil
            ])
    }
}
