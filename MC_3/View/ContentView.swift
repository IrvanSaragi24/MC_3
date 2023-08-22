//
//  ContentView.swift
//  MC_3
//
//  Created by Irvan P. Saragi on 14/07/23.
//

import SwiftUI

struct ContentView: View {
    @State private var playerData: PlayerData?
    @State private var multipeerController: MultipeerController?

    var defaultPlayer = Player(name: "Player", lobbyRole: .noLobbyRole, gameRole: .referee)

    @StateObject var userDefaultsViewModel = UserDefaultsViewModel()
    @State private var navigateToNextView = false

    var body: some View {
        NavigationStack {
            ZStack {
                Color("Background")
                    .ignoresSafeArea()
                VStack {
                    Text("Welcome!")
                        .font(.system(.largeTitle, design: .rounded, weight: .semibold))
                        .accessibilityIdentifier("welcomeTitleLabel")
                    Text("Before starting, let's fill in your name first!")
                        .font(.system(size: 18, weight: .light, design: .rounded))
                        .accessibilityIdentifier("welcomeDescriptionLabel")
                    GifImage("NameAnimation")
                        .accessibilityIdentifier("welcomeGIF")
                    ZStack {
                        Capsule()
                            .frame(width: 250, height: 70)
                        TextField("Name", text: $userDefaultsViewModel.nama)
                        .frame(width: 250, height: 70)
                        .foregroundColor(Color("Background"))
                        .multilineTextAlignment(.center)
                        .font(.system(size: 30))
                        .fontWeight(.semibold)
                        .accessibilityIdentifier("nameTextField")
                    }
                    NavigationLink(
                        destination: ChooseRoleView()
                            .environmentObject(multipeerController ?? MultipeerController(UIDevice.current.name))
                    ) {
                        ZStack {
                            Capsule()
                                .stroke(Color("Second"), lineWidth: 2)
                                .frame(width: 314, height: 47)
                                .overlay {
                                    Capsule()
                                        .foregroundColor(Color("Main"))
                                        .opacity(0.4)
                                }
                            Text("ENTER")
                                .font(.system(size: 28, design: .rounded))
                                .fontWeight(.bold)
                        }
                        .accessibilityIdentifier("enterNameButton")
                    }
                    .padding(.bottom, 100)
                    .padding(.top, 60)
                    .simultaneousGesture(
                        TapGesture().onEnded {
                            let player = Player(name: userDefaultsViewModel.nama, lobbyRole: .noLobbyRole, gameRole: .referee)
                            playerData = PlayerData(mainPlayer: player, playerList: [player])
                            multipeerController = MultipeerController(player.name)
                        }
                    )
                    .disabled(userDefaultsViewModel.nama.isEmpty)
                    .opacity(userDefaultsViewModel.nama.isEmpty ? 0.4 : 1.0)
                }
                .padding(.top, 100)
                .foregroundColor(Color("ColorText"))
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
