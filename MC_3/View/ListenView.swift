//
//  ListenView.swift
//  MC_3
//
//  Created by Sayed Zulfikar on 19/07/23.
//

import SwiftUI

struct ListenView: View {
    @EnvironmentObject private var multipeerController: MultipeerController
    @EnvironmentObject private var playerData: PlayerData
    var body: some View {
        NavigationView {
            if multipeerController.gameState == .choosingPlayer {
                ChoosePlayerView()
                    .environmentObject(multipeerController)
                    .environmentObject(playerData)
            }
            else {
                VStack {
                    Spacer()
                    Image(systemName: "waveform.circle")
                        .foregroundColor(.purple)
                        .font(.system(size: 250))
                    NavigationLink(
                        destination: ChoosePlayerView()
                            .environmentObject(multipeerController)
                            .environmentObject(playerData)
                    )
                    {
                        Label("Quiz Time!", systemImage: "hand.raised.fill")
                    }
                    .buttonStyle(MultipeerButtonStyle())
                    .onTapGesture {
                        //send broadcast message to other peer to change the screen
                        let connectedGuest = multipeerController.allGuest
                            .filter { $0.status == .connected }
                            .map { $0.id }
                        
                        multipeerController.sendMessage(MsgCommandConstant.startQuiz, to: connectedGuest)
                    }
                    NavigationLink(
                        destination: HangOutView()
                    )
                    {
                        Label("Stop!", systemImage: "stop.circle.fill")
                    }
                    .buttonStyle(MultipeerButtonStyle())
                    .onTapGesture {
                        multipeerController.stopBrowsing()
                        multipeerController.isAdvertising = false
                    }
                    Spacer()
                }
            }
        }
    }
}

struct ListenView_Previews: PreviewProvider {
    static let player = Player(name: "Player", lobbyRole: .host, gameRole: .asked)
    static var playerData = PlayerData(mainPlayer: player, playerList: [player])
    
    static var previews: some View {
        ListenView()
            .environmentObject(MultipeerController(player.name))
            .environmentObject(playerData)
    }
}
