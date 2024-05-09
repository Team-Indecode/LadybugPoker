//
//  LevelSixteenView.swift
//  LadybugPoker
//
//  Created by 박진서 on 5/8/24.
//

import SwiftUI
import NukeUI

extension GuideView {
    struct LevelSixteenView: View {
        @State var user: User?
        
        @State var firstUser: User
        
        @Binding var showAnswerSixteen: Bool
        
        @State private var dots = 0
        
        @State private var showRat = false
        @State private var hideElements = false
        
        @State private var circleSize = [7.0, 7.0, 7.0]
        
        @State private var angle = 0.0
        @State private var count = 0
        
        @Binding var level: Int
                
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
                
                HStack {
                    Color(hex: showRat ? Bugs.frog.colorHex : "B99C00")
                        .frame(width: 86, height: 129)
                        .clipShape(RoundedRectangle(cornerRadius: 5))
                        .overlay(alignment: .top) {
                            Circle()
                                .fill(Color.white)
                                .overlay {
                                    if showRat {
                                        Image("frog")
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
                                if count < 4 {
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
                                    Image("frog")
                                        .resizable()
                                        .scaledToFit()
                                        .padding()
                                }
      
                            }
                    }

                }
                .padding(.horizontal, 60)
                
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
                dots += 1

                withAnimation {
                    count += 1
                    
                    if count == 5 {
                        level += 1
                    }
                }
            }
            .onChange(of: dots) { newValue in
                withAnimation {
                    circleSize = [7.0, 7.0, 7.0]
                    circleSize[newValue % 3] = 12.0
                }
            }
            .onChange(of: showAnswerSixteen) { newValue in
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
                        
                        try await Task.sleep(nanoseconds: 3_000_000_000)

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
    GuideView.LevelSixteenView(user: User.random(), firstUser: User.random(), showAnswerSixteen: .constant(false), level: .constant(17))
}
