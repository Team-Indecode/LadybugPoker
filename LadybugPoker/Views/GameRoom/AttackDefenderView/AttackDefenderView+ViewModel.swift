//
//  AttackDefenderView+ViewModel.swift
//  LadybugPoker
//
//  Created by 김라영 on 2024/05/15.
//

import Foundation

class AttackDefenceViewModel: ObservableObject {
    @Published var dots: Int = 1
    @Published var circleDots: Int = -1
    
    var timer: Timer?
    var circleTimer: Timer?
    
    func gameTimer() {
        if timer != nil && timer!.isValid {
            dots = 1
            timer?.invalidate()
        }
        
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(dotsTimer), userInfo: nil, repeats: true)
    }
    
    func circle() {
        if circleTimer != nil && circleTimer!.isValid {
            circleDots = 0
            circleTimer?.invalidate()
        }
        
        circleTimer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(circleDotsTimer), userInfo: nil, repeats: true)
    }
    
    @objc func dotsTimer() {
        self.dots += 1
    }
    
    @objc func circleDotsTimer() {
        self.circleDots += 1
    }
    
}
