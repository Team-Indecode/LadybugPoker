//
//  CardView.swift
//  LadybugPoker
//
//  Created by 김라영 on 2024/04/09.
//

import SwiftUI

struct CardView: View {
    /// 어떤 타입의 벌레인지
    let bugType: Bugs
    /// 해당 카드가 몇장이 있는지
    let cardCnt: Int
    /// 카드의 가로 크기
    let cardWidthSize: CGFloat
    /// 카드의 세로 크기
    let cardHeightSize: CGFloat
    /// 아래 뷰의 카드인지
    let isBottomViewCard: Bool
    
    var body: some View {
        VStack(spacing: 0) {
            bugView
            bugCntView
        }
        .padding(.horizontal, 10)
        .padding(.top, 6)
        .padding(.bottom, 2)
        .background(Color(hex: bugType.colorHex))
        .clipShape(RoundedRectangle(cornerRadius: cardWidthSize/5))
        .frame(width: cardWidthSize, height: cardHeightSize)
    }
    
    /// 어떤 곤충인지
    var bugView: some View {
        Image(bugType.id)
            .resizable()
            .frame(width: cardWidthSize/2, height: cardWidthSize/2)
            .scaledToFit()
            .padding(4)
            .background(Color(hex: "FFF2E1"))
            .clipShape(Circle())
            .padding(.bottom, isBottomViewCard ? 13 : 6)
    }
    
    /// 해당 곤충의 카드를 몇 장 모았는지
    var bugCntView: some View {
        Text("\(cardCnt)")
            .font(isBottomViewCard ? .sea(30) : .sea(25))
    }
}

#Preview {
    CardView(bugType: .bee, cardCnt: 2, cardWidthSize: 40, cardHeightSize: 60, isBottomViewCard: false)
}
