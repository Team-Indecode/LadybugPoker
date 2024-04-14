//
//  Card.swift
//  LadybugPoker
//
//  Created by 김라영 on 2024/04/12.
//

import Foundation

struct Card: Hashable {
    /// 어떤 타입의 벌레인지
    let bug: Bugs
    /// 해당 카드가 몇장이 있는지
    let cardCnt: Int
}
