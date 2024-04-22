//
//  SignUpView.swift
//  LadybugPoker
//
//  Created by 박진서 on 4/22/24.
//

import SwiftUI

struct SignUpView: View {
    @State private var displayName: String = ""
    
    var body: some View {
        VStack {
            HStack(spacing: 12) {
                Image("ladybug")
                    .resizable()
                    .frame(width: 27, height: 27)
                    .padding(.leading, 15)
                
                Text("무당벌레 포커")
                    .font(.sea(15))
                    
                
                Spacer()
            }
            .frame(height: 69)
            .background(Color.bugDarkMedium)
            
            Text("사용할 닉네임을 적어주세요.")
                .font(.sea(20))
                .padding(.top, 30)
            
            TextField("강동구무당벌레", text: $displayName)
                .multilineTextAlignment(.center)
                .frame(height: 40)
                .font(.sea(20))
                .padding(.horizontal, 20)
                .background {
                    Color.bugLightMedium
                }
                .clipShape(RoundedRectangle(cornerRadius: 10))
                .overlay {
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(Color.bugDark)
                }
                .padding(.horizontal, 20)
                .padding(.top, 100)
            
            HStack {
                Spacer()
                
                Text("\(displayName.count) / 7")
                    .padding(.horizontal, 20)
                    .font(.sea(10))
            }
            
            Spacer()
            
            Button {
                
            } label: {
                ZStack {
                    displayName.count > 1 && displayName.count < 8 ?
                        Color.bugDark
                            .ignoresSafeArea()
                    :
                    Color(hex: "d9d9d9")
                        .ignoresSafeArea()

                    Text("다음")
                        .font(.sea(20))
                        .foregroundStyle(Color.white)
                }
            }
            .frame(height: 65)
            
        }
        .background {
            Color.bugLight
                .ignoresSafeArea()
        }
    }
}

#Preview {
    SignUpView()
}
