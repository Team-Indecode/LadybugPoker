//
//  GuideView.swift
//  LadybugPoker
//
//  Created by 박진서 on 5/6/24.
//

import SwiftUI
import NukeUI

struct GuideView: View {
    @EnvironmentObject private var service: Service
    
    @State private var users: [User] = []
    
    @State private var level = 9
    
    @State private var gameStatus: GameStatus = .onAir
    
    @State private var backgroundOpacity = 0.8
    @State private var showAnswer = false
    
    var body: some View {
        VStack {
            if users.count == 6 {
                
                HStack {
                    GuideView_PlayerBoardView(isLeft: true,
                                              user: users[0],
                                              gameStatus: $gameStatus,
                                              index: 0)
                    
                    Spacer()
                    
                    GuideView_PlayerBoardView(isLeft: true,
                                              user: users[1],
                                              gameStatus: $gameStatus,
                                              index: 1)
                    .opacity(level == 8 ? 0 : 1)
                }
                .padding(.horizontal, 10)
                
                HStack {
                    GuideView_PlayerBoardView(isLeft: true,
                                              user: users[2],
                                              gameStatus: $gameStatus,
                                              index: 2)
                    
                    Spacer()
                    
                    GuideView_PlayerBoardView(isLeft: true,
                                              user: users[3],
                                              gameStatus: $gameStatus,
                                              index: 3)
                }
                .padding(.horizontal, 10)
                
                HStack {
                    GuideView_PlayerBoardView(isLeft: true,
                                              user: users[4],
                                              gameStatus: $gameStatus,
                                              index: 4)
                    
                    Spacer()
                    
                    GuideView_PlayerBoardView(isLeft: true,
                                              user: users[5],
                                              gameStatus: $gameStatus,
                                              index: 5)
                }
                .padding(.horizontal, 10)
                
                Spacer()
                
                VStack {
                    if gameStatus != .onAir {
                        Color(hex: "d9d9d9")
                            .frame(height: 2)
                        
                        Text("게임시작 전 입니다.")
                            .font(.sea(15))
                        
                        Spacer()
                        
                        Text("준비 완료")
                            .font(.sea(35))

                        Spacer()
                        
                        Text("준비 취소")
                            .font(.sea(15))
                    }
                }
                .frame(height: 180)
            }
        }
        .background(Color.bugLight)
        .overlay {
            ZStack {
                Color.black
                    .opacity(backgroundOpacity)
                    .ignoresSafeArea()
                
                /// 카드 넘기기 화면용
                if users.count > 3 {
                    if level == 8 {
                        VStack {
                            HStack {
                                GuideView_PlayerBoardView(isLeft: true,
                                                          user: users[0],
                                                          gameStatus: $gameStatus,
                                                          index: 1)
                                .opacity(0)
                                
                                Spacer()
                                
                                Button {
                                    Task {
                                        withAnimation {
                                            level += 1
                                        }
                                        
                                        try await Task.sleep(nanoseconds: 1_000_000_000)
                                        
                                        withAnimation {
                                            level += 1
                                        }
                                    }
                   
                                } label: {
                                    GuideView_PlayerBoardView(isLeft: true,
                                                              user: users[1],
                                                              gameStatus: $gameStatus,
                                                              index: 1)
                                }
                                .padding(.horizontal, 10)
                                .overlay(alignment: .topLeading) {
                                    Image(systemName: "arrowshape.right.fill")
                                        .foregroundStyle(Color.orange)
                                        .padding(.leading, -40)
                                }
                            }
                            
                            GuideView_PlayerBoardView(isLeft: true,
                                                      user: users[1],
                                                      gameStatus: $gameStatus,
                                                      index: 1)
                            .opacity(0)
                            
                            GuideView_PlayerBoardView(isLeft: true,
                                                      user: users[1],
                                                      gameStatus: $gameStatus,
                                                      index: 1)
                            .opacity(0)
                            
                            Spacer()
                        }
                        .padding(.bottom, 180)
                    }
                }
                
                switch level {
                case 0:
                    VStack {
                        Image("ladybug")
                            .padding(.bottom, 70)
                        
                        Text("무당벌레 포커에 오신 것을")
                        
                        Text("환영합니다 !")
                    }
                case 1:
                    VStack {
                        Image("ladybug")
                            .padding(.bottom, 70)
                        
                        Text("지금부터 게임 이해를 위한")
                        
                        Text("연습게임이 시작됩니다 !")
                    }
                case 2:
                    VStack {
                        Image("ladybug")
                            .padding(.bottom, 70)
                        
                        Text("가이드 무당이를")
                        
                        Text("잘 따라해주세요 !")
                    }
                case 4, 5, 6, 7:
                    VStack {
                        Image("ladybug")
                            .padding(.bottom, 70)
                        
                        Text("내 차례입니다.")
                        
                        Text("상대방에게 넘길 카드를")
                        
                        Text("선택하세요 !")
                    }
                    .padding(.bottom, 150)
                    
                case 8:
                    VStack {
                        Image("ladybug")
                            .padding(.bottom, 70)
                        
                        Text("카드를 누구에게 넘길까요?")
                        
                        Text("\(users[1].displayName)를")
                        
                        Text("선택하세요 !")
                    }
                    
                case 9, 10, 11, 12:
                    if users.count > 5 {
                        LevelNineView(user: service.myUserModel, 
                                      firstUser: users[1],
                                      level: $level,
                                      showAnswer: $showAnswer)
                            .padding(.bottom, 180)
                    }
                default:
                    VStack {
                        
                    }
                }
            }
            .font(.sea(30))
            .foregroundStyle(Color.white)
            
        }
        .overlay(alignment: .bottom) {
            VStack {
                if level < 3 {
                    if level > 0 {
                        Button {
                            withAnimation {
                                level -= 1
                            }
                        } label: {
                            Text("뒤로가기")
                                .font(.sea(15))
                                .foregroundStyle(Color(hex: "b7b7b7"))
                        }
                        
                    }

                    Button {
                        withAnimation {
                            if level == 2 {
                                Task {
                                    withAnimation {
                                        backgroundOpacity = 0
                                    }

                                    try await Task.sleep(nanoseconds: 1_000_000_000)
                                    
                                    withAnimation {
                                        backgroundOpacity = 0.8
                                    }
                                    
                                    withAnimation {
                                        level += 1
                                    }
                                    
                                    try await Task.sleep(nanoseconds: 1_000_000_000)

                                    withAnimation {
                                        level += 1
                                    }
                                    
                                    try await Task.sleep(nanoseconds: 1_000_000_000)

                                    withAnimation {
                                        level += 1
                                    }
                                    
                                    try await Task.sleep(nanoseconds: 1_000_000_000)

                                    withAnimation {
                                        level += 1
                                    }
                                }
                            }
                            
                            level += 1
                        }
                    } label: {
                        Color.black
                            .frame(height: 50)
                            .overlay {
                                Text("다음")
                                    .font(.sea(20))
                                    .foregroundStyle(Color.white)
                            }
                    }
                    .clipShape(RoundedRectangle(cornerRadius: 25))
                    .padding(.horizontal, 35)
                    .padding()
                    
                } else if level == 5 || level == 6 || level == 7 || level == 8 {
                    VStack {
                        HStack {
                            Spacer()
                            
                            Text(service.myUserModel.displayName + "턴 입니다.")
                                .font(.sea(15))
                            
                            Spacer()
                        }
                        .background(Color.bugLight)
                            
                        HStack {
                            Button {
                                withAnimation {
                                    level += 1
                                }
                            } label: {
                                GuideCardView(bug: .snake, count: 2)
                                    .frame(width: 55)
                            }
                            .padding(.leading, 5)
                            .disabled(level != 7)
                            
                            if level < 8 {
                                GuideCardView(bug: .ladybug, count: 1)
                                    .frame(width: 55)
                                    .opacity(level == 7 ? 0 : 1)
                                
                                GuideCardView(bug: .frog, count: 3)
                                    .frame(width: 55)
                                    .opacity(level == 7 ? 0 : 1)
                                
                                GuideCardView(bug: .rat, count: 2)
                                    .frame(width: 55)
                                    .opacity(level == 7 ? 0 : 1)
                                
                                GuideCardView(bug: .spider, count: 3)
                                    .frame(width: 55)
                                    .opacity(level == 7 ? 0 : 1)
                                
                                GuideCardView(bug: .snail, count: 2)
                                    .frame(width: 55)
                                    .opacity(level == 7 ? 0 : 1)
                            }
  
                        }
                        .frame(height: 96)
                        .overlay(alignment: .trailing) {
                            if level == 7 {
                                Color.clear
                                    .padding(.leading, 60)
                                    .overlay {
                                        Text("뱀을 클릭해보세요 !")
                                            .font(.sea(30))
                                            .foregroundStyle(Color.white)
                                    }
                            }
                        }
                        
                        Spacer()
                    }
                    .frame(height: 180)
                } else if level == 10 {
                    VStack {
                        Text("무슨 카드라고 속일까요?")
                            .font(.sea(30))
                        
                        Text("쥐를 눌러보세요 !")
                            .font(.sea(30))
                    }
                    .frame(height: 180)
                    .foregroundStyle(Color.white)
                } else if level == 11 {
                    VStack {
                        HStack {
                            Text("맞습니다.")
                                .padding(.horizontal, 30)
                                .padding(.vertical, 10)
                                .background {
                                    Color(hex: "f1f1f1")
                                }
                                .clipShape(RoundedRectangle(cornerRadius: .infinity))
                                .onAppear {
                                    Task {
                                        try await Task.sleep(nanoseconds: 4_000_000_000)
                                        withAnimation {
                                            showAnswer = true
                                        }
                                        
                                        try await Task.sleep(nanoseconds: 4_000_000_000)

                                        withAnimation {
                                            level += 1
                                        }
                                    }
                                }
                            
                            if !showAnswer {
                                Spacer()
                                
                                Text("아닙니다.")
                                    .padding(.horizontal, 30)
                                    .padding(.vertical, 10)
                                    .background {
                                        Color(hex: "f1f1f1")
                                    }
                                    .clipShape(RoundedRectangle(cornerRadius: .infinity))
                            }
                        }
                        
                        if !showAnswer {
                            Text("카드를 넘깁니다.")
                                .padding(.horizontal, 30)
                                .padding(.vertical, 10)
                                .background {
                                    Color(hex: "f1f1f1")
                                }
                                .clipShape(RoundedRectangle(cornerRadius: .infinity))
                                .padding(.top, 20)
                        }
                    }
                    .frame(height: 180)
                    .padding(.horizontal, 30)
                    .font(.sea(15))
                }

            }

        }
        .onAppear {
            /// Test Code
            service.myUserModel = User.random()
            
            if let user = service.myUserModel {
                users.insert(user, at: 0)
            }
            
            for _ in 0..<5 {
                users.append(User.random())
            }
        }
        .onChange(of: level) { newLevel in
            if newLevel == 3 {
                withAnimation {
                    gameStatus = .onAir
                }
            }
        }
    }
}

#Preview {
    VStack {
        GuideView()

    }
    .environmentObject(Service.shared)
}
