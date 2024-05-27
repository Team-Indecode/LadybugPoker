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
                
                VStack {
                    Text(service.myUserModel.displayName)
                    
                    Text("\(service.myUserModel.win)")
                }
            }
            
            HStack {
                Text("게임 히스토리")
                    .font(.sea(18))
                
                Spacer()
            }
            .padding(.horizontal, 25)
            
            
            
            Spacer()
        }
        .background(Color.bugLight)
    }
}

#Preview {
    MyPageView(id: "test")
}
