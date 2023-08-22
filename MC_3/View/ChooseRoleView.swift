//
//  ChooseRoleView.swift
//  MC_3
//
//  Created by Sayed Zulfikar on 18/07/23.
//

import SwiftUI

struct ChooseRoleView: View {
    @EnvironmentObject private var multipeerController: MultipeerController
    @StateObject private var lobbyViewModel = LobbyViewModel()
    @State private var isWaitingInvitationViewActive = false
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
                        .padding(.bottom, 63)
                        .accessibilityIdentifier("hangoutModeTitleLabel")
                    Button(action: {
                        multipeerController.isHost = true
                        lobbyViewModel.lobby.name = multipeerController.myPeerId.displayName
                        isLobbyViewActive = true
                    }, label: {
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
                    })
                    .accessibilityIdentifier("chooseHostButton")
                    .padding(.bottom, 63)
                    .navigationDestination(isPresented: $isLobbyViewActive) {
                        LobbyView()
                        .environmentObject(multipeerController)
                        .environmentObject(lobbyViewModel)
                    }
                    Button(
                        action: {
                            isWaitingInvitationViewActive = true
                        }, label: {
                            ZStack {
                                Circle()
                                    .frame(width: 234)
                                    .foregroundColor(Color("Second"))
                                VStack {
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
                    .accessibilityIdentifier("chooseGuestButton")
                    .navigationDestination(isPresented: $isWaitingInvitationViewActive) {
                        WaitingForInvitationView()
                        .environmentObject(multipeerController)
                    }
                }
            }
            .onAppear {
                multipeerController.resetNavigateVar()
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
            .environmentObject(LobbyViewModel())
    }
}
