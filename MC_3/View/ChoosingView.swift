//
//  SwiftUIView.swift
//  MC_3
//
//  Created by Irvan P. Saragi on 25/07/23.
//

import SwiftUI

struct ChoosingView: View {
    @StateObject var hapticViewModel = HapticViewModel()
    @EnvironmentObject var lobbyViewModel: LobbyViewModel
    @EnvironmentObject private var multipeerController: MultipeerController
    @EnvironmentObject private var playerData: PlayerData
    @State var question: String = "Question Default Text"
    @State private var timerIsDone: Bool = false
    
    @State private var progressValue: Float = 0.0
    private let totalProgress: Float = 100.0
    private let updateInterval: TimeInterval = 0.05
    private let targetProgress: Float = 100.0
    
    var body: some View {
        ZStack{
            BubbleView()
            VStack(spacing : 30){
                Circle()
                    .stroke(Color("Second"), lineWidth : 8)
                    .frame(width: 234)
                    .overlay {
                        Image(systemName: "person.3.fill")
                            .resizable()
                            .frame(width: 132, height: 63)
                            .foregroundColor(Color("Second"))
                    }
                Text("Choosing...")
                    .font(.system(size: 32, weight: .bold))
                    .foregroundColor(Color("Second"))
                ProgressView(value: progressValue, total: totalProgress)
                    .progressViewStyle(LinearProgressViewStyle(tint: Color("Second")))
                    .frame(width: 234, height: 4)
                    .onAppear {
                        startUpdatingProgress()
                    }
                ZStack{
                    RoundedRectangle(cornerRadius: 12)
                        .frame(width: 290, height: 168)
                        .foregroundColor(Color("Second"))
                        .overlay {
                            Text(question)
                                .font(.system(size: 20, weight: .medium))
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
                                .font(.system(size: 16, weight: .bold))
                        }
                        .padding(.bottom, 160)
                    Circle()
                        .stroke(Color("Second"), lineWidth : 4)
                        .frame(width: 50)
                        .overlay{
                            Circle()
                                .foregroundColor(Color("Background"))
                            Text("\(lobbyViewModel.lobby.currentQuestionIndex) / \(lobbyViewModel.lobby.numberOfQuestion)")
                                .font(.system(size: 16, weight: .semibold))
                                .foregroundColor(Color("Second"))
                            
                        }
                        .padding(.top, 170)
                    
                }
                NavigationLink(
//                    destination: AskedView(question: $question)
//                        .environmentObject(lobbyViewModel)
//                        .environmentObject(multipeerController)
//                        .environmentObject(playerData),
                    destination: RefereeView()
                        .environmentObject(lobbyViewModel)
                        .environmentObject(multipeerController)
                        .environmentObject(playerData),
                    isActive: $timerIsDone,
                    label: {
                        EmptyView()
                })
            }
        }
        .onAppear() {
            // Trigger haptic feedback with the custom pattern
            hapticViewModel.triggerThrillingHaptic()
            
            randomPlayer()
            
        }
        .onReceive(multipeerController.$receivedQuestion) { receivedQuestion in
            if multipeerController.hostPeerID != nil {
                DispatchQueue.main.async {
                    self.question = receivedQuestion
                }
            } else {
                DispatchQueue.main.async {
                    self.question = lobbyViewModel.lobby.question ?? "Default Question Text"
                }
            }
        }
    }
    func startUpdatingProgress() {
        Timer.scheduledTimer(withTimeInterval: updateInterval, repeats: true) { timer in
            if progressValue < targetProgress {
                progressValue += 1.0
            } else {
                timer.invalidate()
                timerIsDone = true
            }
        }
    }
    
    func randomPlayer() {
//        yg host2 aja
        if multipeerController.isHost {
            
            var connectedGuest = multipeerController.getConnectedPeers()
            let randomInt = Int.random(in: 0...connectedGuest.count)
            
            if randomInt == connectedGuest.count {
                // host jadi player
                multipeerController.isPlayer = true
            }
            else {
                let thePlayer = connectedGuest[randomInt]
                multipeerController.sendMessage(MsgCommandConstant.updatePlayerTrue, to: [thePlayer])
            }
        }
    }
}


struct ChoosingView_Previews: PreviewProvider {
    static var previews: some View {
        let player = Player(name: "Player", lobbyRole: .host, gameRole: .asked)
        let playerData = PlayerData(mainPlayer: player, playerList: [player])
        let lobbyViewModel = LobbyViewModel()
        let multipeerController = MultipeerController("YourDisplayName")

        ChoosingView()
            .environmentObject(lobbyViewModel)
            .environmentObject(multipeerController)
            .environmentObject(playerData)
    }
}
