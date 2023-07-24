//
//  LobbyView.swift
//  MC_3
//
//  Created by Sayed Zulfikar on 18/07/23.
//

import SwiftUI
import MultipeerConnectivity

struct LobbyView: View {
    @State var lobby: Lobby
    @EnvironmentObject var multipeerController: MultipeerController
    @EnvironmentObject private var playerData: PlayerData
    @State private var navigateToListenView = false

    var body: some View {
        NavigationView { // Add the main NavigationView here
            VStack {
                List {
                    HStack {
                        Text("Silent Duration:")
                        Spacer()
                        TextField("Silent Duration", value: $lobby.silentDuration, formatter: NumberFormatter())
                            .keyboardType(.numberPad)
                    }
                    HStack {
                        Text("Number of question:")
                        Spacer()
                        TextField("Number of question", value: $lobby.numberOfQuestion, formatter: NumberFormatter())
                            .keyboardType(.numberPad)
                    }
                    HStack {
                        Image(systemName: "person.3.fill")
                        Text("TOTAL PLAYER: ")
                        Spacer()
                        Text("\(multipeerController.allGuest.filter { $0.status == .connected }.count)")
                        
                    }
                    
                    Section(
                        header: HStack(spacing: 8) {
                            Text("All Guests")
                            Spacer()
                            ProgressView()
                        }) {
                            ForEach(multipeerController.allGuest, id: \.self) { guest in
                                HStack {
                                    Text(guest.id.displayName)
                                        .font(.headline)
                                    Spacer()
                                    Text(guest.status.stringValue)
                                        .font(.headline)
                                    Spacer()
                                    Image(systemName: "arrowshape.turn.up.right.fill")
                                }
                                .onTapGesture {
                                    multipeerController.invitePeer(guest.id, to: lobby)
                                }
                            }
                            
                        }
                }
                .listStyle(InsetGroupedListStyle())
                .navigationTitle("\(lobby.name)'s Lobby")
                .onAppear {
                    multipeerController.startBrowsing()
                }
                .onDisappear {
                    multipeerController.stopBrowsing()
                }

                // Button to navigate to the next page
                Button {
                    let connectedGuest = multipeerController.allGuest
                        .filter { $0.status == .connected }
                        .map { $0.id }
                    
                    multipeerController.sendMessage("START LISTEN", to: connectedGuest)
                    navigateToListenView = true
                    
                } label: {
                    Label("Start!", systemImage: "stop.circle.fill")
                }
                .buttonStyle(MultipeerButtonStyle())
                .padding()

                Spacer() // Optional spacer to push the button to the bottom
            }
            .background(
                NavigationLink(
                    destination: ListenView()
                        .environmentObject(multipeerController)
                        .environmentObject(playerData),
                    isActive: $navigateToListenView
                ) {
                    EmptyView()
                }
            )
        }
    }
    
    
}

struct LobbyView_Previews: PreviewProvider {
    static let player = Player(name: "Player", lobbyRole: .noLobbyRole, gameRole: .asked)
    static var playerData = PlayerData(mainPlayer: player, playerList: [player])
    
    static var lobby = Lobby(name: player.name, silentDuration: 10, numberOfQuestion: 1)
    
    static var previews: some View {
        LobbyView(lobby: lobby)
            .environmentObject(MultipeerController(player.name))
            .environmentObject(playerData)
    }
}
