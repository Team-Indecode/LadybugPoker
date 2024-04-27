//
//  MyPageView.swift
//  LadybugPoker
//
//  Created by 박진서 on 4/26/24.
//

import SwiftUI

struct MyPageView: View {
    @EnvironmentObject private var service: Service
    
    let id: String
    
    var body: some View {
        VStack {
            HStack {
                Button {
                    service.path.removeLast()
                } label: {
                    Image(systemName: "chevron.left")
                }
                .foregroundStyle(Color.black)
                
                Spacer()
            }
            .padding(.horizontal, 15)
            .padding(.vertical, 20)
            .background(Color.bugDarkMedium)
            .overlay {
                HStack {
                    Image("ladybug")
                        .resizable()
                        .frame(width: 27, height: 27)
                    
                    Text("무당벌레 포커")
                        .font(.sea(15))
                }
            }
            
            Spacer()
        }
    }
}

#Preview {
    MyPageView(id: "test")
}
