//
//  GameRoomCreateView.swift
//  LadybugPoker
//
//  Created by 박진서 on 4/6/24.
//

import SwiftUI

struct GameRoomCreateView: View {
    @EnvironmentObject private var service: Service
    
    @State private var title: String = ""
    @State private var maxCount = 0
    @State private var password: String = ""
    
    var body: some View {
        VStack {
            HStack {
                Image("ladybug")
                    .resizable()
                    .frame(width: 27, height: 27)
                
                Text("무당벌레 포커")
                    .font(.sea(15))
                
                Spacer()
            }
            .padding(.horizontal, 15)
            .padding(.vertical, 20)
            .background(Color.bugDarkMedium)
            
            VStack(spacing: 0) {
                TextField("방 제목을 입력해주세요.", text: $title)
                    .font(.sea(20))
                
                Color.bugDark
                    .frame(height: 2)
                    .padding(.top, 10)
                
                HStack {
                    Spacer()
                    
                    Text("\(title.count) / 20")
                        .font(.sea(10))
                        .padding(.top, 5)
                }
            }
            .padding(.horizontal, 33)
            .padding(.top, 50)
            
            HStack {
                Text("최대 인원을 설정해주세요.")
                    .font(.sea(20))
                
                Spacer()
            }
            .padding(.horizontal, 33)
            .padding(.top, 50)
            
            HStack(spacing: 0) {
                ForEach(3..<7, id: \.self) { number in
                    Button {
                        withAnimation {
                            maxCount = number
                        }
                    } label: {
                        Color.bugLightMedium
                            .overlay {
                                Text("\(number)")
                                    .font(.sea(20))
                                    .foregroundStyle(maxCount == number ? Color.black : Color.white)
                            }
       
                    }
                    
                    if number != 6 {
                        Color.white
                            .frame(width: 1, height: 24)
                    }
                }
            }
            .frame(height: 33)
            .background(Color.bugLightMedium)
            .clipShape(RoundedRectangle(cornerRadius: 3))
            .padding(.horizontal, 33)

            VStack(spacing: 0) {
                TextField("비밀번호를 입력해주세요.", text: $password)
                    .font(.sea(20))
                
                Color.bugDark
                    .frame(height: 2)
                    .padding(.top, 10)
                
                HStack {
                    Spacer()
                    
                    Text("입력하지 않으면 공개방이 됩니다.")
                        .font(.sea(10))
                        .padding(.top, 5)
                }
            }
            .padding(.horizontal, 33)
            .padding(.top, 50)
            
            Spacer()

            Button {
                Task {
                    let model = GameRoom(id: UUID().uuidString,
                                         hostId: service.myUserModel.id,
                                         title: title,
                                         password: password,
                                         maxUserCount: maxCount,
                                         code: "ABCDEF",
                                         usersInGame: [service.myUserModel.id:
                                                        UserInGame(id: service.myUserModel.id,
                                                                   readyOrNot: true,
                                                                   handCard: "",
                                                                   boardCard: "",
                                                                   displayName: service.myUserModel.displayName,
                                                                   profileUrl: service.myUserModel.profileUrl, idx: 0)],
                                         whoseGetting: nil,
                                         turnStartTime: nil
                                         )
                    
                    try await GameRoom.create(model: model)
                }
            } label: {
                Color.bugDark
                    .clipShape(RoundedRectangle(cornerRadius: 10))
                    .overlay {
                        Text("방 만들기")
                            .font(.sea(20))
                            .foregroundStyle(Color.white)
                    }
            }
            .frame(height: 50)
            .padding(.horizontal, 20)
                
        }
        .background(Color.bugLight.ignoresSafeArea())
    }
}

#Preview {
    GameRoomCreateView()
}
