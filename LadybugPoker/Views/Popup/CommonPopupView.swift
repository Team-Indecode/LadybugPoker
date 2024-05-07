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
    var yesButtonHandler: (() -> Void)
    
    init(_ isPresented: Binding<Bool>, title: String, subTitle: String, yesButtonHandler: @escaping () -> Void) {
        _isPresented = isPresented
        self.title = title
        self.subTitle = subTitle
        self.yesButtonHandler = yesButtonHandler
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
                    yesButtonHandler()
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
                    isPresented = false
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

