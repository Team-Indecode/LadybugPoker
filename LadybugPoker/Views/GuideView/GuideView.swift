//
//  GuideView.swift
//  LadybugPoker
//
//  Created by 박진서 on 5/6/24.
//

import SwiftUI

struct GuideView: View {
    var body: some View {
        VStack {
            GameRoomDetailView(gameRoomId: "PKE4yYIK9Zfn041LhtYp")
        }
    }
}

//#Preview {
//    VStack {
//        VStack {
//            GuideView()
//            
//        }
//        .onAppear {
//            Service.shared.myUserModel = User(id: "testId", displayName: "최고무당이", profileUrl: nil, history: [])
//        }
//    }
//    .environmentObject(Service.shared)
//}
