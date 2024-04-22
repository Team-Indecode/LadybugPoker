//
//  GameRoomDetailView+ViewModel.swift
//  LadybugPoker
//
//  Created by 김라영 on 2024/04/22.
//

import Foundation
import Combine
import FirebaseFirestore

class GameRoomDetailViewViewModel: ObservableObject {
    let db = Firestore.firestore()
    @Published var gameStatus: GameStatus = .notStarted
    
    @Published var gameRoomData: GameRoom = GameRoom(id: "testId", hostId: "", title: "", password: "", maxUserCount: 0, code: "", users: [], usersInGame: [], whoseTurn: "", whoseGetting: "", selectedCard: .bee, turnStartTime: Date())
    @Published var secondsLeft: Int = 60
    
    @Published var allPlayerReadied: Bool = false
    
    func getGameData() async throws {
       let gameData = db.collection(GameRoom.path).document(gameRoomData.id)
            .addSnapshotListener { doc, error in
                if let doc = doc, doc.exists {
                    print(#fileID, #function, #line, "- doc checking: \(doc)")
                    if let data = try? doc.data(as: GameRoom.self) {
                        print(#fileID, #function, #line, "- data checking⭐️\(data)")
                    }
                }
                
            }
    }
    
    func getUserData(_ userID: String) -> UserInGame? {
        return gameRoomData.usersInGame.first(where: { $0.userId == userID })
    }
    
    func getUserCard(_ isHandCard: Bool) -> [Card] {
//        guard let userId = Service.shared.myUserModel.id else { return [] }
        let userId = Service.shared.myUserModel.id
        
        if let cardString = gameRoomData.usersInGame.first(where: { $0.userId == userId }) {
            if isHandCard {
                return self.stringToCards(cardString.handCard)
            } else {
                return self.stringToCards(cardString.boardCard)
            }
            
        } else {
            return []
        }
    }
    
    func stringToCards(_ cardString: String) -> [Card] {

//        let cardString = gameRoomData.
        let cardStringArr = cardString.components(separatedBy: ",")
        var userCard: [Card] = []
        
        userCard = cardStringArr.map({ cardString in
            return stringToOneCard(cardString)
        })
        
        return userCard
    }
    
    func stringToOneCard(_ cardString: String) -> Card{
        var tempCardString = cardString
        var tempCnt = tempCardString.popLast()
        if let tempCnt = tempCnt {
            if let cnt = Int(String(tempCnt)) {
                switch tempCardString {
                case Bugs.snake.cardString: return Card(bug: .snake, cardCnt: cnt)
                case Bugs.ladybug.cardString: return Card(bug: .ladybug, cardCnt: cnt)
                case Bugs.frog.cardString: return Card(bug: .frog, cardCnt: cnt)
                case Bugs.rat.cardString: return Card(bug: .rat, cardCnt: cnt)
                case Bugs.spider.cardString: return Card(bug: .spider, cardCnt: cnt)
                case Bugs.snail.cardString: return Card(bug: .snail, cardCnt: cnt)
                case Bugs.worm.cardString: return Card(bug: .worm, cardCnt: cnt)
                case Bugs.bee.cardString: return Card(bug: .bee, cardCnt: cnt)
                default: return Card(bug: .snake, cardCnt: cnt)
                }
            } else {
                return Card(bug: .bee, cardCnt: 0)
            }
        } else {
            return Card(bug: .bee, cardCnt: 0)
        }
    }
    
    
}
