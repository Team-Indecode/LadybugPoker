//
//  GuideCardView.swift
//  LadybugPoker
//
//  Created by 박진서 on 5/7/24.
//

import SwiftUI

struct GuideCardView: View {
    @State var bug: Bugs
    @State var count: Int
    
    var body: some View {
        ZStack {
            Color(hex: bug.colorHex)
            
            VStack(spacing: 0) {
                Circle()
                    .fill(Color.white)
                    .overlay {
                        Image(bug.rawValue)
                            .resizable()
                            .scaledToFit()
                            .padding(4)
                    }
                    .padding(5)
                
                Text("\(count)")
                    .font(.sea(20))
                    .foregroundStyle(Color.white)
                    .opacity(count == 9 ? 0 : 1)
            }
        }
        .clipShape(RoundedRectangle(cornerRadius: 5))
        .opacity(count == 0 ? 0 : 1)
    }
}

#Preview {
    GuideCardView(bug: .bee, count: 2)
}
