//
//  MyPageView.swift
//  LadybugPoker
//
//  Created by 박진서 on 4/26/24.
//

import SwiftUI
import NukeUI

struct MyPageView: View {
    @EnvironmentObject private var service: Service
    @State private var histories = [History]()
    
    let id: String
    
    var body: some View {
        VStack {
            HStack {
                Button {
                    service.path.removeLast()
                } label: {
                    Image(systemName: "chevron.left")
                }
                .foregroundStyle(Color.black)
                
                Spacer()
            }
            .padding(.horizontal, 15)
            .padding(.vertical, 20)
            .background(Color.bugDarkMedium)
            .overlay {
                HStack {
                    Image("ladybug")
                        .resizable()
                        .frame(width: 27, height: 27)
                    
                    Text("무당벌레 포커")
                        .font(.sea(15))
                }
            }
            
            HStack {
                Button {
                    
                } label: {
                    Circle()
                        .fill(Color.bugLightMedium)
                        .frame(width: 100, height: 100)
                        .overlay {
                            if let url = service.myUserModel.profileUrl {
                                LazyImage(source: url, resizingMode: .aspectFill)
                                    .clipShape(Circle())
                                    .padding(1)
                            } else {
                                Image("ladybug")
                                    .resizable()
                                    .padding(1)
                            }
                        }
                }
                
                VStack(alignment: .leading) {
                    Text(service.myUserModel.displayName)
                        .font(.sea(25))
                    
                    Text("\(service.myUserModel.win) W \(service.myUserModel.lose) L")
                        .font(.sea(18))
                }
                
                Spacer()
            }
            .padding(.horizontal, 15)
            
            HStack {
                Text("게임 히스토리")
                    .font(.sea(18))
                
                Spacer()
            }
            .padding(.horizontal, 25)
            .padding(.top, 50)
            
            LazyVStack {
                ForEach(histories) { history in
                    VStack {
                        HStack {
                            Text(history.title)

                            Spacer()
                            
                            Text("\(history.userCount) / \(history.maxUserCount)")
                        }
                        .padding(.horizontal, 20)
                        .padding(.vertical, 15)
                        
                        Spacer()
                    }
                    .font(.sea(15))
                    .frame(height: 100)
                    .overlay {
                        Text(history.isWinner ? "WIN" : "LOSE")
                            .font(.sea(50))
                    }
                    .background {
                        ZStack {
                            Color.bugLight
                            
                            Color.black.opacity(0.3)
                        }
                    }
                    .clipShape(RoundedRectangle(cornerRadius: 15))
                    .padding(.horizontal, 20)
                    .padding(.vertical, 7)
                }
            }
            
            Spacer()
        }
        .background(Color.bugLight)
        .onAppear {
            Task {
                histories = try await History.fetchList(id: id, nil)
            }
        }
    }
}

#Preview {
    MyPageView(id: "test")
}
