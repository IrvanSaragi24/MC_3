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
    @EnvironmentObject private var lobbyViewModel: LobbyViewModel
    @State private var isWaiting = false
    @State private var lobby = Lobby(name: "", silentDuration: 10, numberOfQuestion: 1)
    @State private var waitHost = false
    @State private var hideBackButton = false
    @State private var isLobbyViewActive = false
    
    var body: some View {
        NavigationView {
            ZStack {
                Color.clear.backgroundStyle()
                VStack {
                    if isWaiting {
                        if multipeerController.gameState == .listening {
                            ListenView()
                                .environmentObject(lobbyViewModel)
                                .environmentObject(multipeerController)
                                .environmentObject(playerData)
                        }
                        else if multipeerController.gameState == .choosingPlayer {
                            ChoosingView()
                                .environmentObject(lobbyViewModel)
                                .environmentObject(multipeerController)
                                .environmentObject(playerData)
                        }
                        else if multipeerController.gameState == .waitingToStart {
                            WaitingToStartView()
                        }
                        else if multipeerController.gameState == .waitingForInvitation {
                            LoadingView(textWait: "Wait to be invited by the host...",cicleSize: 166, LineWidtCircle: 40, LineWidtCircle2: 35)
                                .padding(.bottom, 200)
                        }
                    }
                    
                    else {
                        Text("HANGOUT MODE")
                            .foregroundColor(Color("Second"))
                            .font(.system(size: 36, weight: .regular))
                            .fontWeight(.bold)
                            .padding(.bottom, 63)
                        
                        Button(action: {
                            multipeerController.isHost = true
                            multipeerController.lobby.name = multipeerController.myPeerId.displayName
                            playerData.mainPlayer.lobbyRole = .host
                            lobbyViewModel.lobby.name = playerData.mainPlayer.name
                            lobby.name = playerData.mainPlayer.name
                            isLobbyViewActive = true // Activate the NavigationLink programmatically
                            
                        }) {
                            ZStack {
                                Circle()
                                    .frame(width: 234)
                                    .foregroundColor(Color("Second"))
                                VStack {
                                    Image(systemName: "crown.fill")
                                        .resizable()
                                        .frame(width: 38, height: 24)
                                    Image(systemName: "person.fill")
                                        .resizable()
                                        .frame(width: 74, height: 74)
                                    Text("HOST")
                                        .font(.system(size: 36, design: .rounded))
                                        .fontWeight(.bold)
                                }
                                .foregroundColor(Color("Main"))
                            }
                        }
                        .padding(.bottom, 63)
                        .background(
                            NavigationLink(
                                destination: LobbyView(lobby: lobby)
                                    .environmentObject(lobbyViewModel)
                                    .environmentObject(multipeerController)
                                    .environmentObject(playerData),
                                isActive: $isLobbyViewActive // Binding to control the NavigationLink
                            ) {
                                EmptyView()
                            }
                        )
                        
                        
                        Button(
                            action: {
                                multipeerController.isAdvertising = true
                                isWaiting = true
                            }, label: {
                                ZStack{
                                    Circle()
                                        .frame(width: 234)
                                        .foregroundColor(Color("Second"))
                                    VStack{
                                        Image(systemName: "person.fill")
                                            .resizable()
                                            .frame(width: 74, height: 74)
                                        Text("GUEST")
                                            .font(.system(size: 36, design: .rounded))
                                            .fontWeight(.bold)
                                    }
                                    .foregroundColor(Color("Main"))
                                }
                            })
                        .onTapGesture {
                            playerData.mainPlayer.lobbyRole = .guest
                            
                        }
                    }
                }
                .onAppear() {
                    if multipeerController.gameState == .reset {
                        multipeerController.isAdvertising = false
                        multipeerController.gameState = .waitingForInvitation
                        lobbyViewModel.lobby = Lobby(name: "", silentDuration: 30, numberOfQuestion: 1)
                        
                    }
                }
            }
        }
        
    }
}

struct WaitingToStartView: View {
    @EnvironmentObject private var multipeerController: MultipeerController
    
    var body: some View {
        VStack{
            Text("You have joined")
                .font(.system(size: 18, weight: .light))
                .foregroundColor(Color("Second"))
            Text("\(multipeerController.hostPeerID?.displayName ?? "Unknown")’s Lobby")
                .font(.system(size: 32, weight: .bold))
                .foregroundColor(Color("Second"))
            RoundedRectangle(cornerRadius: 21)
                .stroke(lineWidth: 2)
                .frame(width: 234, height: 32)
                .overlay {
                    HStack{
                        Image(systemName: "person.3.fill")
                        Text("Total Player")
                        Spacer()
                        Text("\(multipeerController.allGuest.filter { $0.status == .connected }.count)")
                    }
                    .padding()
                    
                }
                .foregroundColor(Color("Second"))
            Image("phone")
                .padding(.top, 20)
        }
        .padding(.top, 40)
        Text("Wait for the host to start...")
            .foregroundColor(Color("Second"))
            .font(.system(size: 30, weight: .light))
            .padding(.top, 50)
        LoadingView(textWait: "", cicleSize: 60, LineWidtCircle: 20, LineWidtCircle2: 15)
    }
}



struct ChooseRoleView_Previews: PreviewProvider {
    static let player = Player(name: "Player", lobbyRole: .noLobbyRole, gameRole: .asked)
    static var playerData = PlayerData(mainPlayer: player, playerList: [player])
    
    static var previews: some View {
        ChooseRoleView()
            .environmentObject(MultipeerController(player.name))
            .environmentObject(playerData)
            .environmentObject(LobbyViewModel())
    }
}
