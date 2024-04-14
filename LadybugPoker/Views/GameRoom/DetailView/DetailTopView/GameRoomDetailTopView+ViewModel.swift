//
//  GameRoomDetailTopView+ViewModel.swift
//  LadybugPoker
//
//  Created by 김라영 on 2024/04/14.
//

import Foundation
import Combine

class GameRoomDetailTopViewViewModel: ObservableObject {
    @Published var userProfiles: [String : User] = [:]
    @Published var usersInGame: [UserInGame] = []
    
    
}
