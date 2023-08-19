//
//  ChoosePlayerView.swift
//  MC_3
//
//  Created by Sayed Zulfikar on 22/07/23.
//

import SwiftUI

struct ChoosePlayerView: View {
    @EnvironmentObject var lobbyViewModel: LobbyViewModel
    @EnvironmentObject private var multipeerController: MultipeerController
    @EnvironmentObject private var playerData: PlayerData

    @State var question: String = "Question Default Text"
    @State private var isActive: Bool = false
    @State private var progressValue: Float = 0.0

    private let totalProgress: Float = 100.0
    private let updateInterval: TimeInterval = 0.05
    private let targetProgress: Float = 100.0

    var body: some View {
        NavigationView {
            ZStack {
                BubbleView()
                VStack {
                    VStack(spacing: 30) {
                        Circle()
                            .stroke(Color("Second"), lineWidth: 8)
                            .frame(width: 234)
                            .overlay {
                                Image(systemName: "person.3.fill")
                                    .resizable()
                                    .frame(width: 132, height: 63)
                                    .foregroundColor(Color("Second"))
                            }
                        Text("Choosing...")
                            .font(.system(size: 32, design: .rounded))
                            .fontWeight(.bold)
                            .foregroundColor(Color("Second"))
                        ProgressView(value: progressValue, total: totalProgress)
                            .progressViewStyle(LinearProgressViewStyle(tint: Color("Second")))
                            .frame(width: 234, height: 4)
                            .onAppear {
                                startUpdatingProgress()
                            }
                        ZStack {
                            RoundedRectangle(cornerRadius: 12)
                                .frame(width: 290, height: 168)
                                .foregroundColor(Color("Second"))
                                .overlay {
                                    Text("Siapa yang tadi ngomongin:“tadi bukannya dia dapet Ravenclaw ya?”")
                                        .font(.system(size: 20, design: .rounded))
                                        .fontWeight(.medium)
                                        .multilineTextAlignment(.center)
                                }
                            Capsule()
                                .stroke(Color("Second"), lineWidth: 3)
                                .frame(width: 120, height: 28)
                                .overlay {
                                    Capsule()
                                        .foregroundColor(Color("Background"))
                                    Text("Question")
                                        .foregroundColor(Color("Second"))
                                        .font(.system(size: 16, design: .rounded))
                                        .fontWeight(.bold)
                                }
                                .padding(.bottom, 160)
                            Circle()
                                .stroke(Color("Second"), lineWidth: 4)
                                .frame(width: 50)
                                .overlay {
                                    Circle()
                                        .foregroundColor(Color("Background"))
                                    Text("1/3")
                                        .font(.system(size: 16, design: .rounded))
                                        .fontWeight(.semibold)
                                        .foregroundColor(Color("Second"))
                                }
                                .padding(.top, 170)
                        }
                    }
                }
            }
        }
    }

    func startUpdatingProgress() {
        Timer.scheduledTimer(withTimeInterval: updateInterval, repeats: true) { timer in
            if progressValue < targetProgress {
                progressValue += 1.0
            } else {
                timer.invalidate() // Stop the timer when reaching the target progress
            }
        }
    }
}

struct ChoosePlayerView_Previews: PreviewProvider {
    static let player = Player(name: "Player", lobbyRole: .host, gameRole: .asked)
    static let isReferee = true
    static var playerData = PlayerData(mainPlayer: player, playerList: [player])

    static var previews: some View {
        ChoosePlayerView()
            .environmentObject(MultipeerController(player.name))
            .environmentObject(playerData)
    }
}
