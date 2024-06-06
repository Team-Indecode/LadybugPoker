//
//  UserProfileView.swift
//  LadybugPoker
//
//  Created by 김라영 on 2024/05/04.
//

import SwiftUI
import NukeUI

struct UserProfileView: View {
    let user: Player
    let profileWidth: CGFloat
    let profileHeight: CGFloat
    let profileFontSize: CGFloat
    let profileImageSize: CGFloat
    let needOpacity: Bool
    
    init(user: Player, profileWidth: CGFloat = 171, profileHeight: CGFloat = 69, profileFontSize: CGFloat = 20, profileImageSize: CGFloat = 40, needOpacity: Bool = false) {
        self.user = user
        self.profileWidth = profileWidth
        self.profileHeight = profileHeight
        self.profileFontSize = profileFontSize
        self.profileImageSize = profileImageSize
        self.needOpacity = needOpacity
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
//        .padding(.horizontal, 10)
        .opacity(needOpacity ? 0.5 : 1)
    }
}

#Preview {
    UserProfileView(user: Player(id: "", profileUrl: "", displayName: ""), profileWidth: 171, profileHeight: 69)
}
