//
//  ProfileView.swift
//  LadybugPoker
//
//  Created by 김라영 on 2024/04/09.
//

import SwiftUI
import NukeUI

/// 보드판 플레이어 프로필
struct BoardUserProfileView: View {
    let userImageUrl: String?
    let userNickname: String
    let userCardCnt: Int
    let isOdd: Bool
    let isHost: Bool
    
    var body: some View {
        VStack {
//            if isHost {
//                Image("crown")
//                    .resizable()
//                    .frame(width: 22, height: 22)
//            }
            // 프로필 이미지
            HStack(spacing: 8) {
                if let userImageUrl = userImageUrl {
                    LazyImage(source: userImageUrl)
                        .scaledToFit()
                        .frame(width: 30, height: 30)
                        .clipShape(Circle())
                } else {
                    Image(Bugs.ladybug.rawValue)
                        .resizable()
                        .scaledToFit()
                        .frame(width: 30, height: 30)
                        .clipShape(Circle())
                }
                
                // 유저 이름,
                VStack(spacing: 3) {
                    Text(userNickname)
                        .font(.sea(8))
                        .frame(maxWidth: .infinity, alignment: .leading)
                    HStack(spacing: 3) {
                        Image("profileCardIcon")
                            .frame(width: 12, height: 12)
                        Text("\(userCardCnt)장")
                            .font(.sea(8))
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                }
            }
        }
        
        .frame(width: 100)
        .frame(maxWidth: .infinity, alignment: isOdd ? .leading : .trailing)
        
    }
}

#Preview {
    BoardUserProfileView(userImageUrl: "https://picsum.photos/200", userNickname: "라영", userCardCnt: 3, isOdd: false, isHost: false)
}
