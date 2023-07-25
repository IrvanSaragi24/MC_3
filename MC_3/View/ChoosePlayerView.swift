//
//  ChoosePlayerView.swift
//  MC_3
//
//  Created by Sayed Zulfikar on 22/07/23.
//

import SwiftUI

struct ChoosePlayerView: View {
    @EnvironmentObject var lobbyViewModel: LobbyViewModel
    @EnvironmentObject private var multipeerController: MultipeerController
    @EnvironmentObject private var playerData: PlayerData
    @State var question: String?
    @State private var isActive: Bool = false
    

    var body: some View {
        NavigationView {
        VStack {
            Spacer()
            Image(systemName: "person.3.fill")
            Spacer()
            Text("Choosing...")
            Spacer()
            Text("Question")
            Text("\(multipeerController.receivedQuestion ?? "Pertanyaan di sini")")
            Text("1/3")
            NavigationLink(
                destination: AskedView() // TODO: confirm where this button goes?
            )
            {
                Label("", systemImage: "gobackward")
            }
            .buttonStyle(MultipeerButtonStyle())
            .onTapGesture {
                
            }
            NavigationLink(
                destination: multipeerController.isReferee ? AnyView(RefereeView()) : AnyView(AskedView()),
                isActive: $isActive,
                label: {
                    EmptyView()
                }
            ).onAppear {
                // Start a timer to navigate to next page after x seconds
                
                if multipeerController.hostPeerID == nil {
                    question = lobbyViewModel.lobby.question
                }
                else{
                    question = multipeerController.receivedQuestion
                }
                DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
                    isActive = true
                }
            }
            
        }
    }
    }
}

struct ChoosePlayerView_Previews: PreviewProvider {
    static let player = Player(name: "Player", lobbyRole: .host, gameRole: .asked)
    static var playerData = PlayerData(mainPlayer: player, playerList: [player])
    
    static let isReferee = true
    static var previews: some View {
        ChoosePlayerView()
            .environmentObject(MultipeerController(player.name))
            .environmentObject(playerData)
    }
}
