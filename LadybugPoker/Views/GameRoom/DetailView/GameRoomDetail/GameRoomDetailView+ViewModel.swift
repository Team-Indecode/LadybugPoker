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
    
    @Published var gameRoomData = CurrentValueSubject<GameRoom, Never>(GameRoom(id: "", hostId: "", title: "", password: "", maxUserCount: 0, code: "", usersInGame: [:], whoseTurn: nil, whoseGetting: nil, selectedCard: nil, turnStartTime: "", questionCard: nil, attackers: [], createdAt: "", turnTime: 0, gameStatus: GameStatus.notStarted.rawValue, loser: nil, decision: nil))

    /// userIdx와 userId
    @Published var usersId: [String] = Array(repeating: "", count: 6)
    /// 남은 시간
    @Published var secondsLeft: Int = 60
    /// 모든 플레이어가 준비 되었는지
    @Published var allPlayerReadied: Bool = false
    /// 유저 채팅[유저 idx : 유저 채팅]
    @Published var usersChat: [Int : Chat] = [:]
    /// 게임 타입(ex. 카드 선택, whoseGetting 선택 등)
    @Published var gameType: GameType? = nil
    /// 플레이어가 어떤 타입인지(공격자, 수비자, 둘다 아님)
    @Published var userType: Player? = nil
    /// 공격 & 수비 뷰 보여줄지
    @Published var showAttackerAndDefenderView: Bool = false
    /// 0: 한번의 공격이 종료되고 결과를 보여줄지 , 1: 공격성공(true), 공격실패(false)
    @Published var showAttackResult: (Bool, Bool) = (false, false)
    /// 패배한 유저가 누구인지 보여줌(게임 끝날때)
    @Published var showLoserView: Bool = false
    var timer: Timer?
    
    /// 해당 게임방의 데이터를 가지고 온다
    func getGameData(_ gameRoomId: String) async throws {
        db.collection(GameRoom.path).document(gameRoomId)
            .addSnapshotListener { doc, error in
                if let doc = doc, doc.exists {
                    if let data = GameRoom(data: doc.data() ?? [:]) {
//                    if let data = try? doc.data(as: GameRoom.self) {
                        self.gameRoomData.send(data)
                        self.getUsersId(data.usersInGame)
                        print(#fileID, #function, #line, "- self.gameRoomData: \(self.gameRoomData.value)")
                        // 게임방의 status 체크
                        if data.gameStatus != self.gameStatus.rawValue {
                            self.gameStatusChecking(data.gameStatus, data.turnTime)
                        }
                        
                        if data.gameStatus == GameStatus.onAir.rawValue {
                            // 게임방의 현재 게임 진행 상황 체크(ex. 카드선택, 공격대상 선택, questionCard선택 등)
                            self.gameTypeChecking(data)
                            // 공격자인지, 수비자인지, 그 외인지 체크
                            self.userTypeChecking(data)
                        } else if data.gameStatus == GameStatus.finished.rawValue {
                            self.showAttackerAndDefenderView = false
                            self.timer?.invalidate()
                            self.showLoserView = true
                        } else {
                            self.showAttackerAndDefenderView = false
                            self.allPlayerIsReadyChecking(data.usersInGame)
                        }
                    } else {
                        print(#fileID, #function, #line, "- wrong data")
                    }
                }
                
            }
    }
    
    /// 현재 게임방의 상황 체크(notStarted, onAirt 등)
    /// - Parameters:
    ///   - data: 현재 게임방의 상태(notStarted, onAir, notEnoughUser, finished)
    ///   - turnTime: 한 턴당 주어진 시간
    func gameStatusChecking(_ data: String, _ turnTime: Int) {
        switch data {
        case GameStatus.finished.rawValue: self.gameStatus = .finished
        case GameStatus.notStarted.rawValue: self.gameStatus = .notStarted
        case GameStatus.notEnoughUsers.rawValue: self.gameStatus = .notEnoughUsers
        case GameStatus.onAir.rawValue:
            self.gameStatus = .onAir
            self.gameType = .selectCard
//                                self.secondsLeft = data.turnTime
            self.gameTimer(turnTime)
        default: self.gameStatus = .notStarted
        }
    }
    
    /// 현재 게임방의 게임 진행상황(카드선택인지, 공격대상 선택인지, 물음표 카드 선택인지, 맞틀 선택인지 등)
    /// - Parameter data: GameRoom
    func gameTypeChecking(_ data: GameRoom) {
        if data.whoseTurn != nil {
            if data.selectedCard == nil {
                self.gameType = .selectCard
                self.gameTimer(data.turnTime)
            } else if data.selectedCard != nil && data.whoseGetting == nil {
                self.gameType = .selectUser
            } else if data.selectedCard != nil && data.whoseGetting != nil && data.questionCard == nil {
                self.gameType = .attacker
            } else if data.selectedCard != nil && data.whoseGetting != nil && data.questionCard != nil && data.decision == nil {
                self.gameType = .defender
                self.gameTimer(data.turnTime)
            } else if data.selectedCard != nil && data.questionCard != nil && data.whoseGetting != nil && data.decision != nil {
                guard let decision = data.decision else { return }
                guard let attackResult = self.defenderSuccessCheck(decision ? DefenderAnswer.same.rawValue : DefenderAnswer.different.rawValue) else { return }
                
                self.showAttackResult = (true, attackResult)
            }
        }
    }
    
    /// 공격자인지, 수비자인지, 그 외인지 판단
    /// - Parameter data: GameRoom
    func userTypeChecking(_ data: GameRoom) {
        if data.whoseTurn != nil && data.whoseGetting != nil {
            
            if data.whoseTurn == Service.shared.myUserModel.id {
                self.userType = .attacker
            } else if data.whoseGetting == Service.shared.myUserModel.id {
                self.userType = .defender
            } else {
                self.userType = .others
            }
            
            self.showAttackerAndDefenderView = true
        } else {
            self.showAttackResult = (false, true)
            self.showAttackerAndDefenderView = false
        }
    }
    
    /// 이거 순서를 단순히 그냥 순서를 가지고 오는 것이 아니라 UserInGame의 idx순서 대로 가져와야 한다
    // 1. tuple을 만들어서(userIdx, userId)이런식으로 만들어서 userIdx를 오름차순으로 정렬한다
    // 2. 그런다음 userId만 그 tuple에서 추출한다
    func getUsersId(_ usersInGame: [String : UserInGame]) {
        usersInGame.forEach { (key: String, value: UserInGame) in
            usersId[value.idx] = key
            usersChat[value.idx] = value.chat
            print(#fileID, #function, #line, "- value.chat⭐️: \(value)")
        }
    }
    
    /// 모든 유저가 게임 시작 준비가 됬는지를 판단한다
    /// - Parameter usersInGame
    func allPlayerIsReadyChecking(_ usersInGame: [String : UserInGame]) {
        var allReadyOrNot: Bool = true
        usersInGame.forEach { (key: String, value: UserInGame) in
            if !value.readyOrNot {
                allReadyOrNot = false
                if self.gameRoomData.value.gameStatus == GameStatus.onAir.rawValue {
                    self.gameroomDataUpdate(.gameStatus, GameStatus.notStarted.rawValue)
                }
                return
            }
        }
        self.allPlayerReadied = allReadyOrNot
        self.secondsLeft = 10
        self.gameTimer(10)
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
            if usersId[index] != "" {
                usersCardString[usersId[index]] = bugCardString.popLast()
            }
            
        }
        
        self.gameRoomData.value.usersInGame.values.forEach { userInGame in
            var userInGame = userInGame
            userInGame.handCard = usersCardString[userInGame.id] ?? ""
            userInGameUpdate(userInGame, userInGame.id, .gameStart)
        }
    }
    
    /// 유저의 준비완료 여부
    /// - Parameter readyOrNot: true -> 준비완료, fasle -> 준비완료 취소
    func sendIamReady(_ readyOrNot: Bool) {
        let userInGame = gameRoomData.value.usersInGame[Service.shared.myUserModel.id]

        guard var userInGame = userInGame else { return }
        userInGame.readyOrNot = readyOrNot
        
        userInGameUpdate(userInGame, userInGame.id, .sendUserReady)
    }
    
    func defenderSuccessCheck(_ text: String) -> Bool? {
        let same = self.gameRoomData.value.selectedCard == self.gameRoomData.value.questionCard
        print(#fileID, #function, #line, "- durldudlafkjdfjlakj")
        if same {
            if text == "맞습니다." {
                //수비성공 -> 공격자에 boardCard에 추가, whoseTurn -> 계속 공격자(즉, whoseTurn유지)
                return false
            } else if text == "아닙니다." {
                // 공격성공(수비실패) -> 수비자 boardCard에 추가, whoseTurn -> whoseGetting
                return true
            } else {
                // 카드 넘기기
                return nil
            }
        } else {
            // 둘이 다른 카드일떄
            if text == "맞습니다." {
                // 공격성공 -> 수비자 boardCard에 추가, whoseTurn: whoseGetting
                return true
            } else if text == "아닙니다." {
                return false
            } else {
                return nil
            }
        }
    }
    
    func cardIsSame(_ defenderLose: Bool) {
        var bugs: Bugs = .bee
        
        switch self.gameRoomData.value.selectedCard {
        case Bugs.bee.cardString: bugs = Bugs.bee
        case Bugs.ladybug.cardString: bugs = Bugs.ladybug
        case Bugs.snake.cardString: bugs = Bugs.snake
        case Bugs.snail.cardString: bugs = Bugs.snail
        case Bugs.spider.cardString: bugs = Bugs.spider
        case Bugs.frog.cardString: bugs = Bugs.frog
        case Bugs.worm.cardString: bugs = Bugs.worm
        case Bugs.rat.cardString: bugs = Bugs.rat
        default: return
        }
        
        // 공격성공, 수비실패 -> 수비자의 boardCard에 추가 / whoseTurn -> whoseGetting으로 변경
        if defenderLose {
            if let userInGame = self.gameRoomData.value.usersInGame[self.gameRoomData.value.whoseGetting ?? ""] {
                DispatchQueue.main.asyncAfter(deadline: .now() + 1.5, execute: {
                    let boardCards = self.stringToCards(userInGame.boardCard ?? "")
                    self.userCardChange(bugs, boardCards, false, userInGame.id)
                    self.gameroomDataUpdate(.gameAttackFinish, userInGame.id)
                })
            }
        }
        // 공격실패, 수비성공 -> 공격자의 boardCard에 추가 / whoseTurn -> 계속 공격지
        else {
            if let userInGame = self.gameRoomData.value.usersInGame[self.gameRoomData.value.whoseTurn ?? ""] {
                DispatchQueue.main.asyncAfter(deadline: .now() + 1.5, execute: {
                    let boardCards = self.stringToCards(userInGame.boardCard ?? "")
                    self.userCardChange(bugs, boardCards, false, userInGame.id)
                    self.gameroomDataUpdate(.gameAttackFinish, userInGame.id)
                })
            }
        }
    }
    
    /// 카드 넘기기 일때
    func cardSkip() {
        var attackers: [Int] = self.gameRoomData.value.attackers
        guard let whoseTurn = self.gameRoomData.value.whoseTurn,
              let whoseGetting = self.gameRoomData.value.whoseGetting else { return }
        
        for (index, id) in usersId.enumerated() {
            if !attackers.contains(index) {
                if whoseTurn == id || whoseGetting == id {
                    attackers.append(index)
                }
            }
        }
        self.gameroomDataUpdate(.cardSkip, "", attackers)
    }
    
    /// userID에 해당하는 유저 데이터를 가지고 온다
    func getUserData(_ userID: String) -> UserInGame? {
        let userDataDic = gameRoomData.value.usersInGame.first(where: { $0.key == userID })
        return userDataDic?.value
    }
    
    func gameTimer(_ time: Int) {
        // 기존에 타이머 동작중이면 중지 처리
        if timer != nil && timer!.isValid {
            secondsLeft = time
            timer!.invalidate()
        } else {
            secondsLeft = time
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
                print(#fileID, #function, #line, "- handCard⭐️: \(self.stringToCards(cardString.value.handCard ?? ""))")
                return self.stringToCards(cardString.value.handCard ?? "")
            } else {
                return self.stringToCards(cardString.value.boardCard ?? "")
            }
        } else {
            return []
        }
    }
    
    /// 유저가 손에 쥐고 있는 카드 or 게임판에 있는 카드 데이터 업데이트 -> 여기서 게임 졌는지/ 이겼는지 판단 가능
    /// - Parameters:
    ///   - selectedCard: 선택한 카드
    ///   - cards: 기존 카드들
    ///   - isHandCard: handCard인지 boardCard인지
    func userCardChange(_ selectedCard: Bugs, _ cards: [Card], _ isHandCard: Bool, _ userId: String) {
        var cardString: String = ""
        var updateCardArr: [Card] = cards
        
        if updateCardArr.isEmpty {
            cardString += selectedCard.cardString + "1"
        } else {
            var selectedCardIsInCardArr: Bool = false
            for (index, card) in updateCardArr.enumerated() {
                var tempString: String = ""
                if card.bug == selectedCard {
                    selectedCardIsInCardArr = true
                    updateCardArr[index].cardCnt += 1
                    tempString = isHandCard ? card.bug.cardString + "\(card.cardCnt - 1)" : card.bug.cardString + "\(card.cardCnt + 1)"
                } else {
                    tempString = card.bug.cardString + "\(card.cardCnt)"
                }
                cardString += card == cards.last ? tempString : tempString + ","
            }
            if !selectedCardIsInCardArr {
                let tempString = selectedCard.cardString + "1"
                cardString += cardString == "" ? tempString : "," + tempString
            }
        }
        
        print(#fileID, #function, #line, "- updateCard checking⭐️ cardString: \(cardString)")
        print(#fileID, #function, #line, "- updateCard checking⭐️ cardArray: \(updateCardArr)")
        let userInGame = gameRoomData.value.usersInGame[userId]

        guard var userInGame = userInGame else { return }
        if isHandCard {
            userInGame.handCard = cardString
        } else {
            userInGame.boardCard = cardString
        }
        
        self.userInGameUpdate(userInGame, userId, nil)
//        if !isHandCard {
//            userIsLoserChecking(userInGame.idx, updateCardArr)
//        }
    }
    
    /// 유저가 졌는지 체크(게임 종료)
    /// - Parameters:
    ///   - userIndex: <#userIndex description#>
    ///   - cards: <#cards description#>
    func userIsLoserChecking(_ userIndex: Int, _ cards: [Card]) {
        var userIsLoser: Bool = false
        if cards.count == Bugs.allCases.count {
            userIsLoser = true
        }
        cards.forEach { card in
            if card.cardCnt == 4 {
                userIsLoser = true
            }
        }
        if userIsLoser {
//            self.gameRoomData.value.loser = userIndex
            loserUpdate(userIndex)
            gameroomDataUpdate(.gameStatus, "finished")
        }
    }
    
    func userHandCardCntChecking(_ cardString: String) -> Int {
        let cardStringArr = cardString.components(separatedBy: ",")
        var handCardCnt: Int = 0
        cardStringArr.forEach { card in
            var tempCard = card
            let tempCnt = tempCard.popLast()
            print(#fileID, #function, #line, "- tempCnt: \(tempCnt)")
            if let tempCnt = tempCnt {
                if let cnt = Int(String(tempCnt)) {
                    handCardCnt += cnt
                }
            }
        }
        
        return handCardCnt
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
        
        return userCard.filter{ $0.cardCnt != 0 }
//        return userCard
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
    
    //MARK: - firebase 데이터 업데이트
    
    /// GameRoom의 한 user의 데이터 업데이트
    /// - Parameters:
    ///   - userInGame: 업데이트한 유저 데이터
    ///   - userId: 업데이트 할 유저 데이터
    ///   - updateType: 유저 업데이트 타입
    func userInGameUpdate(_ userInGame: UserInGame, _ userId: String, _ updateType: GameUpdateType?) {
        let gameRoomDataRef  = db.collection(GameRoom.path).document(gameRoomData.value.id)
        print(#fileID, #function, #line, "- userInGame: \(userInGame)")
        let oneUserData = [
            "boardCard" : userInGame.boardCard,
            "displayName" : userInGame.displayName,
            "handCard" : userInGame.handCard,
            "readyOrNot" : userInGame.readyOrNot,
            "id" : userInGame.id,
            "idx" : userInGame.idx,
            "profileUrl" : userInGame.profileUrl,
            "chat" : ["msg" : userInGame.chat?.msg,
                      "time" : userInGame.chat?.time]
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

    /// gameRoomData업데이트(ex. whoseTurn, whoseGetting, turnStartTime, gameStatus)
    func gameroomDataUpdate(_ updateDataType: GameRoomUpdateType, _ updateStringData: String, _ updateIntDatas: [Int]? = nil, _ updateInt: Int? = nil) {
        let gameRoomDataRef  = db.collection(GameRoom.path).document(gameRoomData.value.id)
        var updateDataDic: [String : String?] = [updateDataType.rawValue : updateStringData]
        if updateDataType == .whoseTurn {
            if gameStatus != .onAir {
                updateDataDic["gameStatus"] = GameStatus.onAir.rawValue
            }
            updateDataDic["turnStartTime"] = Date().toString
            
        } else if updateDataType == .whoseGetting {
            updateDataDic["turnStartTime"] = Date().toString
            guard let updateDatas = updateIntDatas else { return }
            attackersUpdate(updateDatas)
        } else if updateDataType == .gameAttackFinish {
            updateDataDic = [:]
            updateDataDic["turnStartTime"] = Date().toString
            updateDataDic["selectedCard"] = nil as String?
            updateDataDic["questionCard"] = nil as String?
            updateDataDic["whoseGetting"] = nil as String?
            // 다음턴은 공격/수비에서 진 사람이 정해진다
            updateDataDic["whoseTurn"] = updateStringData
            decisionUpdate("")
            attackersUpdate([])
        } else if updateDataType == .cardSkip {
            updateDataDic = [:]
            guard let updateDatas = updateIntDatas else { return }
            attackersUpdate(updateDatas)
            guard let nextTurn = self.gameRoomData.value.whoseGetting else { return }
            updateDataDic["whoseTurn"] = nextTurn
            updateDataDic["whoseGetting"] = nil as String?
            updateDataDic["turnStartTime"] = Date().toString
            print(#fileID, #function, #line, "- updateDicchecking⭐️: \(updateDataDic)")
        } 
        
        gameRoomDataRef.updateData(updateDataDic) { error in
            if let error = error {
                print(#fileID, #function, #line, "- update \(updateDataType) error: \(error.localizedDescription)")
            }
            print(#fileID, #function, #line, "- update \(updateDataType) success update")
        }
    }
    
    /// 게임 종료 시 진 사람이 누구인지 판별
    func loserUpdate(_ loser: Int) {
        let gameRoomDataRef  = db.collection(GameRoom.path).document(gameRoomData.value.id)
        
        let updateDataDic: [String : Int?] = ["loser" : loser]
        
        gameRoomDataRef.updateData(updateDataDic) { error in
            if let error = error {
                print(#fileID, #function, #line, "- update loser error: \(error.localizedDescription)")
            }
            print(#fileID, #function, #line, "- update loser success update")
        }
    }
    
    
    /// attackers 데이터 업데이트
    /// - Parameter attackers: attackers목록 업데이트
    func attackersUpdate(_ attackers: [Int]) {
        let gameRoomDataRef  = db.collection(GameRoom.path).document(gameRoomData.value.id)
        gameRoomDataRef.updateData(["attackers" : attackers]) { error in
            if let error = error {
                print(#fileID, #function, #line, "- update error: \(error.localizedDescription)")
            }
            print(#fileID, #function, #line, "- update success update")
        }
    }
    
    /// 수비자의 선택 업데이트
    /// - Parameter decision: 수비자가 선택한 text
    func decisionUpdate(_ decision: String) {
        let gameRoomDataRef  = db.collection(GameRoom.path).document(gameRoomData.value.id)
        var decisionBool: Bool?
        if decision == DefenderAnswer.same.rawValue {
            decisionBool = true
        } else if decision == DefenderAnswer.different.rawValue {
            decisionBool = false
        } else if decision == "" {
            decisionBool = nil
        } else {
//            defenderSuccessCheck(decision)
            cardSkip()
            return
        }
        
        gameRoomDataRef.updateData(["decision" : decisionBool]) { error in
            if let error = error {
                print(#fileID, #function, #line, "- update error: \(error.localizedDescription)")
            }
            print(#fileID, #function, #line, "- update success update")
            if decision == DefenderAnswer.same.rawValue || decision == DefenderAnswer.different.rawValue {
                if let attackResult = self.defenderSuccessCheck(decision) {
                    self.cardIsSame(attackResult)
                }
            }
        }
    }
    
    /// 게임룸에서 유저 삭제
    /// - Parameter userId: 삭제할 유저의 아이디
    func deleteUserInGameRoom(_ userId: String) {
        let gameRoomDataRef  = db.collection(GameRoom.path).document(gameRoomData.value.id)
        gameRoomDataRef.updateData(["usersInGame.\(userId)" : FieldValue.delete()] ) { error in
            if let error = error {
                print(#fileID, #function, #line, "- delete \(userId) error: \(error.localizedDescription)")
            }
            print(#fileID, #function, #line, "- delete UserSuccess⭐️: \(userId)")
        }
    }
    
    /// 게임룸 삭제
    func deleteGameRoom()  {
        let gameRoomDataRef  = db.collection(GameRoom.path).document(gameRoomData.value.id)
        gameRoomDataRef.delete { error in
            if let error = error {
                print(#fileID, #function, #line, "- delete해당 게임방 에러: \(error)")
            }
            print(#fileID, #function, #line, "- 게임 룸 삭제 success")
        }
    }

}
