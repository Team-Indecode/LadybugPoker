//
//  History_Functions.swift
//  LadybugPoker
//
//  Created by 박진서 on 5/28/24.
//

import Foundation
import FirebaseFirestore

extension History {
    static func fetchList(id: String, _ last: History?) async throws -> [History] {
        var documents = [QueryDocumentSnapshot]()
        if let last {
            print(last.createdAt, last.title)

            documents = try await Firestore.firestore().collection(User.path)
                .document(id)
                .collection(path)
                .whereField("createdAt", isLessThan: last.createdAt)
                .order(by: "createdAt", descending: true)
                .limit(to: 10)
                .getDocuments()
                .documents
        } else {
            documents = try await Firestore.firestore().collection(User.path)
                .document(id)
                .collection(path)
                .order(by: "createdAt", descending: true)
                .limit(to: 10)
                .getDocuments()
                .documents
        }

        print(#fileID, #function, #line, "- doccousnt: \(documents.count)")
        var histories = [History]()
        print(#fileID, #function, #line, "- document checking⭐️: \(documents)")
        for document in documents {
            print(#fileID, #function, #line, "- document: \(document)")
            if let history = History(data: document.data()) {
//            if let room = try? document.data(as: GameRoom.self) {
                histories.append(history)
            } else {
//                throw FirestoreError.parseError
            }
        }
        
        return histories
    }
}