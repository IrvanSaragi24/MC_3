//
//  ChooseRoleView.swift
//  MC_3
//
//  Created by Sayed Zulfikar on 18/07/23.
//

import SwiftUI

struct ChooseRoleView: View {
    @EnvironmentObject private var connectionManager: ConnectionManager
    @EnvironmentObject private var playerData: PlayerData
    
    @State private var isWaiting = false
    
    var body: some View {
        NavigationView {
            VStack {
                if isWaiting {
                    Text("Waiting Host")
                    LoaderView(tintColor: .purple, scaleSize: 5.0).padding()
                    
                }
                else {
                    
                    Spacer()
                    
                    NavigationLink(
                        destination: LobbyView()
                        .environmentObject(connectionManager)
                        .environmentObject(playerData)
                    )
                    {
                            Label("Host", systemImage: "house.fill")
                    }
                    .buttonStyle(MultipeerButtonStyle())
                    .onTapGesture {
                        playerData.mainPlayer.role = .host
                    }
                    
                    Spacer()
                    
                    Button(
                        action: {
                            connectionManager.isReceivingHangout = true
                            isWaiting = true
                        }, label: {
                            Label("Guest", systemImage: "paperplane.fill")
                        })
                    .buttonStyle(MultipeerButtonStyle())
                    .onTapGesture {
                        playerData.mainPlayer.role = .guest
                    }
                    
                    Spacer()
                    Spacer()
                }
            }
            .navigationTitle("\(playerData.mainPlayer.name) Choose Your Role")
        }
        
    }
}

struct LoaderView: View {
    var tintColor: Color = .blue
    var scaleSize: CGFloat = 1.0
    
    var body: some View {
        ProgressView()
            .scaleEffect(scaleSize, anchor: .center)
            .progressViewStyle(CircularProgressViewStyle(tint: tintColor))
    }
}

struct ChooseRoleView_Previews: PreviewProvider {
    static let player = Player(name: "Player", role: .noRole)
    static var playerData = PlayerData(mainPlayer: player, playerList: [player])
    
    static var previews: some View {
        ChooseRoleView()
            .environmentObject(ConnectionManager(player.name))
            .environmentObject(playerData)
    }
}
