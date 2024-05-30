//
//  View+.swift
//  LadybugPoker
//
//  Created by 김라영 on 2024/04/29.
//

import SwiftUI

extension View {
    func transparentFullScreenCover<Content: View>(isPresented: Binding<Bool>, content: @escaping () -> Content) -> some View {
        fullScreenCover(isPresented: isPresented) {
            ZStack {
                content()
            }
            .background(TransparentBackground())
        }
    }
    
    func customAlert(title: String, subTitle: String, isPresented: Binding<Bool>, yesButtonHandler: @escaping () -> Void) -> some View {
        fullScreenCover(isPresented: isPresented) {
            if #available(iOS 16.4, *) {
                CommonPopupView(isPresented, title: title, subTitle: subTitle, yesButtonHandler: yesButtonHandler)
                    .presentationBackground(.clear)
            } else {
                CommonPopupView(isPresented, title: title, subTitle: subTitle, yesButtonHandler: yesButtonHandler)
            }
        }
        .transaction { transaction in
//            if isPresented.wrappedValue {
//                
//            }
            transaction.disablesAnimations = true
            
            transaction.animation = .linear(duration: 0.1)
        }
    }
    
    func customCheckAlert(title: String, subTitle: String, isPresented: Binding<Bool>) -> some View {
        fullScreenCover(isPresented: isPresented) {
            if #available(iOS 16.4, *) {
                CommonCheckPopupView(isPresented, title: title, subTitle: subTitle)
                    .presentationBackground(.clear)
            } else {
                CommonCheckPopupView(isPresented, title: title, subTitle: subTitle)
            }
        }
        .transaction { transaction in
//            if isPresented.wrappedValue {
//
//            }
            transaction.disablesAnimations = true
            
            transaction.animation = .linear(duration: 0.1)
        }
    }
    
    func blinking() -> some View {
        self.modifier(BlinkViewModifier())
    }
    
    func hideKeyboard() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}

struct TransparentBackground: UIViewRepresentable {
    func makeUIView(context: Context) -> UIView {
        let view = UIView()
        DispatchQueue.main.async {
            view.superview?.superview?.backgroundColor = .clear
        }
        return view
    }

    func updateUIView(_ uiView: UIView, context: Context) {}
}


