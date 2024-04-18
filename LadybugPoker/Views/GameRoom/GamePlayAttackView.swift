//
//  GamePlayAttackView.swift
//  LadybugPoker
//
//  Created by 김라영 on 2024/04/18.
//

import SwiftUI
import NukeUI

/// 공격자 입장
struct GamePlayAttackView: View {
    let columns = [GridItem(.flexible()), GridItem(.flexible()), GridItem(.flexible()), GridItem(.flexible())]
    let bugs: [Bugs] = [.frog, .ladybug, .frog, .rat, .spider, .snail, .worm, .bee]
    var body: some View {
        VStack {
            makeUserView(User(id: "", displayName: "라영", profileUrl: "https://picsum.photos/200"))
            bugsView
            makeUserView(User(id: "", displayName: "fkdud", profileUrl: "https://picsum.photos/200"))
        }
    }
    
    // 유저 뷰 제작
    @MainActor
    func makeUserView(_ user: User) -> some View {
        return HStack {
            if let profileUrl = user.profileUrl {
                LazyImage(url: URL(string: profileUrl))
                    .frame(width: 50, height: 50)
                    .clipShape(Circle())
            }
            Text(user.displayName)
                .font(.sea(20))
        }
        .frame(width: 171, height: 69)
        .background(Color.white)
        .clipShape(Capsule())
    }
    
    var bugsView: some View {
        LazyVGrid(columns: columns) {
            ForEach(bugs, id: \.self) { bug in
                makeBug(bug)
            }
        }
    }
    
    func makeBug(_ bug: Bugs) -> some View {
        Image(bug.id)
            .frame(width: 70, height: 70)
            .background(Color(hex: "D9D9D9"))
            .clipShape(Circle())
    }
    
    
}

#Preview {
    GamePlayAttackView()
}
