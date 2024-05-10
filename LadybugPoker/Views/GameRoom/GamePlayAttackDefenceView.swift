//
//  GamePlayAttackView.swift
//  LadybugPoker
//
//  Created by 김라영 on 2024/04/18.
//

import SwiftUI
import NukeUI

struct GamePlayAttackDefenceView: View {
    @EnvironmentObject var viewModel: GameRoomDetailViewViewModel
    let columns = [GridItem(.flexible()), GridItem(.flexible()), GridItem(.flexible()), GridItem(.flexible())]

    /// 플레이어 역할
    @State private var player: Player = .attacker
    /// 남은 타이머
    @State private var timer: Int = 48
    /// 공격자가 공격한 벌레
    @State private var attackBug: Bugs? = nil
    @State private var selectBug: Bugs? = nil
    @State private var screenHeight: CGFloat = 700
    @Binding var showView: Bool
    let screenHeightTop: CGFloat = 0.683
    let screenHeightBottom: CGFloat = 0.317
    
    var body: some View {
        if #available(iOS 17, *) {
            allContent
                .onChange(of: viewModel.userType, { oldValue, userType in
                    if let userType = userType {
                        player = userType
                    }
                })
                .onChange(of: viewModel.gameRoomData.value.selectedCard, { oldValue, newValue in
                    switch newValue {
                    case Bugs.bee.cardString: selectBug = .bee
                    case Bugs.frog.cardString: selectBug = .frog
                    case Bugs.ladybug.cardString: selectBug = .ladybug
                    case Bugs.rat.cardString: selectBug = .rat
                    case Bugs.snail.cardString: selectBug = .snail
                    case Bugs.snake.cardString: selectBug = .snake
                    case Bugs.spider.cardString: selectBug = .spider
                    case Bugs.worm.cardString: selectBug = .worm
                    default: selectBug = nil
                    }
                })
        } else {
            allContent
        }
    }
    
    var allContent: some View {
        GeometryReader { proxy in
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
                screenHeight = proxy.size.height
                if let userType = viewModel.userType {
                    player = userType
                }
                switch viewModel.gameRoomData.value.selectedCard {
                case Bugs.bee.cardString: selectBug = .bee
                case Bugs.frog.cardString: selectBug = .frog
                case Bugs.ladybug.cardString: selectBug = .ladybug
                case Bugs.rat.cardString: selectBug = .rat
                case Bugs.snail.cardString: selectBug = .snail
                case Bugs.snake.cardString: selectBug = .snake
                case Bugs.spider.cardString: selectBug = .spider
                case Bugs.worm.cardString: selectBug = .worm
                default: selectBug = nil
                }
            })
            .background(Color.black.opacity(0.5))
        }
        
    }
    
    @MainActor
    /// 플레이어가 공격자 일 때
    var attackerView: some View {
        VStack {
            if viewModel.showAttackResult.0 {
                attackResultView
                    .frame(height: screenHeight * screenHeightTop)
            } else {
                playerAttackTopView
                    .frame(height: screenHeight * screenHeightTop)
            }
            playerBottomView(false)
                .frame(height: screenHeight * screenHeightBottom)
        }
    }
    
    @MainActor
    /// 플레이어가 수비자일때
    var defenderView: some View {
        VStack {
            if viewModel.showAttackResult.0 {
                attackResultView
                    .frame(height: screenHeight * screenHeightTop)
            } else {
                playerNotAttackerTopView
                    .frame(height: screenHeight * screenHeightTop)
            }
            playerBottomView(true)
                .frame(height: screenHeight * screenHeightBottom)
        }
    }
    
    @MainActor
    /// 플레이어가 공격자/수비자 모두 아닐때
    var othersView: some View {
        VStack(spacing: 0) {
            if viewModel.showAttackResult.0 {
                attackResultView
                    .frame(height: screenHeight * screenHeightTop)
            } else {
                playerNotAttackerTopView
                    .frame(height: screenHeight * screenHeightTop)
            }
            
            playerBottomView(false)
                .frame(height: screenHeight * screenHeightBottom)
        }
//        .background(.opacity(1.0))
    }
    
    //MARK: - topView
    @MainActor
    /// 플레이어가 공격자일떄 벌레 선택하는 뷰
    var playerAttackTopView: some View {
        VStack(spacing: 0) {
            HStack {
                if let userData = viewModel.getUserData(viewModel.gameRoomData.value.whoseTurn ?? "") {
                    makeUserView(userData)
                }
                Spacer()
                if let selectBug = selectBug {
                    VStack(spacing: 2) {
                        Text("고른 카드")
                            .font(.sea(10))
                            .foregroundStyle(Color.white)
                        CardView(card: Card(bug: selectBug, cardCnt: 0), cardWidthSize: 40, cardHeightSize: 60, isBottomViewCard: false)
                            
                    }
                    .padding(.trailing, 20)
                }
            }
            Text("이 카드는....")
                .font(.sea(50))
                .foregroundStyle(Color.white)
            if viewModel.gameType == .attacker {
                bugsView
            } else {
                bugAndCard
            }
            
            Text("입니다.")
                .font(.sea(50))
                .foregroundStyle(Color.white)
            defenderProfileView
        }
    }
    
    @MainActor
    /// 플레이어가 수비자 or 그 외 일때 topView
    var playerNotAttackerTopView: some View {
        VStack(spacing: 0) {
            attackerProfileView
            Text("이 카드는....")
                .font(.sea(50))
                .foregroundStyle(Color.white)
            bugAndCard
            Text("입니다.")
                .font(.sea(50))
                .foregroundStyle(Color.white)
            defenderProfileView
        }
    }
    
    ///게임이 종료됨
    var attackResultView: some View {
        VStack(spacing: 0) {
            attackerProfileView
                .padding(.bottom, 15)
            if let selectBug = selectBug {
                CardView(card: Card(bug: selectBug, cardCnt: 0), cardWidthSize: 121, cardHeightSize: 181, isBottomViewCard: false)
                    .padding(.bottom, 15)
            }
           defenderProfileView
            Text(viewModel.showAttackResult.1 ? "공격 성공" : "공격 실패")
                .font(.sea(50))
        }
    }
    
    @MainActor
    /// 유저 프로필 뷰 제작
    func makeUserView(_ user: UserInGame) -> some View {
        return HStack {
            if let profileUrl = user.profileUrl {
                LazyImage(source: URL(string: profileUrl))
                    .scaledToFit()
                    .frame(width: 50, height: 50)
                    .clipShape(Circle())
                    .padding(.leading, 10)
            } else {
                Image(Bugs.ladybug.rawValue)
                    .scaledToFit()
                    .frame(width: 30, height: 30)
                    .clipShape(Circle())
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
                    viewModel.gameroomDataUpdate(.questionCard, bug.cardString)
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
            if let attackBug = viewModel.gameRoomData.value.questionCard {
                if attackBug == Bugs.bee.cardString{
                    makeBug(Bugs.bee)
                } else if attackBug == Bugs.frog.cardString {
                    makeBug(Bugs.frog)
                } else if attackBug == Bugs.ladybug.cardString {
                    makeBug(Bugs.ladybug)
                } else if attackBug == Bugs.rat.cardString {
                    makeBug(Bugs.rat)
                } else if attackBug == Bugs.snake.cardString {
                    makeBug(Bugs.snake)
                } else if attackBug == Bugs.snail.cardString {
                    makeBug(Bugs.snail)
                } else if attackBug == Bugs.spider.cardString {
                    makeBug(Bugs.spider)
                } else if attackBug == Bugs.worm.cardString {
                    makeBug(Bugs.worm)
                }
               
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
    
    var attackerProfileView: some View {
        HStack {
            if let userData = viewModel.getUserData(viewModel.gameRoomData.value.whoseTurn ?? "") {
                UserProfileView(user: userData)
            }
            Spacer()
        }
    }
    
    var defenderProfileView: some View {
        HStack {
            Spacer()
            if let userData = viewModel.getUserData(viewModel.gameRoomData.value.whoseGetting ?? "") {
//                    makeUserView(userData)
                UserProfileView(user: userData)
            }
        }
    }
    
    //MARK: - 바텀
    func playerBottomView(_ isDefender: Bool) -> some View {
        return VStack(spacing: 0) {
            timerView
            if isDefender && viewModel.gameRoomData.value.questionCard != nil {
                cardGuessChooseView
            } else if viewModel.gameRoomData.value.decision != nil && viewModel.gameRoomData.value.questionCard != nil && !isDefender {
                if let decision = viewModel.gameRoomData.value.decision {
                    Spacer()
                    switch decision {
                    case "yes": guessText(DefenderAnswer.same.rawValue)
                    case "no": guessText(DefenderAnswer.different.rawValue)
                    case "pass": guessText(DefenderAnswer.cardSkip.rawValue)
                    default: EmptyView()
                    }
                }
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
            Text("남은 시간: \(viewModel.secondsLeft)")
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
                guessText(DefenderAnswer.same.rawValue)
                Spacer()
                    .frame(width: 70)
                guessText(DefenderAnswer.different.rawValue)
            }
            .padding(.bottom, 26)
            if viewModel.gameRoomData.value.attackers.count != viewModel.gameRoomData.value.usersInGame.count - 1 {
                guessText(DefenderAnswer.cardSkip.rawValue)
            }
            
        }
        .padding(.top, 30)
    }
    
    /// 수비자가 선택할 text
    func guessText(_ text: String) -> some View {
        return Button(action: {
//            viewModel.defenderSuccessCheck(text)
            viewModel.decisionUpdate(text)
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
    GamePlayAttackDefenceView(showView: .constant(false))
}
