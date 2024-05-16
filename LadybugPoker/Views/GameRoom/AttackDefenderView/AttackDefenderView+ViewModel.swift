//
//  AttackDefenderView+ViewModel.swift
//  LadybugPoker
//
//  Created by 김라영 on 2024/05/15.
//

import Foundation

class AttackDefenceViewModel: ObservableObject {
    @Published var dots: Int = 1
    var timer: Timer?
    
    func gameTimer() {
        if timer != nil && timer!.isValid {
            dots = 1
            timer?.invalidate()
        }
        
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(dotsTimer), userInfo: nil, repeats: true)
    }
    
    @objc func dotsTimer() {
        self.dots += 1
    }
    
}
