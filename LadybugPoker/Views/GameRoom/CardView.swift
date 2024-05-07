//
//  CardView.swift
//  LadybugPoker
//
//  Created by 김라영 on 2024/04/09.
//

import SwiftUI

struct CardView: View {
    let card: Card
    /// 카드의 가로 크기
    let cardWidthSize: CGFloat
    /// 카드의 세로 크기
    let cardHeightSize: CGFloat
    /// 아래 뷰의 카드인지
    let isBottomViewCard: Bool
    
    var body: some View {
        ZStack {
            VStack(spacing: 2) {
                bugView
                if card.cardCnt != 0 {
                    bugCntView
                } else {
                    Spacer()
                        .frame(height: 25)
                }
            }
            .zIndex(1)
            .frame(width: cardWidthSize, height: cardHeightSize)
            .background(Color(hex: card.bug.colorHex))
            .clipShape(RoundedRectangle(cornerRadius: cardWidthSize/5))
            RoundedRectangle(cornerRadius: cardWidthSize/5)
                .opacity(0.3)
                .blur(radius: 3.0)
                .offset(x: 0, y: 5)
                .frame(width: cardWidthSize, height: cardHeightSize)
        }
    }
    
    /// 어떤 곤충인지
    var bugView: some View {
        Image(card.bug.id)
            .resizable()
            .frame(width: cardWidthSize/2, height: cardWidthSize/2)
            .scaledToFit()
            .background(Color(hex: "FFF2E1"))
            .clipShape(Circle())
//            .padding(.top, 7)
    }
    
    /// 해당 곤충의 카드를 몇 장 모았는지
    var bugCntView: some View {
        Text("\(card.cardCnt)")
            .font(isBottomViewCard ? .sea(30) : .sea(25))
            .foregroundStyle(card.cardCnt == 3 && !isBottomViewCard ? Color(hex: "FF0000") : Color.white)
            .frame(height: 25)
    }
}

#Preview {
    CardView(card: Card(bug: Bugs.bee, cardCnt: 3), cardWidthSize: 40, cardHeightSize: 60, isBottomViewCard: false)
}
