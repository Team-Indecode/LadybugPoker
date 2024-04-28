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
    
    @Published var gameRoomData = CurrentValueSubject<GameRoom, Never>(GameRoom(id: "", hostId: "", title: "", password: "", maxUserCount: 0, code: "", usersInGame: [:], whoseTurn: nil, whoseGetting: nil, selectedCard: nil, turnStartTime: "", questionCard: nil, attackers: [], createdAt: "", turnTime: 0))

    /// userIdx와 userId
    @Published var usersId: [Int : String] = [:]
    /// 남은 시간
    @Published var secondsLeft: Int = 60
    
    @Published var allPlayerReadied: Bool = false
    /// 유저 채팅[유저 idx : 유저 채팅]
    @Published var usersChat: [Int : String] = [:]
    @Published var gameBottomType: GameBottomType? = nil
    var timer: Timer?
    
    /// 해당 게임방의 데이터를 가지고 온다
    func getGameData(_ gameRoomId: String) async throws {
        db.collection(GameRoom.path).document(gameRoomId)
            .addSnapshotListener { doc, error in
                if let doc = doc, doc.exists {
                    if let data = try? doc.data(as: GameRoom.self) {
                        self.gameRoomData.send(data)
                        self.getUsersId(data.usersInGame)
                        print(#fileID, #function, #line, "- self.gameRoomData: \(self.gameRoomData.value)")
                        self.allPlayerIsReadyChecking(data.usersInGame)
                    } else {
                        print(#fileID, #function, #line, "- wrong data")
                    }
                }
                
            }
    }
    
    /// 이거 순서를 단순히 그냥 순서를 가지고 오는 것이 아니라 UserInGame의 idx순서 대로 가져와야 한다
    // 1. tuple을 만들어서(userIdx, userId)이런식으로 만들어서 userIdx를 오름차순으로 정렬한다
    // 2. 그런다음 userId만 그 tuple에서 추출한다
    func getUsersId(_ usersInGame: [String : UserInGame]) {
        usersInGame.forEach { (key: String, value: UserInGame) in
            usersId[value.idx] = key
        }
    }
    
    /// 모든 유저가 게임 시작 준비가 됬는지를 판단한다
    /// - Parameter usersInGame
    func allPlayerIsReadyChecking(_ usersInGame: [String : UserInGame]) {
        var allReadyOrNot: Bool = true
        usersInGame.forEach { (key: String, value: UserInGame) in
            if !value.readyOrNot {
                allReadyOrNot = false
            }
        }
        
        self.allPlayerReadied = allReadyOrNot
        print(#fileID, #function, #line, "- allPlayerReadied checking: \(allPlayerReadied)")
    }
    
    /// 게임 시작(처음 게임 시작할 떄 카드 분배)
    func cardDistribute() {
        self.gameStatus = .onAir
        var allCards: [Bugs] = []
        Bugs.allCases.forEach { bug in
            allCards.append(contentsOf: [Bugs](repeating: bug, count: 8))
        }
        allCards.shuffle()

        /// 게임에 참가하는 총 유저 수
        let userCnt = self.gameRoomData.value.usersInGame.count
        /// 한 유저 당 가지는 카드 개수
        let oneUserCardCount = allCards.count / self.gameRoomData.value.usersInGame.count
        userCard(oneUserCardCount, allCards, userCnt)
    }
    
    
    /// 한 유저가 처음에 손에 가지고 있는 카드
    /// - Parameters:
    ///   - userCardCnt: 유저가 처음에 가질 최소 카드 수
    ///   - allCards: 전체 벌레 카드들
    ///   - userCnt: 게임에 참가한 총 유저 수
    func userCard(_ userCardCnt: Int, _ allCards: [Bugs], _ userCnt: Int) {
        var usersCard: [[Bugs]] = []
        var usersCardString: [String] = []
        
        // 카드 분배
        for i in stride(from: 0, to: userCnt * userCardCnt, by: userCardCnt) {
            usersCard.append(Array(allCards[i..<i+userCardCnt]))
        }
        
        // 유저 수가 3, 5, 6 -> 카드가 정확히 같은 개수로 분배되지 않음
        // 그래서 남은 카드를 랜덤으로 분배해준다
        if allCards.count % userCardCnt != 0 {
            var restCard: [Bugs] = []
            for i in stride(from: userCnt * userCardCnt, to: allCards.count, by: 1) {
                restCard.append(allCards[i])
            }
            for i in 0..<restCard.count {
                usersCard[i % userCnt].append(restCard[i])
            }
        }
        
        // Bugs배열을 카드String으로 만들어줌
        usersCardString = bugsTocardString(usersCard)
        
        print(#fileID, #function, #line, "- usersCard: \(usersCard)")
        print(#fileID, #function, #line, "- usersCardString⭐️: \(usersCardString)")
        usersHandCardSetting(usersCardString)
    }
    
    func bugsTocardString(_ usersCard: [[Bugs]]) -> [String] {
        var usersCardString: [String] = []
        
        usersCard.forEach { bugs in
            var bugCnt: [Bugs : Int] = [.bee : 0, .frog : 0, .ladybug : 0, .rat : 0, .snail : 0, .snake : 0, .spider : 0, .worm : 0]
            var bugCntString: String = ""
            bugs.forEach { bug in
                bugCnt[bug]! += 1
            }
            Array(zip(0..<bugCnt.count, bugCnt)).forEach { (index, bugDic) in
                let (key, value) = bugDic
                bugCntString += index == bugCnt.count - 1 ? "\(key.cardString)\(value)" : "\(key.cardString)\(value),"
            }
            usersCardString.append(bugCntString)
        }
        
        return usersCardString
    }
    
    /// 유저에 랜덤으로 벌레String을 넣어줌
    /// - Parameter bugCardString: 벌레String(ex. Sn1, L2)
    func usersHandCardSetting(_ bugCardString: [String]) {
        var bugCardString = bugCardString
        var usersCardString: [String : String] = [:]
        
        for index in 0..<6 {
            if let userId = self.usersId[index] {
                usersCardString[userId] = bugCardString.popLast()
            }
        }
        
        self.gameRoomData.value.usersInGame.values.forEach { userInGame in
            var userInGame = userInGame
            userInGame.handCard = usersCardString[userInGame.id] ?? ""
            userInGameUpdate(userInGame, userInGame.id, .gameStart)
        }
    }
 
    /// 유저가 준비완료가 됬음을 보내줌
    func sendIamReady() {
        let userInGame = gameRoomData.value.usersInGame[Service.shared.myUserModel.id]

        guard var userInGame = userInGame else { return }
        userInGame.readyOrNot = !userInGame.readyOrNot
        
        userInGameUpdate(userInGame, userInGame.id, .sendUserReady)
    }
    
    func userInGameUpdate(_ userInGame: UserInGame, _ userId: String, _ updateType: GameUpdateType?) {
        let gameRoomDataRef  = db.collection(GameRoom.path).document(gameRoomData.value.id)
        
        let oneUserData = [
            "boardCard" : userInGame.boardCard,
            "displayName" : userInGame.displayName,
            "handCard" : userInGame.handCard,
            "readyOrNot" : userInGame.readyOrNot,
            "id" : userInGame.id,
            "idx" : userInGame.idx,
            "profileUrl" : userInGame.profileUrl
        ] as [String : Any]
        
        gameRoomDataRef.updateData(["usersInGame.\(userId)" : oneUserData] ) { error in
            if let error {
                print(#fileID, #function, #line, "- sendIamReady change error: \(error.localizedDescription)")
            }
            print(#fileID, #function, #line, "- update ready success update user undefined checking: \(userId)")
            print(#fileID, #function, #line, "- update ready success update user undefined checking: \(oneUserData)")
            /// 게임 시작
            if updateType == .gameStart {
                if self.gameRoomData.value.hostId != "" {
                    self.gameroomDataUpdate(.whoseTurn, self.gameRoomData.value.hostId)
                }
            }
        }
    }

    /// whoseTurn, whoseGetting udpate
    func gameroomDataUpdate(_ updateDataType: GameRoomData, _ updateData: String) {
        let gameRoomDataRef  = db.collection(GameRoom.path).document(gameRoomData.value.id)
        gameRoomDataRef.updateData([updateDataType.rawValue : updateData]) { error in
            if let error = error {
                print(#fileID, #function, #line, "- update \(updateDataType) error: \(error.localizedDescription)")
            }
            print(#fileID, #function, #line, "- update \(updateDataType) success update")
            if updateDataType == .whoseTurn {
                self.secondsLeft = self.gameRoomData.value.turnTime
                self.gameBottomType = .selectCard
                self.gameCardTimer()
            } else if updateDataType == .selectedCard {
                self.gameBottomType = .selectUser
            } else if updateDataType == .whoseGetting {
                self.gameBottomType = .defender
            } else if updateDataType == .questionCard {
                self.gameBottomType = .defender
            }
        }
    }
    
    /// userID에 해당하는 유저 데이터를 가지고 온다
    func getUserData(_ userID: String) -> UserInGame? {
        let userDataDic = gameRoomData.value.usersInGame.first(where: { $0.key == userID })
        return userDataDic?.value
    }
    
    func gameCardTimer() {
        // 기존에 타이머 동작중이면 중지 처리
        if timer != nil && timer!.isValid {
            timer!.invalidate()
        }
        
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(timerCallBack), userInfo: nil, repeats: true)
    }
    
    @objc func timerCallBack() {
        self.secondsLeft -= 1
    }
    
    /// 유저의 카드 가지고 오기(손에 가지고 있는 카드, 게임판에 깔려있는 카드)
    func getUserCard(_ isHandCard: Bool) -> [Card] {
//        guard let userId = Service.shared.myUserModel.id else { return [] }
        let userId = Service.shared.myUserModel.id
        
        if let cardString = gameRoomData.value.usersInGame.first(where: { $0.key == userId }) {
            if isHandCard {
                return self.stringToCards(cardString.value.handCard)
            } else {
                return self.stringToCards(cardString.value.boardCard)
            }
        } else {
            return []
        }
    }
    
    /// 유저가 손에 쥐고 있는 카드 or 게임판에 있는 카드 데이터 업데이트
    /// - Parameters:
    ///   - selectedCard: 선택한 카드
    ///   - cards: 기존 카드들
    ///   - isHandCard: handCard인지 boardCard인지
    func userCardCardChange(_ selectedCard: Bugs, _ cards: [Card], _ isHandCard: Bool) {
        var cardString: String = ""
        cards.forEach { card in
            var tempString: String = ""
            
            if card.bug == selectedCard {
                tempString = isHandCard ? card.bug.cardString + "\(card.cardCnt - 1)" : card.bug.cardString + "\(card.cardCnt + 1)"
            } else {
                tempString = card.bug.cardString + "\(card.cardCnt)"
            }
            cardString += card == cards.last ? tempString : tempString + ","
        }
        guard let whoseTurn = gameRoomData.value.whoseTurn else { return }
        let userInGame = gameRoomData.value.usersInGame[whoseTurn]

        guard var userInGame = userInGame else { return }
        if isHandCard {
            userInGame.handCard = cardString
        } else {
            userInGame.boardCard = cardString
        }
        
        self.userInGameUpdate(userInGame, whoseTurn, nil)
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
