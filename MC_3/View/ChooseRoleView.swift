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
    @StateObject var lobbyViewModel = LobbyViewModel()
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
                    Text("HANGOUT MODE")
                        .foregroundColor(Color("Second"))
                        .font(.system(size: 36, weight: .regular))
                        .fontWeight(.bold)
//                        .padding(.top, 40)
                    if isWaiting {
                        switch multipeerController.gameState {
                        case .listening:
                            ListenView()
                                .environmentObject(lobbyViewModel)
                                .environmentObject(multipeerController)
                                .environmentObject(playerData)
                                .padding(.bottom, 100)
                        case .choosingPlayer:
                            ChoosePlayerView()
                                .environmentObject(lobbyViewModel)
                                .environmentObject(multipeerController)
                                .environmentObject(playerData)
                        case .waitingToStart:
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
                                Image("Phone")
                                    .padding(.top, 20)
                            }
                            .padding(.top, 40)
                            Text("Wait for the host to start...")
                                .foregroundColor(Color("Second"))
                                .font(.system(size: 30, weight: .light))
                                .padding(.top, 50)
                            LoadingView(textWait: "", cicleSize: 38, LineWidtCircle: 5, LineWidtCircle2: 3)

                           
                        case .waitingForInvitation:
                            LoadingView(textWait: "Wait to be invited by the host...",cicleSize: 166, LineWidtCircle: 40, LineWidtCircle2: 35)
                                .padding(.bottom, 200)
                            
//                        default:
//                            LoadingView(textWait: "Wait to be invited by the host...")
//                                .padding(.bottom, 200)
                        }
                    }
                    
                    else {
                        Button(action: {
                            multipeerController.isHost = true
                            playerData.mainPlayer.lobbyRole = .host
                            lobbyViewModel.lobby.name = playerData.mainPlayer.name
                            lobby.name = playerData.mainPlayer.name
                            print(multipeerController.isHost)
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
                                        .font(.system(size: 36, weight: .bold))
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
                                            .font(.system(size: 36, weight: .bold))
                                    }
                                    .foregroundColor(Color("Main"))
                                }
                            })
                        .onTapGesture {
                            playerData.mainPlayer.lobbyRole = .guest
                            
                        }
                    }
                }
            }
        }
        
    }
}



struct ChooseRoleView_Previews: PreviewProvider {
    static let player = Player(name: "Player", lobbyRole: .noLobbyRole, gameRole: .asked)
    static var playerData = PlayerData(mainPlayer: player, playerList: [player])
    
    static var previews: some View {
        ChooseRoleView()
            .environmentObject(MultipeerController(player.name))
            .environmentObject(playerData)
    }
}
