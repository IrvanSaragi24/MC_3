//
//  LobbyView.swift
//  MC_3
//
//  Created by Sayed Zulfikar on 18/07/23.
//

import SwiftUI
import MultipeerConnectivity

struct LobbyViewX: View {
    @State private var lobbyName: String = ""
    @State private var silentDuration: Int = 0
    @State private var showingResultView = false
    
    @EnvironmentObject private var multipeerController: MultipeerController
    @EnvironmentObject private var playerData: PlayerData
    
    var body: some View {
        NavigationView {
            VStack(alignment: .leading) {
                Text("Lobby Name:")
                
                TextField("Enter Lobby Name", text: $lobbyName)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                
                
                Text("Silent Duration")
                TextField("Enter Silent Duration Rime", value: $silentDuration, formatter: NumberFormatter())
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .keyboardType(.numberPad)
                
                
                Button(action: {
                    showingResultView = true
                }) {
                    Text("Create Lobby")
                        .font(.headline)
                        .padding()
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }
                .sheet(isPresented: $showingResultView) {
                    //                    LobbyInviteView(lobby: Lobby(name: lobbyName, date: Date.now, silentDuration: silentDuration))
                }
                Spacer()
            }
            .padding()
            .navigationTitle("Lobby")
            
        }
    }
}


struct LobbyView: View {
    @State var lobby: Lobby
    @EnvironmentObject var multipeerController: MultipeerController
    @EnvironmentObject private var playerData: PlayerData
    @State private var navigateToAskedView = false

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
                    navigateToAskedView = true
                    
                } label: {
                    Label("Start!", systemImage: "stop.circle.fill")
                }
                .buttonStyle(MultipeerButtonStyle())
                .padding()

                Spacer() // Optional spacer to push the button to the bottom
            }
            .background(
                NavigationLink(
                    destination: ListenView(),
                    isActive: $navigateToAskedView
                ) {
                    EmptyView()
                }
            )
        }
    }
}

struct LobbyView_Previews: PreviewProvider {
    static let player = Player(name: "Player", lobbyRole: .noLobbyRole, gameRole: .noGameRole)
    static var playerData = PlayerData(mainPlayer: player, playerList: [player])
    
    static var lobby = Lobby(name: player.name, silentDuration: 10, numberOfQuestion: 1)
    
    static var previews: some View {
        LobbyView(lobby: lobby)
            .environmentObject(MultipeerController(player.name))
            .environmentObject(playerData)
    }
}
