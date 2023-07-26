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
    @State private var startGame = false
    
    var body: some View {
        NavigationView {
            if multipeerController.isChoosingView {
                ChoosingView()
                    .environmentObject(lobbyViewModel)
                    .environmentObject(multipeerController)
                    .environmentObject(playerData)
            }
            else {
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
                            }
                            
                        }
                        .padding(.top, 100)
                        Spacer()
                        
                        if multipeerController.isHost {
                            Button {
                                quizTime()
                                
                            } label: {
                                
                                Text("Quiz Time!")
                                    .font(.system(size: 28, weight : .bold))
                                
                                
                            }
                            .buttonStyle(MultipeerButtonStyle())
                            
//                            NavigationLink(
//                                destination: ChoosingView()
//                                    .environmentObject(lobbyViewModel)
//                                    .environmentObject(multipeerController)
//                                    .environmentObject(playerData),
//                                isActive: $startGame,
//                                label: {
//                                    EmptyView()
//                                })
                            
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
                                    lobbyViewModel.startTimer()
                                    audioViewModel.silentPeriod = lobbyViewModel.lobby.silentDuration
                                }
                            }
                            .onChange(of: audioViewModel.audio.isRecording) { newValue in
                                if newValue == false {
                                    quizTime()
                                }
                            }
                        }
                    }
                }
            }
        }
    }
    func quizTime() {
        if multipeerController.isHost {
            var connectedGuest = multipeerController.getConnectedPeers()
            
            var candidates = connectedGuest.map { $0.displayName }
            
            //add host
            candidates.append(multipeerController.myPeerId.displayName)
            
            lobbyViewModel.pauseTimer()
            
            let objekIndex = lobbyViewModel.getQuestion(candidates: candidates)
            
            if objekIndex == candidates.count-1 {
                // host yg kepilih jadi object
                
            }
            
            multipeerController.sendMessage(MsgCommandConstant.startQuiz, to: connectedGuest)
            
            startGame = true
            lobbyViewModel.lobby.currentQuestionIndex += 1
            connectedGuest = multipeerController.allGuest
                .filter { $0.status == .connected }
                .map { $0.id }
            
            // Di sisi pengirim
            let typeData = "question"
            let message = "\(lobbyViewModel.lobby.question ?? ""):\(typeData)"
            
            // Kirim pesan ke semua peer yang terhubung
            multipeerController.sendMessage(message, to: connectedGuest)
            
            multipeerController.isChoosingView = true
        }
    }
}

struct ListenView_Previews: PreviewProvider {
    static let player = Player(name: "YourDisplayName", lobbyRole: .host, gameRole: .asked)
    static var playerData = PlayerData(mainPlayer: player, playerList: [player])
    static let multipeerController = MultipeerController("YourDisplayName") // Use the same instance
    
    static var previews: some View {
        ListenView()
            .environmentObject(multipeerController) // Use the same instance
            .environmentObject(playerData)
            .environmentObject(LobbyViewModel()) // Provide LobbyViewModel here
    }
}
