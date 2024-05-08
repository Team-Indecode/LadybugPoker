//
//  LevelNineView.swift
//  LadybugPoker
//
//  Created by 박진서 on 5/7/24.
//

import SwiftUI
import NukeUI

extension GuideView {
    struct LevelNineView: View {
        @State var user: User?
        
        @State var firstUser: User
        @State private var dots = 0
        
        @Binding var level: Int
        
        @Binding var showAnswer: Bool
        
        let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
        
        var body: some View {
            VStack {
                if let user {
                    HStack {
                        HStack {
                            LazyImage(source: user.profileUrl, resizingMode: .aspectFill)
                                .scaledToFit()
                                .frame(width: 50, height: 50)
                                .clipShape(Circle())
                            
                            Text(user.displayName)
                                .font(.sea(20))
                                .foregroundStyle(Color.black)
                        }
                        .padding(10)
                        .background(Color.white)
                        .clipShape(RoundedRectangle(cornerRadius: .infinity))
                        
                        Spacer()
                        
                        VStack {
                            Text("고른 카드")
                                .font(.sea(15))
                            
                            GuideCardView(bug: .snake, count: 9)
                                .frame(width: 45, height: 75)
                        }
       
                    }
                    .padding(.horizontal, 20)

                }
                
                HStack(spacing: 0) {
                    Text("이 카드는")
                    
                    ForEach(0..<dots % 5, id: \.self) { number in
                        Text(".")
                    }
                }
                .font(.sea(30))
                .opacity(level != 12 ? 1 : 0)

                if level == 11 || level == 12 {
                    LevelElevenView(showAnswer: $showAnswer, level: $level)
                
                } else {
                    HStack {
                        ForEach([Bugs.snake, Bugs.ladybug, Bugs.frog, Bugs.rat], id: \.rawValue) { bug in
                            Button {
                                withAnimation {
                                    level += 1
                                    
                                }
                            } label: {
                                Circle()
                                    .fill(Color(hex: "d9d9d9"))
                                    .overlay {
                                        Image(bug.rawValue)
                                            .resizable()
                                            .scaledToFit()
                                            .padding(10)
                                    }
                            }
                            .opacity(level == 9 || bug == .rat ? 1 : 0.3)
                            .disabled(bug != .rat)
                        }
                    }
                    .padding(.horizontal, 30)
                    
                    HStack {
                        ForEach([Bugs.spider, Bugs.snail, Bugs.worm, Bugs.bee], id: \.rawValue) { bug in
                            Circle()
                                .fill(Color(hex: "d9d9d9"))
                                .overlay {
                                    Image(bug.rawValue)
                                        .resizable()
                                        .scaledToFit()
                                        .padding(10)
                                }
                                .opacity(level == 9 || bug == .rat ? 1 : 0.3)
                        }
                    }
                    .padding(.horizontal, 30)
                }
                
                Text("입니다.")
                    .font(.sea(30))
                    .opacity(level != 12 ? 1 : 0)

                HStack {
                    Spacer()
                    
                    HStack {
                        LazyImage(source: firstUser.profileUrl, resizingMode: .aspectFill)
                            .scaledToFit()
                            .frame(width: 50, height: 50)
                            .clipShape(Circle())
                        
                        Text(firstUser.displayName)
                            .font(.sea(20))
                            .foregroundStyle(Color.black)
                    }
                    .padding(10)
                    .background(Color.white)
                    .clipShape(RoundedRectangle(cornerRadius: .infinity))
                }
                .padding(.horizontal, 20)
                
            }
            .onReceive(timer) { value in
                if level == 9 || level == 10 {
                    dots += 1
                }
            }
        }
    }
    
    struct LevelElevenView: View {
        @State private var circleSize = [7.0, 7.0, 7.0]
        let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
        @State private var count = 0
        
        @Binding var showAnswer: Bool
        
        @State private var hideElements = false
        
        @State private var angle = 0.0
        
        @State private var showRat = false
        
        @Binding var level: Int
        
        var body: some View {
            VStack {
                HStack {
                    Color(hex: showRat ? Bugs.snake.colorHex : "B99C00")
                        .frame(width: 86, height: 129)
                        .clipShape(RoundedRectangle(cornerRadius: 5))
                        .overlay(alignment: .top) {
                            Circle()
                                .fill(Color.white)
                                .overlay {
                                    if showRat {
                                        Image("snake")
                                            .resizable()
                                            .scaledToFit()
                                            .padding(7)
                                    } else {
                                        Text("?")
                                            .font(.sea(35))
                                            .foregroundStyle(Color.black)
                                    }
             
                                }
                                .padding()
                        }
                        .rotationEffect(.degrees(angle))
                    
                    if !hideElements {
                        Spacer()

                        Circle()
                            .fill(Color(hex: "d9d9d9"))
                            .frame(width: 70, height: 70)
                            .overlay {
                                if count < 3 {
                                    HStack {
                                        Circle()
                                            .fill(Color.black)
                                            .frame(width: circleSize[0], height: circleSize[0])
                                        
                                        Circle()
                                            .fill(Color.black)
                                            .frame(width: circleSize[1], height: circleSize[1])
                                        
                                        Circle()
                                            .fill(Color.black)
                                            .frame(width: circleSize[2], height: circleSize[2])
                                    }
                                } else {
                                    Image("rat")
                                        .resizable()
                                        .scaledToFit()
                                        .padding()
                                }
      
                            }
                    }

                }
                .padding(.horizontal, 60)
            }
            .onReceive(timer) { _ in
                withAnimation {
                    count += 1
                }
            }
            .onChange(of: count) { newValue in
                withAnimation {
                    circleSize = [7.0, 7.0, 7.0]
                    circleSize[newValue % 3] = 12.0
                }
            }
            .onChange(of: showAnswer) { newValue in
                if newValue {
                    Task {
                        try await Task.sleep(nanoseconds: 1_000_000_000)
                        
                        withAnimation {
                            hideElements = true
                        }
                        
                        try await Task.sleep(nanoseconds: 500_000_000)
                        
                        for _ in 0..<360 {
                            withAnimation {
                                angle += 1
                            }
                        }
                        
                        withAnimation {
                            showRat = true
                        }
                        
                        try await Task.sleep(nanoseconds: 1_000_000_000)

                        withAnimation {
                            level += 1
                        }

                    }
                }
            }
        }
    }

}


#Preview {
    GuideView.LevelNineView(user: User.random(), firstUser: User.random(), level: .constant(12), showAnswer: .constant(false))
}
