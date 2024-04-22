//
//  GameRoom_Preview.swift
//  LadybugPoker
//
//  Created by 박진서 on 4/5/24.
//

import Foundation

extension GameRoom {
    typealias GameRooms = [GameRoom]
    
    static var preview: Self {
        GameRoom(id: "testId", hostId: "test", title: "고수만 오세요", password: "123456", maxUserCount: 6, code: "A2F5E2", users: [], usersInGame: [], whoseTurn: "", whoseGetting: "", selectedCard: .bee, turnStartTime: .now)
    }
    
    static var listPreview: GameRooms {
        [
            GameRoom(id: "testId1", hostId: "test", title: "고수만 오세요", password: nil, maxUserCount: 6, code: "A2F5E2", users: ["123", "234", "345", "456"], usersInGame: [UserInGame(readyOrNot: true, handCard: [Card(bug: .bee, cardCnt: 1), Card(bug: .frog, cardCnt: 2), Card(bug: .rat, cardCnt: 1)], boardCard: [Card(bug: .bee, cardCnt: 1), Card(bug: .ladybug, cardCnt: 2), Card(bug: .snake, cardCnt: 2)], userId: "123", displayName: ""), UserInGame(readyOrNot: true, handCard: [Card(bug: .bee, cardCnt: 1), Card(bug: .snake, cardCnt: 3), Card(bug: .snail, cardCnt: 1)], boardCard: [Card(bug: .bee, cardCnt: 1), Card(bug: .frog, cardCnt: 2), Card(bug: .snake, cardCnt: 3)], userId: "234", displayName: ""), UserInGame(readyOrNot: true, handCard: [Card(bug: .spider, cardCnt: 1), Card(bug: .worm, cardCnt: 3), Card(bug: .rat, cardCnt: 1)], boardCard: [Card(bug: .ladybug, cardCnt: 1), Card(bug: .bee, cardCnt: 2), Card(bug: .worm, cardCnt: 2)], userId: "345", displayName: ""), UserInGame(readyOrNot: true, handCard: [Card(bug: .bee, cardCnt: 1), Card(bug: .frog, cardCnt: 2), Card(bug: .spider, cardCnt: 1)], boardCard: [Card(bug: .rat, cardCnt: 1), Card(bug: .frog, cardCnt: 2), Card(bug: .snake, cardCnt: 2), Card(bug: .bee, cardCnt: 2), Card(bug: .worm, cardCnt: 3)], userId: "456", displayName: "")], whoseTurn: "", whoseGetting: "", selectedCard: .bee, turnStartTime: .now),
            GameRoom(id: "testId2", hostId: "test", title: "초보만 오세요", password: nil, maxUserCount: 4, code: "GFF233", users: [], usersInGame: [UserInGame(readyOrNot: true, handCard: [Card(bug: .bee, cardCnt: 1), Card(bug: .frog, cardCnt: 2), Card(bug: .rat, cardCnt: 1)], boardCard: [Card(bug: .bee, cardCnt: 1), Card(bug: .ladybug, cardCnt: 2), Card(bug: .snake, cardCnt: 2)], userId: "123", displayName: "")], whoseTurn: "", whoseGetting: "", selectedCard: .bee, turnStartTime: .now),
            GameRoom(id: "testId3", hostId: "test", title: "고수만 오세요", password: "123456", maxUserCount: 6, code: "BD21GI", users: [], usersInGame: [UserInGame(readyOrNot: true, handCard: [Card(bug: .bee, cardCnt: 1), Card(bug: .frog, cardCnt: 2), Card(bug: .rat, cardCnt: 1)], boardCard: [Card(bug: .bee, cardCnt: 1), Card(bug: .ladybug, cardCnt: 2), Card(bug: .snake, cardCnt: 2)], userId: "123", displayName: "")], whoseTurn: "", whoseGetting: "", selectedCard: .bee, turnStartTime: .now),
            GameRoom(id: "testId4", hostId: "test", title: "고수만 오세요", password: "123456", maxUserCount: 4, code: "9991FF", users: [], usersInGame: [UserInGame(readyOrNot: true, handCard: [Card(bug: .bee, cardCnt: 1), Card(bug: .frog, cardCnt: 2), Card(bug: .rat, cardCnt: 1)], boardCard: [Card(bug: .bee, cardCnt: 1), Card(bug: .ladybug, cardCnt: 2), Card(bug: .snake, cardCnt: 2)], userId: "123", displayName: "")], whoseTurn: "", whoseGetting: "", selectedCard: .bee, turnStartTime: .now),
            GameRoom(id: "testId5", hostId: "test", title: "고수만 오세요", password: nil, maxUserCount: 6, code: "8AF9BD", users: [], usersInGame: [UserInGame(readyOrNot: true, handCard: [Card(bug: .bee, cardCnt: 1), Card(bug: .frog, cardCnt: 2), Card(bug: .rat, cardCnt: 1)], boardCard: [Card(bug: .bee, cardCnt: 1), Card(bug: .ladybug, cardCnt: 2), Card(bug: .snake, cardCnt: 2)], userId: "123", displayName: "")], whoseTurn: "", whoseGetting: "", selectedCard: .bee, turnStartTime: .now),
        ]
    }
}
