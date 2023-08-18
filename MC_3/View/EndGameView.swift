//
//  TrainVoiceView.swift
//  MC_3
//
//  Created by Irvan P. Saragi on 16/07/23.
//

import SwiftUI

struct EndGameView: View {
    @EnvironmentObject var lobbyViewModel: LobbyViewModel
    @EnvironmentObject private var multipeerController: MultipeerController
    @EnvironmentObject private var playerData: PlayerData

    var body: some View {
        if multipeerController.gameState == .listening {
            ListenView()
                .environmentObject(lobbyViewModel)
                .environmentObject(multipeerController)
                .environmentObject(playerData)
        } else if multipeerController.gameState == .reset {
            //                ChooseRoleView()
            //                    .environmentObject(playerData)
            //                    .environmentObject(multipeerController)
            //                    .environmentObject(lobbyViewModel)
            HangOutView()
        } else {
            ZStack {
                BubbleView()
                VStack(spacing: 16) {
                    Text("CONTINUE\nHANGOUT?")
                        .font(.system(size: 40, design: .rounded))
                        .fontWeight(.bold)
                        .foregroundColor(Color("Second"))
                        .multilineTextAlignment(.center)
                        .padding(.bottom, 100)
                    if multipeerController.isPlayer {
                        Button {
                            // Reset
                            let connectedGuest = multipeerController.getConnectedPeers()
                            multipeerController.sendMessage(MsgCommandConstant.resetGame, to: connectedGuest)
                            multipeerController.resetGame()
                            // goToChooseRoleView = true
                            print("STOP ")
                        }
                        label: {
                            Text("Continue")
                                .font(.system(size: 28, design: .rounded))
                                .fontWeight(.bold)
                        }
                        .buttonStyle(MultipeerButtonStyle())
                    } else {
                        Text("Waiting for decision..")
                            .font(.system(size: 28, design: .rounded))
                            .fontWeight(.bold)
                            .foregroundColor(Color("Second"))
                            .multilineTextAlignment(.center)
                    }
                }
            }
            .navigationBarBackButtonHidden(true)
        }
    }
}

struct EndGameView_Previews: PreviewProvider {
    static let player = Player(name: "YourDisplayName", lobbyRole: .host, gameRole: .asked)
    static var playerData = PlayerData(mainPlayer: player, playerList: [player])
    static let multipeerController = MultipeerController("YourDisplayName")
    static var previews: some View {
        EndGameView()
            .environmentObject(multipeerController)
            .environmentObject(playerData)
            .environmentObject(LobbyViewModel())
    }
}
