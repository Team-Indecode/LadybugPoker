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
                    
                case .signup:
                    SignUpView()
                        .navigationBarBackButtonHidden()
                    
                case .signin:
                    SigninView()
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
