//
//  GameRoomDetailBottomView+PlayingView.swift
//  LadybugPoker
//
//  Created by 박진서 on 4/10/24.
//

import SwiftUI

extension GameRoomDetailBottomView {
    
    struct PlayingView: View {
        
        /// 현재 턴인 유저
        @Binding var userInTurn: User
        
        var body: some View {
            VStack {
                Text(userInTurn.displayName + " 턴 입니다.")
                    .font(.sea(15))
            }
        }
    }
}


#Preview {
    GameRoomDetailBottomView.PlayingView(userInTurn: .constant(User(id: "idsjafkl", displayName: "진서", profileUrl: nil)))
}
