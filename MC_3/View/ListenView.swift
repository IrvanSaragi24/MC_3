//
//  ListenView.swift
//  MC_3
//
//  Created by Sayed Zulfikar on 19/07/23.
//

import SwiftUI

struct ListenView: View {
    @EnvironmentObject private var multipeerController: MultipeerController
    @EnvironmentObject private var playerData: PlayerData
    var body: some View {
        NavigationView {
            ZStack{
                BubbleView()
                VStack (spacing : 16) {
                    VStack{
                        Circle()
                            .stroke(Color("Main"), lineWidth: 10)
                            .frame(width: 234)
                            .overlay {
                                Circle()
                                    .foregroundColor(Color.red)
                                Image("Music")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 225)
                            }
                            .padding(.top, 24)
                        Text("\(multipeerController.gameState.rawValue)")
                        Text("Listening..")
                            .font(.system(size: 36, weight: .semibold))
                            .foregroundColor(Color("Second"))
                        ZStack{
                            RoundedRectangle(cornerRadius: 20)
                                .stroke(Color("Second"), lineWidth: 4)
                                .frame(width: 234, height: 56)
                                .overlay {
                                    RoundedRectangle(cornerRadius: 20)
                                        .foregroundColor(Color("Second"))
                                        .opacity(0.2)
                                }
                            Text("10.30")
                                .font(.system(size: 32))
                                .fontWeight(.semibold)
                                .foregroundColor(Color("Second"))
                        }
                        
                    }
                    .padding(.top, 100)
                    Spacer()
                    NavigationLink(
                        destination: ChoosePlayerView()
                            .environmentObject(multipeerController)
                            .environmentObject(playerData)
                    )
                    {
                        Text("Quiz Time!")
                            .font(.system(size: 28, weight: .bold))
                    }
                    .buttonStyle(MultipeerButtonStyle())
                    .onTapGesture {
                        
                    }
                    NavigationLink(
                        destination: HangOutView()
                    )
                    {
                        Text("End Session")
                            .font(.system(size: 28, weight: .bold))
                    }
                    .buttonStyle(MultipeerButtonStyle())
                    .onTapGesture {
                        multipeerController.stopBrowsing()
                        multipeerController.isAdvertising = false
                    }
                }
            }
        }
    }
}

struct ListenView_Previews: PreviewProvider {
    static let player = Player(name: "Player", lobbyRole: .host, gameRole: .asked)
    static var playerData = PlayerData(mainPlayer: player, playerList: [player])
    
    static var previews: some View {
        ListenView()
            .environmentObject(MultipeerController(player.name))
            .environmentObject(playerData)
    }
}
