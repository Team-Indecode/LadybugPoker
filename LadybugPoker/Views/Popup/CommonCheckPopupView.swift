//
//  CommonCheckPopupView.swift
//  LadybugPoker
//
//  Created by 김라영 on 2024/05/29.
//

import SwiftUI
/// 확인 alert
struct CommonCheckPopupView: View {
    @Binding var isPresented: Bool
    
    @State var title: String
    @State var subTitle: String = ""
    
    init(_ isPresented: Binding<Bool>, title: String, subTitle: String) {
        _isPresented = isPresented
        self.title = title
        self.subTitle = subTitle
    }
    
    var body: some View {
        ZStack {
            Color.black
                .ignoresSafeArea()
                .opacity(isPresented ? 0.5 : 0)
            alertView
        }
        .ignoresSafeArea()
        .zIndex(.greatestFiniteMagnitude)
    }
    
    var alertView: some View {
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
                    isPresented = false
                    
                } label: {
                    ZStack {
                        Color.bugLightMedium
                        
                        Text("확인")
                            .font(.sea(15))
                    }
                }
                Color.bugDark
                    .frame(width: 1)
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

