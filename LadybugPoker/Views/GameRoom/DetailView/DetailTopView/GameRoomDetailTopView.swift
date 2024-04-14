//
//  GameRoomDetailTopView.swift
//  LadybugPoker
//
//  Created by 김라영 on 2024/04/09.
//

import SwiftUI

struct GameRoomDetailTopView: View {
    let columns = [GridItem(.flexible()), GridItem(.flexible())]
    let sampleText: [String] = ["11", "22", "33", "44", "55", "66"]
    
    var body: some View {
        LazyVGrid(columns: columns, content: {
//            ForEach(s, content: <#T##(Identifiable) -> AccessibilityRotorContent#>)
        })
    }
}

#Preview {
    GameRoomDetailTopView()
}
