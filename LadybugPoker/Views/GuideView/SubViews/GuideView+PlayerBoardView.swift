//
//  GuideView+PlayerBoardView.swift
//  LadybugPoker
//
//  Created by 박진서 on 5/6/24.
//

import SwiftUI
import NukeUI

extension GuideView {
    struct GuideView_PlayerBoardView: View {
        @State var isLeft: Bool
        @State var user: User
        @Binding var gameStatus: GameStatus
        
        @State var index: Int
                
        var body: some View {
            VStack(alignment: .leading) {
                HStack(spacing: 8) {
                    LazyImage(source: URL(string: user.profileUrl ?? ""))
                        .scaledToFill()
                        .frame(width: 30, height: 30)
                        .clipShape(Circle())
                    
                    VStack(alignment: .leading) {
                        Text(user.displayName)
                        
                        HStack(spacing: 3) {
                            Image("profileCardIcon")

                            Text("\(Int.random(in: 5..<10))장")
                        }
                    }
                    .font(.sea(8))

                }
                
                if gameStatus == .notStarted {
                    Text("준비 완료")
                        .font(.sea(35))
                } else if gameStatus == .onAir {
                    VStack(spacing: 1) {
                        if index == 0 {
                            HStack(spacing: 2) {
                                if !isLeft {
                                    Spacer()
                                }
                                
                                GuideCardView(bug: .snake, count: 0)
                                
                                GuideCardView(bug: .ladybug, count: 0)
                                
                                GuideCardView(bug: .frog, count: 0)
                                
                                GuideCardView(bug: .rat, count: 0)
                                
                                if isLeft {
                                    Spacer()
                                }
                            }
                            
                            HStack(spacing: 2) {
                                if !isLeft {
                                    Spacer()
                                }
                                
                                GuideCardView(bug: .spider, count: 0)
                                
                                GuideCardView(bug: .snail, count: 0)
                                
                                GuideCardView(bug: .worm, count: 0)
                                
                                GuideCardView(bug: .bee, count: 0)
                                
                                if isLeft {
                                    Spacer()
                                }
                            }
                        } else if index == 1 {
                            HStack(spacing: 2) {
                                if !isLeft {
                                    Spacer()
                                }
                                
                                GuideCardView(bug: .snake, count: 2)
                                
                                GuideCardView(bug: .ladybug, count: 1)
                                
                                GuideCardView(bug: .frog, count: 3)
                                
                                GuideCardView(bug: .rat, count: 1)
                                
                                if isLeft {
                                    Spacer()
                                }
                            }
                            
                            HStack(spacing: 2) {
                                if !isLeft {
                                    Spacer()
                                }
                                
                                GuideCardView(bug: .spider, count: 1)
                                
                                GuideCardView(bug: .snail, count: 1)
                                
                                GuideCardView(bug: .worm, count: 3)
                                
                                GuideCardView(bug: .bee, count: 0)
                                
                                if isLeft {
                                    Spacer()
                                }
                            }
                        } else if index == 2 {
                            HStack(spacing: 2) {
                                if !isLeft {
                                    Spacer()
                                }
                                
                                GuideCardView(bug: .snake, count: 1)
                                
                                GuideCardView(bug: .ladybug, count: 1)
                                
                                GuideCardView(bug: .frog, count: 1)
                                
                                GuideCardView(bug: .rat, count: 0)
                                
                                if isLeft {
                                    Spacer()
                                }
                            }
                            
                            HStack(spacing: 2) {
                                if !isLeft {
                                    Spacer()
                                }
                                
                                GuideCardView(bug: .snake, count: 0)
                                
                                GuideCardView(bug: .ladybug, count: 0)
                                
                                GuideCardView(bug: .frog, count: 0)
                                
                                GuideCardView(bug: .rat, count: 0)
                                
                                if isLeft {
                                    Spacer()
                                }
                            }
                            
                        } else if index == 3 {
                            HStack(spacing: 2) {
                                if !isLeft {
                                    Spacer()
                                }
                                
                                GuideCardView(bug: .snake, count: 1)
                                
                                GuideCardView(bug: .ladybug, count: 1)
                                
                                GuideCardView(bug: .frog, count: 0)
                                
                                GuideCardView(bug: .rat, count: 0)
                                
                                if isLeft {
                                    Spacer()
                                }
                            }
                            
                            HStack(spacing: 2) {
                                if !isLeft {
                                    Spacer()
                                }
                                
                                GuideCardView(bug: .spider, count: 1)
                                
                                GuideCardView(bug: .snail, count: 1)
                                
                                GuideCardView(bug: .worm, count: 0)
                                
                                GuideCardView(bug: .bee, count: 0)
                                
                                if isLeft {
                                    Spacer()
                                }
                            }
                        } else if index == 4 {
                            HStack(spacing: 2) {
                                if !isLeft {
                                    Spacer()
                                }
                                
                                GuideCardView(bug: .snake, count: 1)
                                
                                GuideCardView(bug: .ladybug, count: 0)
                                
                                GuideCardView(bug: .frog, count: 0)
                                
                                GuideCardView(bug: .rat, count: 0)
                                
                                if isLeft {
                                    Spacer()
                                }
                            }
                            
                            HStack(spacing: 2) {
                                if !isLeft {
                                    Spacer()
                                }
                                
                                GuideCardView(bug: .spider, count: 1)
                                
                                GuideCardView(bug: .snail, count: 0)
                                
                                GuideCardView(bug: .worm, count: 0)
                                
                                GuideCardView(bug: .bee, count: 0)
                                
                                if isLeft {
                                    Spacer()
                                }
                            }
                        } else if index == 5 {
                            HStack(spacing: 2) {
                                if !isLeft {
                                    Spacer()
                                }
                                
                                GuideCardView(bug: .snake, count: 2)
                                
                                GuideCardView(bug: .ladybug, count: 1)
                                
                                GuideCardView(bug: .frog, count: 1)
                                
                                GuideCardView(bug: .rat, count: 1)
                                
                                if isLeft {
                                    Spacer()
                                }
                            }
                            
                            HStack(spacing: 2) {
                                if !isLeft {
                                    Spacer()
                                }
                                
                                GuideCardView(bug: .spider, count: 1)
                                
                                GuideCardView(bug: .snail, count: 1)
                                
                                GuideCardView(bug: .worm, count: 1)
                                
                                GuideCardView(bug: .bee, count: 0)
                                
                                if isLeft {
                                    Spacer()
                                }
                            }
                        }

                    }

                }

            }
        }
    }
}

#Preview {
    GuideView.GuideView_PlayerBoardView(isLeft: true, user: User.random(), gameStatus: .constant(.onAir), index: 1)
}
