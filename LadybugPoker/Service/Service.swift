//
//  Service.swift
//  LadybugPoker
//
//  Created by 박진서 on 4/6/24.
//

import SwiftUI

class Service: ObservableObject {
    static let shared = Service()
    
    @Published var path: [Path] = []
    @Published var myUserModel: User! = nil
    
    private init() { }
    
}
