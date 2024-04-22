//
//  GameRoomDetailTopView+ViewModel.swift
//  LadybugPoker
//
//  Created by 김라영 on 2024/04/14.
//

import Foundation
import Combine

class GameRoomDetailTopViewViewModel: ObservableObject {
    @Published var userProfiles: [String : User] = ["123": User(id: "", displayName: "rayoung", profileUrl: "https://picsum.photos/200"), "234": User(id: "", displayName: "rayoung", profileUrl: "https://picsum.photos/200"), "345": User(id: "", displayName: "rayoung", profileUrl: "https://picsum.photos/200"), "456": User(id: "", displayName: "rayoung", profileUrl: "https://picsum.photos/200")]
    @Published var usersInGame: [UserInGame] = []
    
    @Published var attackUser: String = "234"
    
}
