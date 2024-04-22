//
//  ProfileView.swift
//  LadybugPoker
//
//  Created by 김라영 on 2024/04/09.
//

import SwiftUI
import NukeUI

/// 플레이어 프로필
struct UserProfileView: View {
    let userImageUrl: String
    let userNickname: String
    let userCardCnt: Int
    let isOdd: Bool
    
    var body: some View {
        HStack(spacing: 8) {
            LazyImage(url: URL(string: userImageUrl))
                .frame(width: 30, height: 30)
                .clipShape(Circle())
                
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
        .frame(width: 80)
        .frame(maxWidth: .infinity, alignment: isOdd ? .leading : .trailing)
        
    }
}

#Preview {
    UserProfileView(userImageUrl: "https://picsum.photos/200", userNickname: "라영", userCardCnt: 3, isOdd: false)
}
