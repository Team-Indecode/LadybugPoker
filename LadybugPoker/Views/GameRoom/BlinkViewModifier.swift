//
//  BlinkViewModifier.swift
//  LadybugPoker
//
//  Created by 김라영 on 2024/05/17.
//

import SwiftUI

struct BlinkViewModifier: ViewModifier {
    @State private var blinking: Bool = false
    
    func body(content: Content) -> some View {
        content
            .opacity(blinking ? 0 : 1)
            .onAppear {
                blinking = true
                Timer.scheduledTimer(withTimeInterval: 0.7, repeats: true) { _ in
                    withAnimation(.easeIn(duration: 0.7)) {
                        blinking.toggle()
                    }
                }
            }
    }
}
