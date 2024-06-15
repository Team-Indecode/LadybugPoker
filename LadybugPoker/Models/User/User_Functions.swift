//
//  User_Functions.swift
//  LadybugPoker
//
//  Created by 박진서 on 4/22/24.
//

import FirebaseFirestore

extension User {
    static func create(id: String, displayName: String) async throws -> User {
        try await Firestore
            .firestore()
            .collection(path)
            .document(id)
            .setData([
                "id": id,
                "displayName": displayName,
                "history": [],
                "profileUrl": nil,
                "currentGameId": nil,
                "win": 0,
                "lose": 0
            ])
        
        return User(id: id, displayName: displayName, history: [], win: 0, lose: 0)
    }
    
    static func fetch(id: String) async throws -> User {
        let document = try await Firestore.firestore().collection(path)
            .document(id)
            .getDocument()
        
        guard let data = document.data() else { throw FirestoreError.noData }
        
        guard let displayName = data["displayName"] as? String,
              let id = data["id"] as? String,
              let win = data["win"] as? Int,
              let lose = data["lose"] as? Int,
              let history = data["history"] as? [String] else {
                  throw UserError.invalidData
              }
        
        let profileUrl = data["profileUrl"] as? String
        let currentGameId = data["currentGameId"] as? String
        
        return User(id: id,
                    displayName: displayName,
                    profileUrl: profileUrl,
                    history: history,
                    win: win,
                    lose: lose,
                    currentUserId: currentGameId)
    }
    
    /// CurrentGameId 를 변경합니다.
    static func changeCurrentGameId(id: String?) async throws {
        guard let user = Service.shared.myUserModel else { throw GameError.noCurrentUser }
        
        try await Firestore.firestore().collection(path)
            .document(user.id).updateData(["currentGameId": id])
        
        Service.shared.myUserModel.currentUserId = id
    }
    
    static func changeProfileUrl(url: String) async throws {
        guard let user = Service.shared.myUserModel else { throw GameError.noCurrentUser }
        
        try await Firestore.firestore().collection(path)
            .document(user.id).updateData(["profileUrl": url])
        
        Service.shared.myUserModel.profileUrl = url
    }
    
    static func random() -> User {
        let randomNumber = Int.random(in: 0..<100000)
        let names = [
            "용산구무당이", "철통수비", "모든걸뚫는창", "알록무당당", "심리학자무당", "커피마스터",
            "사륜안개안", "인디코오드", "PPP", "외로운게이머", "1호테스터", "챌린저", "나진짜다맞춰",
            "어디덤벼봐", "날막지모텡", "NPC", "마스터게이머"
        ]
        
        let images = [
            "https://cdn.pixabay.com/photo/2022/01/07/01/21/girl-6920625_1280.jpg",
            "https://cdn.pixabay.com/photo/2017/11/02/00/34/parrot-2909828_1280.jpg",
            "https://cdn.pixabay.com/photo/2014/08/12/20/06/cards-416960_1280.jpg",
            "https://cdn.pixabay.com/photo/2019/09/20/10/44/joker-4491449_1280.jpg",
            "https://cdn.pixabay.com/photo/2018/12/12/10/21/cognac-3870510_1280.jpg",
            "https://cdn.pixabay.com/photo/2016/03/14/16/20/jeans-1255756_1280.jpg",
            "https://cdn.pixabay.com/photo/2021/03/01/19/03/ladybug-6060599_1280.jpg",
            "https://cdn.pixabay.com/photo/2019/06/19/03/10/ladybug-4283783_1280.jpg",
            "https://cdn.pixabay.com/photo/2019/08/06/07/52/lotus-4387619_1280.jpg",
            "https://cdn.pixabay.com/photo/2019/06/18/00/34/ladybug-4281182_1280.jpg",
            "https://cdn.pixabay.com/photo/2022/03/31/11/28/insect-7102809_1280.jpg",
            "https://cdn.pixabay.com/photo/2021/06/25/17/51/ladybug-6364312_1280.jpg",
            "https://cdn.pixabay.com/photo/2022/06/19/08/56/ladybug-7271402_1280.jpg",
            "https://cdn.pixabay.com/photo/2022/06/20/13/52/ladybug-7273814_1280.jpg",
            "https://cdn.pixabay.com/photo/2023/06/15/07/53/ladybug-8064737_1280.jpg",
            "https://cdn.pixabay.com/photo/2019/07/17/15/08/ladybug-4344164_1280.jpg"
        ]
        
        return User(id: "testId\(randomNumber)", displayName: names.randomElement() ?? "", profileUrl: images.randomElement(), history: [], win: 0, lose: 0)
    }
}
