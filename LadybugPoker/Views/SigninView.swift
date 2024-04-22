//
//  SigninView.swift
//  LadybugPoker
//
//  Created by 박진서 on 4/5/24.
//

import SwiftUI

struct SigninView: View {
    var body: some View {
        VStack {
            HStack {
                Spacer()
                
                Image("ladybug")
                
                Spacer()
            }
            .padding(.top, 100)
            
            Text("무당벌레 포커")
                .font(.sea(30))
                .padding(.top, 40)
            
            Spacer()
            
            
            Button {
                
            } label: {
                HStack {
                    
                }
            }
            
        }
        .background {
            Color.bugLight
                .ignoresSafeArea()
        }
    }
}

#Preview {
    SigninView()
}
