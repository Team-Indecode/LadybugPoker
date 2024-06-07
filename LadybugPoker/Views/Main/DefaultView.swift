//
//  DefaultView.swift
//  LadybugPoker
//
//  Created by 박진서 on 4/22/24.
//

import SwiftUI
import FirebaseAuth
import Photos

struct DefaultView: View {
    @EnvironmentObject private var service: Service
    @StateObject var viewModel = GameRoomDetailViewViewModel()
    @State private var showText = false
    
    var body: some View {
        NavigationStack(path: $service.path) {
            ZStack {
                Color.black
                    .ignoresSafeArea()
                
                VStack(spacing: 0) {
                    Image("card_background")
                        .resizable()
                    Image("card_background")
                        .resizable()
                    Image("card_background")
                        .resizable()
                }
                .opacity(0.3)
                .ignoresSafeArea()

            }
            .overlay {
                VStack(spacing: 40) {
                    if showText {
                        Text("무당벌레 포커")
                            .font(.sea(50))
                            .foregroundStyle(Color.white)
                    }

                    
                    Image("bg_image")
                        .resizable()
                        .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.width)
                        .onAppear {
                            withAnimation(.easeInOut(duration: 1.5)) {
                                showText = true
                            }
                        }
                }
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
                case .gameRoom(let gameRoomId):
                    GameRoomDetailView(gameRoomId: gameRoomId)
                        .navigationBarBackButtonHidden()
                    
                case .myPage(let id):
                    MyPageView(id: id)
                        .navigationBarBackButtonHidden()
                    
                case .guide:
                    GuideView()
                        .navigationBarBackButtonHidden()
                }
            }
            .onChange(of: showText) { newValue in
                if newValue {
                    let requiredAccessLevel: PHAccessLevel = .readWrite
                    PHPhotoLibrary.requestAuthorization(for: requiredAccessLevel) { authorizationStatus in
                        switch authorizationStatus {
                        case .limited:
                            print("limited authorization granted")
                        case .authorized:
                            print("authorization granted")
                        default:
                            //FIXME: Implement handling for all authorizationStatus
                            print("Unimplemented")
                        }
                    }
                    
                    Task {
                        try await Task.sleep(nanoseconds: 1_500_000_000)
                        
                        //                    try Auth.auth().signOut()
                        do {
                            if let user = Auth.auth().currentUser {
                                service.myUserModel = try await User.fetch(id: user.uid)
                                service.path.append(service.myUserModel == nil ? .signin : .main)
                            } else {
                                service.path.append(.signin)
                            }
                        } catch {
                            print(error)
                        }
                        
                    }
                }
            }
        }
    }
}

#Preview {
    DefaultView()
        .environmentObject(Service.shared)
}
