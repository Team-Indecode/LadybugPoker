//
//  GameRoomView.swift
//  LadybugPoker
//
//  Created by 박진서 on 4/5/24.
//

import SwiftUI

struct GameRoomView: View {
    let gameRoom: GameRoom
    
    var body: some View {
        VStack(spacing: 30) {
            HStack {
                Text(gameRoom.title)
                    .font(.sea(15))
                
                Spacer()
                
                Text("\(gameRoom.usersInGame.count) / \(gameRoom.maxUserCount)")
                    .font(.sea(15))
            }
            
            HStack {
                Image("lock")
                
                Spacer()
                
                Text("#" + gameRoom.code)
                    .font(.sea(10))
                    .foregroundStyle(Color.bugDark)

            }
        }
        .padding(.horizontal, 20)
        .padding(.vertical, 15)
        .background {
            Color.bugLight
        }
        .clipShape(RoundedRectangle(cornerRadius: 15))
        .overlay {
            RoundedRectangle(cornerRadius: 15)
                .stroke(Color.bugDark)
        }
        .padding(.horizontal, 20)
        
    }
}

#Preview {
    GameRoomView(gameRoom: .preview)
}
