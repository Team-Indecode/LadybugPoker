//
//  GameRoomTopView+ViewModel.swift
//  LadybugPoker
//
//  Created by 김라영 on 2024/06/06.
//

import Foundation
import Combine

class GameRoomTopViewModel: ObservableObject {
    var timer: Timer?
    @Published var showMessage: Bool = false
    @Published var secondsLeft: Int = 5
    
    func messageTimer() {
        self.showMessage = true
        if timer != nil && timer!.isValid {
            secondsLeft = 5
            timer?.invalidate()
        } else {
            secondsLeft = 5
        }
        
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(timerCallBack), userInfo: nil, repeats: true)
    }
    
    @objc func timerCallBack() {
        self.secondsLeft -= 1
        
        if secondsLeft == 0 {
            showMessage = false
        }
    }
}
