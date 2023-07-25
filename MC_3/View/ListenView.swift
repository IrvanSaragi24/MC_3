//
//  ListenView.swift
//  MC_3
//
//  Created by Sayed Zulfikar on 19/07/23.
//

import SwiftUI

struct ListenView: View {
    @EnvironmentObject var lobbyViewModel: LobbyViewModel
    @EnvironmentObject private var multipeerController: MultipeerController
    @EnvironmentObject private var playerData: PlayerData
    @StateObject var audioViewModel = AudioViewModel()
    
    var body: some View {
        NavigationView {
            ZStack{
                BubbleView()
                VStack (spacing : 16) {
                    VStack{
//                        if let peerID = multipeerController.hostPeerID {
//                            Text("\(peerID)")
//                        } else {
//                            Text("Host Peer ID is nil.")
//                        }
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
                        Text("Listening..")
                            .font(.system(size: 36, weight: .semibold))
                            .foregroundColor(Color("Second"))
//                        Text(("\(audioViewModel.audio.isSpeechDetected ?? "No"), rate: \(audioViewModel.audio.speechConfidence ?? 0.0)"))
                        ZStack{
                            RoundedRectangle(cornerRadius: 20)
                                .stroke(Color("Second"), lineWidth: 4)
                                .frame(width: 234, height: 56)
                                .overlay {
                                    RoundedRectangle(cornerRadius: 20)
                                        .foregroundColor(Color("Second"))
                                        .opacity(0.2)
                                }
                            Text(lobbyViewModel.formattedElapsedTime)
                                .font(.system(size: 32))
                                .fontWeight(.semibold)
                                .foregroundColor(Color("Second"))
                                .onAppear(perform: lobbyViewModel.startTimer)
                                .onDisappear(perform: lobbyViewModel.pauseTimer)
//                            Text("10.30")
//                                .font(.system(size: 32))
//                                .fontWeight(.semibold)
//                                .foregroundColor(Color("Second"))
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
                    .onAppear{
                        if audioViewModel.audio.isRecording == false && multipeerController.hostPeerID == nil {
                            audioViewModel.startVoiceActivityDetection()
                        }
                        lobbyViewModel.startTimer()
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
