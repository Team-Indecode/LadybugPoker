//
//  GuideView+PlayerBoardView.swift
//  LadybugPoker
//
//  Created by 박진서 on 5/6/24.
//

import SwiftUI
import NukeUI

extension GuideView {
    struct GuideView_PlayerBoardView: View {
        @State var isLeft: Bool
        @State var user: User
        
        var body: some View {
            VStack(alignment: .leading) {
                HStack(spacing: 8) {
                    LazyImage(url: URL(string: user.profileUrl ?? ""))
                        .scaledToFill()
                        .frame(width: 30, height: 30)
                        .clipShape(Circle())
                    
                    VStack(alignment: .leading) {
                        Text(user.displayName)
                        
                        HStack(spacing: 3) {
                            Image("profileCardIcon")

                            Text("\(Int.random(in: 5..<10))장")
                        }
                    }
                    .font(.sea(8))

                }
                
                Text("준비 완료")
                    .font(.sea(35))
            }
        }
    }
}

#Preview {
    GuideView.GuideView_PlayerBoardView(isLeft: true, user: User.random())
}
