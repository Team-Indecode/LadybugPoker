//
//  GamePlayAttackView.swift
//  LadybugPoker
//
//  Created by 김라영 on 2024/04/18.
//

import SwiftUI
import NukeUI

struct GamePlayAttackDefenceView: View {
    let columns = [GridItem(.flexible()), GridItem(.flexible()), GridItem(.flexible()), GridItem(.flexible())]

//    let player: Player = .others
//    let player: Player = .defender
    /// 플레이어 역할
    let player: Player = .attacker
    /// 남은 타이머
    @State private var timer: Int = 48
    /// 공격자가 선택한 벌레
    @State private var attackBug: Bugs? = nil
    @State private var screenHeight: CGFloat = 700
    
    var body: some View {
        GeometryReader(content: { geometry in
            VStack {
                switch player {
                case .attacker:
                    attackerView
                case .defender:
                    defenderView
                case .others:
                    othersView
                }
            }
            .onAppear(perform: {
                screenHeight = geometry.size.height
            })
            .background(.opacity(1.0))
        })
    }
    
    @MainActor
    /// 플레이어가 공격자 일 때
    var attackerView: some View {
        VStack {
            playerAttackTopView
                .frame(height: screenHeight * 0.6706)
            playerBottomView(false)
                .frame(height: screenHeight * 0.3294)
        }
        .background(.opacity(1.0))
    }
    
    @MainActor
    /// 플레이어가 수비자일때
    var defenderView: some View {
        VStack {
            playerNotAttackerTopView
                .frame(height: screenHeight * 0.6706)
            playerBottomView(true)
                .frame(height: screenHeight * 0.3294)
        }
        .background(.opacity(1.0))
    }
    
    @MainActor
    /// 플레이어가 공격자/수비자 모두 아닐때
    var othersView: some View {
        VStack {
            playerNotAttackerTopView
                .frame(height: screenHeight * 0.6706)
            playerBottomView(false)
                .frame(height: screenHeight * 0.3294)
        }
        .background(.opacity(1.0))
    }
    
    //MARK: - topView
    @MainActor
    /// 플레이어가 공격자일떄 벌레 선택하는 뷰
    var playerAttackTopView: some View {
        VStack(spacing: 0) {
            HStack {
                makeUserView(User(id: "", displayName: "라영", profileUrl: "https://picsum.photos/200"))
                Spacer()
            }
            Text("이 카드는....")
                .font(.sea(50))
                .foregroundStyle(Color.white)
            bugsView
            Text("입니다.")
                .font(.sea(50))
                .foregroundStyle(Color.white)
            HStack {
                Spacer()
                makeUserView(User(id: "", displayName: "fkdud", profileUrl: "https://picsum.photos/200"))
            }
        }
    }
    
    @MainActor
    /// 플레이어가 수비자 or 그 외 일때 topView
    var playerNotAttackerTopView: some View {
        VStack(spacing: 0) {
            HStack {
                makeUserView(User(id: "", displayName: "라영", profileUrl: "https://picsum.photos/200"))
                Spacer()
            }
            Text("이 카드는....")
                .font(.sea(50))
                .foregroundStyle(Color.white)
            bugAndCard
            Text("입니다.")
                .font(.sea(50))
                .foregroundStyle(Color.white)
            HStack {
                Spacer()
                makeUserView(User(id: "", displayName: "fkdud", profileUrl: "https://picsum.photos/200"))
            }
        }
    }
    
    @MainActor
    /// 유저 프로필 뷰 제작
    func makeUserView(_ user: User) -> some View {
        return HStack {
            if let profileUrl = user.profileUrl {
                LazyImage(url: URL(string: profileUrl))
                    .scaledToFit()
                    .frame(width: 50, height: 50)
                    .clipShape(Circle())
                    .padding(.leading, 10)
            }
            Text(user.displayName)
                .font(.sea(20))
        }
        .frame(width: 171, height: 69, alignment: .leading)
        .background(Color.white)
        .clipShape(Capsule())
        .padding(.horizontal, 10)
    }
    
    /// 전체 벌레(공격자가 벌레 선택하는 뷰)
    var bugsView: some View {
        LazyVGrid(columns: columns) {
            ForEach(Bugs.allCases, id: \.self) { bug in
                Button(action: {
                    attackBug = bug
                    print(#fileID, #function, #line, "- 공격자가 선택한 벌레: \(String(describing: attackBug?.id))")
                }, label: {
                    makeBug(bug)
                })
            }
        }
        .padding(.horizontal, 40)
        .padding(.vertical)
    }
    
    /// 수비자/그 외가 보는 뷰
    var bugAndCard: some View {
        HStack {
            cardView
            Spacer()
            if let attackBug = attackBug {
                makeBug(attackBug)
            } else {
                Image(systemName: "ellipsis.circle.fill")
                    .resizable()
                    .padding(6)
                    .foregroundStyle(Color(hex: "D9D9D9"))
                    .frame(width: 70, height: 70)
                    .scaledToFit()
                    .clipShape(Circle())
            }
            
        }
        .padding(.horizontal, 80)
        .padding(.vertical)
    }
    
    /// 벌레 뷰 만들기
    func makeBug(_ bug: Bugs) -> some View {
        Image(bug.id)
            .resizable()
            .padding(6)
            .frame(width: 70, height: 70)
            .scaledToFit()
            .background(Color(hex: "D9D9D9"))
            .clipShape(Circle())
    }
    
    /// ? 카드 제작
    var cardView: some View {
        VStack {
            Text("?")
                .font(.sea(35))
                .frame(width: 45, height: 45)
                .background(Color(hex: "FFF2E1"))
                .clipShape(Circle())
                .padding(.top, 10)
            Spacer()
        }
        .frame(width: 86, height: 129)
        .background(Color(hex: "B99C00"))
        .clipShape(RoundedRectangle(cornerRadius: 6))
    }
    
    //MARK: - 바텀
    func playerBottomView(_ isDefender: Bool) -> some View {
        return VStack(spacing: 0) {
            timerView
            if isDefender {
                cardGuessChooseView
            }
            Spacer()
        }
    }
    
    /// 타이머
    var timerView: some View {
        ZStack {
            Text("내 차례 입니다!")
                .font(.sea(10))
                .foregroundStyle(Color(hex: "494949"))
                .frame(maxWidth: .infinity, alignment: .leading)
            Text("남은 시간: \(timer)")
                .font(.sea(15))
                .foregroundStyle(Color(hex: "393939"))
        }
        .padding(.vertical, 3)
        .background(Color(hex: "D1BB9E"))
    }
    
    /// 수비자가 해당 카드가 공격자가 말한 벌레가 맞는지 아닌지 판단
    var cardGuessChooseView: some View {
        VStack {
            HStack {
                guessText("맞습니다.")
                Spacer()
                    .frame(width: 70)
                guessText("아닙니다.")
            }
            .padding(.bottom, 26)
            guessText("카드를 넘깁니다.")
        }
        .padding(.top, 30)
    }
    
    /// 수비자가 선택할 text
    func guessText(_ text: String) -> some View {
        return Button(action: {
            print(#fileID, #function, #line, "- 수비자가 선택한 text: \(text)")
        }, label: {
            Text(text)
                .font(.sea(20))
                .padding(.horizontal, 30)
                .background(Color(hex: "F1F1F1"))
                .clipShape(Capsule())
        })
        
    }
}

#Preview {
    GamePlayAttackDefenceView()
}
