//
//  ContentView.swift
//  LadybugPoker
//
//  Created by 박진서 on 4/5/24.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        VStack {
            Image("ladybug")
            
            Text("무당벌레 포커")
                .font(.sea(20))

        }
        .padding()
        .onAppear {
            
            for fontFamily in UIFont.familyNames {
                for fontName in UIFont.fontNames(forFamilyName: fontFamily) {
                    print(fontName)
                }
            }
        }
    }
}

#Preview {
    ContentView()
}
