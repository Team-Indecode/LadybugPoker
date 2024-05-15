//
//  KeyboardHeightHelper.swift
//  LadybugPoker
//
//  Created by 김라영 on 2024/05/15.
//

import UIKit
import Foundation

class KeyboardHeightHelper: ObservableObject {
    @Published var keyboardHeight: CGFloat = 0
    
    private func listenForKeyboardNotifications() {
        // 키보드가 나타났을떄
        NotificationCenter.default.addObserver(forName: UIResponder.keyboardDidShowNotification, object: nil, queue: .main) { notification in
            guard let userInfo = notification.userInfo,
                  let keyboardRect = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect else { return }
            
            self.keyboardHeight = keyboardRect.height - 33
        }
        
        // 키보드가 숨겨졌을 떄
        NotificationCenter.default.addObserver(forName: UIResponder.keyboardDidHideNotification, object: nil, queue: .main) { notification in
            self.keyboardHeight = 0
        }
    }
    
    init() {
        self.listenForKeyboardNotifications()
    }
}
