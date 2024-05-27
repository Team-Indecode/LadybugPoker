//
//  GamePlayAttackView.swift
//  LadybugPoker
//
//  Created by 김라영 on 2024/04/18.
//

import SwiftUI
import NukeUI
import Combine

struct GamePlayAttackDefenceView: View {
    @EnvironmentObject var viewModel: GameRoomDetailViewViewModel
    @StateObject var attackDefenceVM = AttackDefenceViewModel()
    
    let columns = [GridItem(.flexible()), GridItem(.flexible()), GridItem(.flexible()), GridItem(.flexible())]
    
    /// 플레이어 역할
    @State private var player: Player = .attacker
    /// 남은 타이머
    @State private var gameTimer: Int = 48
    /// 공격자가 공격한 벌레
    @State private var attackBug: Bugs? = nil
    /// 공격자가 실제로 선택한 벌레
    @State private var selectBug: Bugs? = nil
    /// 핸드폰 화면 사이즈
    @State private var screenHeight: CGFloat = 700
    @Binding var showView: Bool
    /// 수비자가 선택한 대답
    @State private var defenderChooseAnswer: String? = nil
    /// 수비자가 선택한 대답만 보여주는 애니메이션
    @State private var showDefenderChooseAnser: Bool = false
    /// 공격 결과 나타내줄지
    @State private var showAttackResult: Bool = false
    /// 공격 결과 나타나고 0.3초 뒤에 실제 공격자가 선택한 카드가 돌아갈지
    @State private var startRotation = false
    
    @State private var circleSize = [7.0, 7.0, 7.0]
    @State private var questionCard: Bugs? = nil
    
    /// 스크린 높이에서 top부분이 차지하는 비율
    let screenHeightTop: CGFloat = 0.683
    /// 스크린 높이에서 bottom부분이 차지하는 비율
    let screenHeightBottom: CGFloat = 0.317
    
    var body: some View {
        if #available(iOS 17, *) {
            allContent
                .onChange(of: attackDefenceVM.circleDots, { oldValue, newValue in
                    withAnimation {
                        circleSize = [7.0, 7.0, 7.0]
                        circleSize[newValue % 3] = 12.0
                    }
                })
                .onChange(of: viewModel.userType, { oldValue, userType in
                    if let userType = userType {
                        player = userType
                    }
                })
                .onChange(of: viewModel.showAttackResult.0, { oldValue, newValue in
                    withAnimation {
                        showAttackResult = true
                    }
                    
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.3, execute: {
                        withAnimation {
                            startRotation = true
                        }
                    })
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
                attackDefenceVM.gameTimer()
                attackDefenceVM.circle()
                screenHeight = proxy.size.height
                defenderChooseAnswer = nil
                startRotation = false
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
            playerAttackTopView
                .frame(height: screenHeight * screenHeightTop)
            playerBottomView(false)
                .frame(height: screenHeight * screenHeightBottom)
        }
    }
    
    @MainActor
    /// 플레이어가 수비자일때
    var defenderView: some View {
        VStack {
            playerNotAttackerTopView
                .frame(height: screenHeight * screenHeightTop)
            playerBottomView(true)
                .frame(height: screenHeight * screenHeightBottom)
        }
    }
    
    @MainActor
    /// 플레이어가 공격자/수비자 모두 아닐때
    var othersView: some View {
        VStack(spacing: 0) {
            playerNotAttackerTopView
                .frame(height: screenHeight * screenHeightTop)
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
            HStack(spacing: 5) {
                if let userData = viewModel.getUserData(viewModel.gameRoomData.value.whoseTurn ?? "") {
                    makeUserView(userData)
                }
                Image("attacker")
                    .resizable()
                    .frame(width: 40, height: 40)
                Spacer()
                if !showAttackResult {
                    realSelectCard
                }
            }
            thisCard
            attackOrResult
            Text("입니다.")
                .font(.sea(50))
                .foregroundStyle(Color.white)
            defenderProfileView
            if showAttackResult {
                Text(viewModel.showAttackResult.1 ? "공격 성공" : "공격 실패")
                    .font(.sea(50))
            }
        }
    }
    
    @ViewBuilder
    /// 공격자가 실제로 선택한 카드
    var realSelectCard: some View {
        if let selectBug = selectBug {
            VStack(spacing: 2) {
                Text("고른 카드")
                    .font(.sea(10))
                    .foregroundStyle(Color.white)
                CardView(card: Card(bug: selectBug, cardCnt: 0), cardWidthSize: 40, cardHeightSize: 60, isBottomViewCard: false)
            }
            .padding(.trailing, 20)
        } else {
            EmptyView()
        }
    }
    
    @ViewBuilder
    /// 공격중인지 공격 결과인지
    var attackOrResult: some View {
        // 공격중
        if !showAttackResult {
            if viewModel.gameType == .attacker {
                bugsView
            } else {
                bugAndCard
            }
        } else {
            // 공격 결과
            if let selectBug = selectBug {
                CardView(card: Card(bug: selectBug, cardCnt: 0), cardWidthSize: 86, cardHeightSize: 129, isBottomViewCard: false)
                    .rotationEffect(startRotation ? Angle(degrees: 360) : Angle(degrees: 0))
            }
        }
    }
    
    @MainActor
    /// 플레이어가 수비자 or 그 외 일때 topView
    var playerNotAttackerTopView: some View {
        VStack(spacing: 0) {
            attackerProfileView
            thisCard
            if showAttackResult {
                if let selectBug = selectBug {
                    CardView(card: Card(bug: selectBug, cardCnt: 0), cardWidthSize: 86, cardHeightSize: 129, isBottomViewCard: false)
                        .rotationEffect(startRotation ? Angle(degrees: 360) : Angle(degrees: 0))
                }
            } else {
                bugAndCard
            }
            Text("입니다.")
                .font(.sea(50))
                .foregroundStyle(Color.white)
            defenderProfileView
            if showAttackResult {
                Text(viewModel.showAttackResult.1 ? "공격 성공" : "공격 실패")
                    .font(.sea(50))
            }
        }
    }
    
    var thisCard: some View {
        HStack(spacing: 0) {
            Text("이 카드는")
                .font(.sea(50))
                .foregroundStyle(Color.white)
            ForEach(0..<attackDefenceVM.dots % 5, id: \.self) { _ in
                Text(".")
                    .font(.sea(50))
                    .foregroundStyle(Color.white)
            }
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
                    questionCard = bug
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1.0, execute: {
                        viewModel.gameroomDataUpdate(.questionCard, bug.cardString)
                    })
                }, label: {
                    withAnimation(.easeInOut(duration: 0.5)) {
                        makeBug(bug)
                            .opacity((bug == questionCard && questionCard != nil) || questionCard == nil ? 1 : 0.5)
                    }
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
                dotsInCircle
//                Image(systemName: "ellipsis.circle.fill")
//                    .resizable()
//                    .padding(6)
//                    .foregroundStyle(Color(hex: "D9D9D9"))
//                    .frame(width: 70, height: 70)
//                    .scaledToFit()
//                    .clipShape(Circle())
            }
            
        }
        .padding(.horizontal, 80)
        .padding(.vertical)
    }
    
    var dotsInCircle: some View {
        Circle()
            .fill(Color(hex: "D9D9D9"))
            .frame(width: 70, height: 70)
            .overlay {
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
            }
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
        HStack(spacing: 5) {
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
            if showDefenderChooseAnser {
                Spacer()
            }
            HStack {
                if (showDefenderChooseAnser && defenderChooseAnswer == "y") || !showDefenderChooseAnser {
                    guessText(DefenderAnswer.same.rawValue)
                }
                if (showDefenderChooseAnser && defenderChooseAnswer == "n") || !showDefenderChooseAnser {
                    if !showDefenderChooseAnser {
                        Spacer()
                    }
                    guessText(DefenderAnswer.different.rawValue)
                }
            }
            .padding(.bottom, 26)
            if viewModel.gameRoomData.value.attackers.count != viewModel.gameRoomData.value.usersInGame.count {
                if (showDefenderChooseAnser && defenderChooseAnswer == "p") || !showDefenderChooseAnser {
                    guessText(DefenderAnswer.cardSkip.rawValue)
                }
            }
            if showDefenderChooseAnser {
                Spacer()
            }
        }
        .padding(.top, 30)
        .padding(.horizontal, 10)
    }
    
    /// 수비자가 선택할 text
    func guessText(_ text: String) -> some View {
        return Button(action: {
//            viewModel.defenderSuccessCheck(text)
            Task {
                withAnimation {
                    if text == DefenderAnswer.same.rawValue {
                        defenderChooseAnswer = "y"
                    } else if text == DefenderAnswer.different.rawValue {
                        defenderChooseAnswer = "n"
                    } else if text == DefenderAnswer.cardSkip.rawValue {
                        defenderChooseAnswer = "p"
                    }
                    showDefenderChooseAnser = true
                }
            }
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
