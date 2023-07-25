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
    
    var body: some View {
        NavigationView {
            ZStack {
                Color.clear.backgroundStyle()
                VStack {
                    Text("HANGOUT MODE")
                        .foregroundColor(Color("Second"))
                        .font(.system(size: 36, weight: .regular))
                        .fontWeight(.bold)
                        .padding(.bottom, 63)
                    if isWaiting {
                        switch multipeerController.gameState {
                        case .listening:
                            ListenView()
                                .environmentObject(lobbyViewModel)
                                .environmentObject(multipeerController)
                                .environmentObject(playerData)
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
                            }
                            LoadingView(textWait: "Wait for the host to start...")
                                .padding()
                            ///
//                        case .waitingForInvitation:
                        default:
                            LoadingView(textWait: "Wait to be invited by the host...")
                                .padding(.bottom, 200)
                        }
                    }
                    
                    else {
                        NavigationLink(
                            destination: LobbyView(lobby: lobby)
                                .environmentObject(lobbyViewModel)
                                .environmentObject(multipeerController)
                                .environmentObject(playerData)
                        )
                        {
                            ZStack{
                                Circle()
                                    .frame(width: 234)
                                    .foregroundColor(Color("Second"))
                                VStack{
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
                        .onTapGesture {
                            multipeerController.isHost = true
                            playerData.mainPlayer.lobbyRole = .host
                            lobbyViewModel.lobby.name = playerData.mainPlayer.name
                            lobby.name = playerData.mainPlayer.name
                        }
                        .padding(.bottom, 63)
                        
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
//            .navigationTitle("\(playerData.mainPlayer.name) Choose Your Role")
        }
        
    }
}

//struct LoaderView: View {
//    var tintColor: Color = .blue
//    var scaleSize: CGFloat = 1.0
//
//    var body: some View {
//        ProgressView()
//            .scaleEffect(scaleSize, anchor: .center)
//            .progressViewStyle(CircularProgressViewStyle(tint: tintColor))
//
//    }
//}

struct ChooseRoleView_Previews: PreviewProvider {
    static let player = Player(name: "Player", lobbyRole: .noLobbyRole, gameRole: .asked)
    static var playerData = PlayerData(mainPlayer: player, playerList: [player])
    
    static var previews: some View {
        ChooseRoleView()
            .environmentObject(MultipeerController(player.name))
            .environmentObject(playerData)
    }
}
