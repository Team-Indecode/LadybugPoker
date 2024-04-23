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
    
    @Published var gameRoomData: GameRoom = GameRoom(id: "testId", hostId: "", title: "", password: "", maxUserCount: 0, code: "", usersInGame: [], whoseTurn: "", whoseGetting: "", selectedCard: .bee, turnStartTime: Date())
    @Published var secondsLeft: Int = 60
    
    @Published var allPlayerReadied: Bool = false

    
    /// 해당 게임방의 데이터를 가지고 온다
    func getGameData() async throws {
       db.collection("GAMEROOMS").document("testId")
            .addSnapshotListener { doc, error in
                if let doc = doc, doc.exists {
                    if let data = try? doc.data(as: GameRoom.self) {
                        self.gameRoomData = data
                        print(#fileID, #function, #line, "- self.gameRoomData: \(self.gameRoomData)")
                    } else {
                        print(#fileID, #function, #line, "- wrong data")
                    }
                }
                
            }
    }
    
    /// 유저가 준비완료가 됬음을 보내줌
    func sendIamReady() {
        db.collection(GameRoom.path).document(gameRoomData.id)
            .updateData(["users" : true]) { error in
                print(#fileID, #function, #line, "- error: \(error?.localizedDescription)")
                
            }
    }
    
    /// userID에 해당하는 유저 데이터를 가지고 온다
    func getUserData(_ userID: String) -> UserInGame? {
        return gameRoomData.usersInGame.first(where: { $0.userId == userID })
    }
    
    /// 유저의 카드 가지고 오기(손에 가지고 있는 카드, 게임판에 깔려있는 카드)
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
    
    /// string으로 오는 card를 Card strcut로 변경(ex. f1, l2)
    func stringToCards(_ cardString: String) -> [Card] {
        if cardString == "" {
            return []
        }
        let cardStringArr = cardString.components(separatedBy: ",")
        var userCard: [Card] = []
        
        userCard = cardStringArr.map({ cardString in
            return stringToOneCard(cardString)
        })
        
        return userCard
    }
    
    /// f1을 Card(bug: .frog, cardCnt: 3)으로 변경
    func stringToOneCard(_ cardString: String) -> Card {
        var tempCardString = cardString
        let tempCnt = tempCardString.popLast()
        print(#fileID, #function, #line, "- tempCnt: \(tempCnt)")
        if let tempCnt = tempCnt {
            if let cnt = Int(String(tempCnt)) {
                print(#fileID, #function, #line, "- cnt: \(cnt)")
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
