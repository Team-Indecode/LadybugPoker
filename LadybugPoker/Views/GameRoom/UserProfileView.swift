//
//  UserProfileView.swift
//  LadybugPoker
//
//  Created by 김라영 on 2024/05/04.
//

import SwiftUI
import NukeUI

struct UserProfileView: View {
    let user: UserInGame
    var body: some View {
        HStack {
            if let profileUrl = user.profileUrl {
                LazyImage(url: URL(string: profileUrl))
                    .scaledToFit()
                    .frame(width: 50, height: 50)
                    .clipShape(Circle())
                    .padding(.leading, 10)
            } else {
                Image(Bugs.ladybug.rawValue)
                    .scaledToFit()
                    .frame(width: 30, height: 30)
                    .clipShape(Circle())
            }
            Text(user.displayName)
                .font(.sea(20))
        }
        .frame(width: 171, height: 69, alignment: .leading)
        .background(Color.white)
        .clipShape(Capsule())
        .padding(.horizontal, 10)
    }
}

#Preview {
    UserProfileView(user: UserInGame(id: "", readyOrNot: false, handCard: "", boardCard: "", displayName: "", profileUrl: "", idx: 0, chat: ""))
}
