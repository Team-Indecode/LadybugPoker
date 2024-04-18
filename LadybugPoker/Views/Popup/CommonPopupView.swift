//
//  CommonPopupView.swift
//  LadybugPoker
//
//  Created by 박진서 on 4/17/24.
//

import SwiftUI

struct CommonPopupView: View {
    @Binding var isPresented: Bool
    
    @State var title: String
    @State var subTitle: String = "설명이 들어갑니다."
    var buttonHandler: (() -> Void)
    
    var body: some View {
        VStack(spacing: 0) {
            Text(title)
                .font(.sea(23))
                .padding(.top, 30)
            
            Text(subTitle)
                .font(.sea(15))
                .padding(.vertical, 15)
                .padding(.bottom, 15)
            
            Color.bugDark
                .frame(height: 1)
            
            HStack(spacing: 0) {
                Button {
                    
                } label: {
                    ZStack {
                        Color.bugLightMedium
                        
                        Text("예")
                            .font(.sea(15))
                    }
                }
                
                Color.bugDark
                    .frame(width: 1)
                
                Button {
                    
                } label: {
                    ZStack {
                        Color.bugLightMedium
                        
                        Text("아니오")
                            .font(.sea(15))
                    }
                }
            }
            .frame(height: 70)
            .foregroundStyle(Color.black)
        }
        .background {
            Color.bugLight
                
        }
        .clipShape(RoundedRectangle(cornerRadius: 15))
        .overlay {
            RoundedRectangle(cornerRadius: 15)
                .stroke(Color.bugDark)
        }
        .padding(.horizontal, 50)
    }
}

#Preview {
    CommonPopupView(isPresented: .constant(true),
                    title: "test",
                    buttonHandler: {})
}
