//
//  Bugs.swift
//  LadybugPoker
//
//  Created by 박진서 on 4/9/24.
//

import Foundation

enum Bugs: String, Identifiable, Codable, CaseIterable {
    public var id: String { self.rawValue }
    
    case snake, ladybug, frog, rat, spider, snail, worm, bee
    
    var colorHex: String {
        switch self {
        case .snake:
            return "04CF00"
        case .ladybug:
            return "FF6565"
        case .frog:
            return "00AC3A"
        case .rat:
            return "939393"
        case .spider:
            return "432B0F"
        case .snail:
            return "C97900"
        case .worm:
            return "FF9C9C"
        case .bee:
            return "FFD53E"
        }
    }
    
    var cardString: String {
        switch self {
        case .snake:
            "Sn"
        case .ladybug:
            "L"
        case .frog:
            "F"
        case .rat:
            "R"
        case .spider:
            "Sp"
        case .snail:
            "SL"
        case .worm:
            "W"
        case .bee:
            "B"
        }
    }
}
