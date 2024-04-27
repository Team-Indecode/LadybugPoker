//
//  String+.swift
//  LadybugPoker
//
//  Created by 박진서 on 4/27/24.
//

import Foundation

extension String {
    /// String -> Date
    /// 2024-04-26 15:22:32 포멧으로 반환합니다.
    /// 잘못된 포멧일 경우 Date.now를 반환합니다.
    var toDate: Date {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        
        return formatter.date(from: self) ?? .now
    }
}
