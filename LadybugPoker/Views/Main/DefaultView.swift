//
//  DefaultView.swift
//  LadybugPoker
//
//  Created by 박진서 on 4/22/24.
//

import SwiftUI

struct DefaultView: View {
    @EnvironmentObject private var service: Service
    
    var body: some View {
        NavigationStack(path: $service.path) {
            VStack {
                
            }
            .navigationDestination(for: Path.self) { path in
                switch path {
                case .createGameRoom:
                    GameRoomCreateView()
                        .navigationBarBackButtonHidden()
                    
                case .signup(let email, let password):
                    SignUpView(email: email, password: password)
                        .navigationBarBackButtonHidden()
                    
                case .signin:
                    SigninView()
                        .navigationBarBackButtonHidden()
                    
                case .main:
                    MainView()
                        .navigationBarBackButtonHidden()
                }
            }
            .onAppear {
                service.path.append(.signin)
            }
        }
    }
}

#Preview {
    DefaultView()
        .environmentObject(Service.shared)
}
