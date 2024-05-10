//
//  GameRoom.swift
//  LadybugPoker
//
//  Created by 박진서 on 4/5/24.
//

import Foundation

struct GameRoom: Codable, Identifiable, Equatable {
    static let path = "GAMEROOMS"
    
    let id: String
    /// 누가 방장인지
    let hostId: String
    let title: String
    let password: String?
    let maxUserCount: Int
    /// 방 식별자
    let code: String
    /// 유저들의 게임 데이터
    var usersInGame: [String: UserInGame]
    /// 누구 턴인지
    var whoseTurn: String?
    /// 누구에게 카드를 건냈는지
    let whoseGetting: String?
    /// 공격자가 실제로 선택한 벌레
    var selectedCard: String?
    /// 턴 시작 시간
    let turnStartTime: String?
    /// 공격자가 수비자에게 말한 벌레
    let questionCard: String?
    let attackers: [Int]
    let createdAt: String
    let turnTime: Int
    let gameStatus: String
    var loser: Int?
    /// 수비자의 맞,틀 선택(true -> 맞습니다, false -> 아닙니다)
    let decision: Bool?
    
    var toJson: [String: Any] {
        var userGameData: [String: Any] = [:]
        for data in usersInGame {
            userGameData[data.key] = data.value.toJson
        }
        
        return [
            "id": id,
            "hostId": hostId,
            "title": title,
            "password": password,
            "maxUserCount": maxUserCount,
            "code": code,
            "usersInGame": userGameData,
            "whoseTurn": whoseTurn,
            "whoseGetting" : whoseGetting,
            "selectedCard" : selectedCard,
            "turnStartTime" : turnStartTime,
            "questionCard" : questionCard,
            "attackers" : attackers,
            "createdAt" : createdAt,
            "turnTime" : turnTime,
            "loser" : loser,
            "decision" : decision
        ]
    }
    
    init(id: String, hostId: String, title: String, password: String?, maxUserCount: Int, code: String, usersInGame: [String: UserInGame], whoseTurn: String? = nil, whoseGetting: String?, selectedCard: String? = nil, turnStartTime: String?, questionCard: String? = nil, attackers: [Int], createdAt: String, turnTime: Int, gameStatus: String, loser: Int?, decision: Bool?) {
        self.id = id
        self.hostId = hostId
        self.title = title
        self.password = password
        self.maxUserCount = maxUserCount
        self.code = code
        self.usersInGame = usersInGame
        self.whoseTurn = whoseTurn
        self.whoseGetting = whoseGetting
        self.selectedCard = selectedCard
        self.turnStartTime = turnStartTime
        self.questionCard = questionCard
        self.attackers = attackers
        self.createdAt = createdAt
        self.turnTime = turnTime
        self.gameStatus = gameStatus
        self.loser = loser
        self.decision = decision
    }
    
    init?(data: [String: Any]) {
        guard let id = data["id"] as? String else {
            print(#function, #fileID, "wrongID")
            return nil
        }
        
        guard let hostId = data["hostId"] as? String else {
            print(#function, #fileID, "wrong Host Id")
            return nil
        }
        
        guard let title = data["title"] as? String else {
            print(#function, #fileID, "wrong Title")
            return nil
        }
        
        guard let maxUserCount = data["maxUserCount"] as? Int else {
            print(#function, #fileID, "wrong max user count")
            return nil
        }
        
        guard let code = data["code"] as? String else {
            print(#function, #fileID, "wrong code")
            
            return nil
        }
        
        guard let attackers = data["attackers"] as? [Int] else {
            return nil
        }
        
        guard let createdAt = data["createdAt"] as? String else {
            return nil
        }
        
        guard let turnTime = data["turnTime"] as? Int else {
            return nil
        }
        
        guard let gameStatus = data["gameStatus"] as? String else {
            return nil
        }
        
        self.id = id
        self.hostId = hostId
        self.title = title
        self.maxUserCount = maxUserCount
        self.code = code
        self.password = data["password"] as? String
        self.whoseTurn = data["whoseTurn"] as? String
        /// Users in game 처리
        var tempData = [String: UserInGame]()
        
        let usersInGameData = data["usersInGame"] as? [String: Any] ?? [:]
        
        for userData in usersInGameData {
            let userId = userData.key
            let userInGame = UserInGame(data: userData.value as? [String: Any] ?? [:])
            print(#fileID, #function, #line, "- userData in firstParsingCheck⭐️: \(userInGame)")
            print(#fileID, #function, #line, "- userData in firstParsingCheck⭐️: \(userData.value)")
            print(#fileID, #function, #line, "- userData in firstParsingCheck⭐️: \(userData)")
            if let userInGame {
                tempData[userId] = userInGame
            }
        }
        
        self.usersInGame = tempData
        self.selectedCard = data["selectedCard"] as? String
        self.whoseGetting = data["whoseGetting"] as? String
        self.turnStartTime = data["turnStartTime"] as? String
        self.questionCard = data["questionCard"] as? String
        self.attackers = attackers
        self.createdAt = createdAt
        self.turnTime = turnTime
        self.gameStatus = gameStatus
        self.loser = data["loser"] as? Int
        self.decision = data["decision"] as? Bool
    }
}

struct Chat {
    var msg: String
    var time: String
}


enum GameUpdateType {
    case gameStart
    case sendUserReady
}

enum GameRoomUpdateType: String {
    case attackers
    case questionCard
    case selectedCard
    case turnStartTime
    case whoseGetting
    case whoseTurn
    case gameStatus
    case gameAttackFinish
    case cardSkip
}

enum GameType {
    /// 카드를 누구에게 전달
    case selectUser
    /// 카드 선택
    case selectCard
    /// 공격자가 선택
    case attacker
    /// 수비자가 선택하는 뷰
    case defender
    /// 게임 한판의 결과를 보여줌
    case showGameResult
    /// 수비자가 카드 넘기기 선택
    case cardSkip
    /// 공격&수비 종료
    case gameAttackFinish
}

enum DefenderAnswer: String {
    case same = "맞습니다."
    case different = "아닙니다."
    case cardSkip = "카드를 넘깁니다."
}
