//
//  New_ChoosingView.swift
//  MC_3
//
//  Created by Sayed Zulfikar on 30/07/23.
//

import SwiftUI

struct New_ChoosingView: View {
    @StateObject var hapticViewModel = HapticViewModel()
    @EnvironmentObject var lobbyViewModel: LobbyViewModel
    @EnvironmentObject private var multipeerController: MultipeerController
    
//    @State private var timerIsDone: Bool = false
    
    @State private var progressValue: Float = 0.0
    private let totalProgress: Float = 100.0
    private let updateInterval: TimeInterval = 0.03
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
                    .font(.system(size: 32, weight: .bold, design: .rounded))
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
                            Text(multipeerController.receivedQuestion)
                                .font(.system(size: 20, weight: .medium, design: .rounded))
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
                                .font(.system(size: 16, weight: .bold, design: .rounded))
                        }
                        .padding(.bottom, 160)
                    Circle()
                        .stroke(Color("Second"), lineWidth : 4)
                        .frame(width: 50)
                        .overlay{
                            Circle()
                                .foregroundColor(Color("Background"))
                            Text("\(lobbyViewModel.lobby.currentQuestionIndex) / \(lobbyViewModel.lobby.numberOfQuestion)")
                                .font(.system(size: 16, weight: .semibold, design: .rounded))
                                .foregroundColor(Color("Second"))
                            
                        }
                        .padding(.top, 170)
                    
                }
            }
            .background(
                NavigationLink(
                    destination: New_RefereeView()
                        .environmentObject(multipeerController)
                        .environmentObject(lobbyViewModel),
                    isActive: $multipeerController.navigateToReferee
                ) {
                    EmptyView()
                }
            )
        }
        .navigationBarBackButtonHidden(true)
        .background(
            NavigationLink(
                destination: New_PlayerView()
                    .environmentObject(multipeerController)
                    .environmentObject(lobbyViewModel),
                isActive: $multipeerController.navigateToPlayer
            ) {
                EmptyView()
            }
        )
        .onAppear() {
            multipeerController.resetNavigateVar()
            // Trigger haptic feedback with the custom pattern
            hapticViewModel.triggerThrillingHaptic()
            
            randomPlayer()
            
        }
    }
    func startUpdatingProgress() {
        Timer.scheduledTimer(withTimeInterval: updateInterval, repeats: true) { timer in
            if progressValue < targetProgress {
                progressValue += 1.0
            } else {
                timer.invalidate()
//                timerIsDone = true
                if multipeerController.isPlayer {
                    multipeerController.navigateToPlayer = true
                }
                else {
                    multipeerController.navigateToReferee = true
                }
            }
        }
    }
    
    func randomPlayer() {
//        yg host2 aja, choose a player and broadcast the message
        if multipeerController.isHost {
            
            var connectedGuest = multipeerController.getConnectedPeers()
            let randomInt = Int.random(in: 0...connectedGuest.count)
            var playerName = "Player"
            if randomInt == connectedGuest.count {
                // host jadi player
                multipeerController.isPlayer = true
                playerName = multipeerController.myPeerId.displayName
            }
            else {
                let thePlayer = connectedGuest[randomInt]
                playerName = thePlayer.displayName
                multipeerController.sendMessage(MsgCommandConstant.updatePlayerTrue, to: [thePlayer])
            }
            multipeerController.currentPlayer = playerName
            playerName = MsgCommandConstant.updateCurrentPlayer + playerName
            multipeerController.sendMessage(playerName, to: connectedGuest)
            
        }
    }
}


struct New_ChoosingView_Previews: PreviewProvider {
    static var previews: some View {

        New_ChoosingView()
            .environmentObject(LobbyViewModel())
            .environmentObject(MultipeerController("YourDisplayName"))
    }
}
