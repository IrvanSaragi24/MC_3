//
//  ChooseRoleView.swift
//  MC_3
//
//  Created by Sayed Zulfikar on 18/07/23.
//

import SwiftUI

struct ChooseRoleView: View {
    @EnvironmentObject private var multipeerController: MultipeerController
    @EnvironmentObject private var playerData: PlayerData
    
    @State private var isWaiting = false
    @State private var lobby = Lobby(name: "Test", silentDuration: 10, numberOfQuestion: 1)
    
    var body: some View {
        NavigationView {
            VStack {
                if isWaiting {
                    switch multipeerController.gameState {
                    case .listening:
                        ListenView()
                            .environmentObject(multipeerController)
                            .environmentObject(playerData)
                    case .waitingToStart:
                        Text("You have joined \(multipeerController.hostPeerID?.displayName ?? "Unknown")'s Room")
                        Text("Waiting for START!")
                        LoaderView(tintColor: .black, scaleSize: 5.0).padding()
                    case .waitingForInvitation:
                        Text("Waiting for Invitation")
                        LoaderView(tintColor: .purple, scaleSize: 5.0).padding()
                    }
                }
                else {
                    Spacer()
                    
                    NavigationLink(
                        destination: LobbyView(lobby: lobby)
                            .environmentObject(multipeerController)
                            .environmentObject(playerData)
                    )
                    {
                        Label("Host", systemImage: "house.fill")
                    }
                    .buttonStyle(MultipeerButtonStyle())
                    .onTapGesture {
                        multipeerController.isHost = true
                        playerData.mainPlayer.lobbyRole = .host
                        lobby.name = playerData.mainPlayer.name
                    }
                    
                    Spacer()
                    
                    Button(
                        action: {
                            multipeerController.isAdvertising = true
                            isWaiting = true
                        }, label: {
                            Label("Guest", systemImage: "paperplane.fill")
                        })
                    .buttonStyle(MultipeerButtonStyle())
                    .onTapGesture {
                        playerData.mainPlayer.lobbyRole = .guest
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
    static let player = Player(name: "Player", lobbyRole: .noLobbyRole, gameRole: .noGameRole)
    static var playerData = PlayerData(mainPlayer: player, playerList: [player])
    
    static var previews: some View {
        ChooseRoleView()
            .environmentObject(MultipeerController(player.name))
            .environmentObject(playerData)
    }
}
