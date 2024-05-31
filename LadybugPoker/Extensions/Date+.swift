//
//  Date+.swift
//  LadybugPoker
//
//  Created by 박진서 on 4/27/24.
//

import Foundation

extension Date {
    /// Date -> String
    /// 2024-04-26 15:22:32 포멧으로 반환합니다.
    var toString: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss.SSS"
        
        return formatter.string(from: self)
    }
    
    /// 년도 를 반환합니다.
    var year: Int {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy"
        
        return Int(formatter.string(from: self)) ?? 2024
    }
    
    /// 월을 반환합니다.
    var month: Int {
        let formatter = DateFormatter()
        formatter.dateFormat = "MM"
        
        return Int(formatter.string(from: self)) ?? 1
    }
    
    /// 일을 반환합니다.
    var day: Int {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd"
        
        return Int(formatter.string(from: self)) ?? 1
    }
    
    /// 초를 반환합니다.
    var second: Int {
        let formatter = DateFormatter()
        formatter.dateFormat = "SS"
        
        return Int(formatter.string(from: self)) ?? 1
    }
}
