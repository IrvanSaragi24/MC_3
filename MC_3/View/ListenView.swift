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
            VStack {
                
                List(playerData.playerList, id: \.self) { item in
                    Text(item.name)
                }
                .frame(height: 100)
                
                Image(systemName: "waveform.circle")
                    .foregroundColor(.purple)
                    .font(.system(size: 250))
                NavigationLink(
                    destination: AskedView()
                )
                {
                        Label("Quiz Time!", systemImage: "hand.raised.fill")
                }
                .buttonStyle(MultipeerButtonStyle())
                .onTapGesture {
                    
                }
                NavigationLink(
                    destination: AskedView()
                )
                {
                        Label("Stop!", systemImage: "stop.circle.fill")
                }
                .buttonStyle(MultipeerButtonStyle())
                .onTapGesture {
                    
                }
                Spacer()
            }
        }
    }
}

struct ListenView_Previews: PreviewProvider {
    static let player = Player(name: "Player", lobbyRole: .host, gameRole: .noGameRole)
    static var playerData = PlayerData(mainPlayer: player, playerList: [player])
    
    static var previews: some View {
        ListenView()
            .environmentObject(MultipeerController(player.name))
            .environmentObject(playerData)
    }
}
