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
    let profileWidth: CGFloat
    let profileHeight: CGFloat
    let profileFontSize: CGFloat
    let profileImageSize: CGFloat
    
    init(user: UserInGame, profileWidth: CGFloat = 171, profileHeight: CGFloat = 69, profileFontSize: CGFloat = 20, profileImageSize: CGFloat = 40) {
        self.user = user
        self.profileWidth = profileWidth
        self.profileHeight = profileHeight
        self.profileFontSize = profileFontSize
        self.profileImageSize = profileImageSize
    }
    
    var body: some View {
        HStack {
            if let profileUrl = user.profileUrl {
                LazyImage(source: URL(string: profileUrl))
                    .scaledToFit()
                    .frame(width: profileImageSize, height: profileImageSize)
                    .clipShape(Circle())
                    .padding(.leading, 10)
            } else {
                Image("default_profile")
                    .resizable()
                    .frame(width: profileImageSize, height: profileImageSize)
                    .clipShape(Circle())
                    .padding(.leading, 10)
            }
            Text(user.displayName)
                .font(.sea(profileFontSize))
        }
        .frame(width: profileWidth, height: profileHeight, alignment: .leading)
        .background(Color.white)
        .clipShape(Capsule())
        .padding(.horizontal, 10)
    }
}

#Preview {
    UserProfileView(user: UserInGame(id: "", readyOrNot: false, handCard: "", boardCard: "", displayName: "", profileUrl: "", idx: 0, chat: Chat(msg: "", time: "")), profileWidth: 171, profileHeight: 69)
}
