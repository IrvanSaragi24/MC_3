//
//  ResultView.swift
//  MC_3
//
//  Created by Sayed Zulfikar on 22/07/23.
//

import SwiftUI



struct ResultView: View {
    //    @State private var AnswerNo : Bool = false
    @StateObject var synthesizerViewModel = SynthesizerViewModel()
    @EnvironmentObject var lobbyViewModel: LobbyViewModel
    @EnvironmentObject private var multipeerController: MultipeerController
    @EnvironmentObject private var playerData: PlayerData
    
    @State private var isDoneAllQuestion = false
    var isWin: Bool
    
    var body: some View {
        ZStack {
            if multipeerController.isEndView {
                EndGameView()
                    .environmentObject(lobbyViewModel)
                    .environmentObject(multipeerController)
                    .environmentObject(playerData)
            }
            else if multipeerController.isChoosingView {
                ChoosingView()
                    .environmentObject(lobbyViewModel)
                    .environmentObject(multipeerController)
                    .environmentObject(playerData)
            }
            else
            {
                ZStack {
                    BubbleView()
                    VStack(spacing : 20) {
                        if multipeerController.isPlayer {
                            Button {
                                
                                let connectedGuest = multipeerController.getConnectedPeers()
                                
                                if isDoneAllQuestion {
                                    // Go to End
                                    multipeerController.sendMessage(MsgCommandConstant.updateIsEndViewTrue, to: connectedGuest)
                                    multipeerController.isEndView = true
                                    
                                }
                                else {
                                    // reset previous setting
                                    
                                    multipeerController.sendMessage(MsgCommandConstant.resetAllVarToDefault, to: connectedGuest)
                                    multipeerController.resetVarToDefault()
                                    
                                    multipeerController.sendMessage(MsgCommandConstant.updateIsChoosingViewTrue, to: connectedGuest)
                                    multipeerController.isChoosingView = true
                                }
                                
                            } label: {
                                Text(isDoneAllQuestion ? "Continue" : "Next")
                                    .font(.system(size: 28, weight : .bold))
                            }
                            .buttonStyle(MultipeerButtonStyle())
                            .padding(.top, 20)
                            
                        }
                        ZStack{
                            RoundedRectangle(cornerRadius: 12)
                                .frame(width: 170, height: 60)
                                .foregroundColor(Color("Second"))
                                .overlay {
                                    Text("\(multipeerController.myPeerId.displayName)")
                                        .frame(width: 170, height: 60)
                                        .font(.system(size: 20, weight: .bold))
                                    //                                .fontWeight(.bold)
                                        .foregroundColor(Color("Background"))
                                        .multilineTextAlignment(.center)
                                }
                            Capsule()
                                .stroke(Color("Second"), lineWidth: 3)
                                .frame(width: 58, height: 14)
                                .overlay {
                                    Capsule()
                                        .foregroundColor(Color("Background"))
                                    Text(multipeerController.isPlayer ? "PLAYER" : "REFEREE")
                                        .foregroundColor(Color("Second"))
                                        .font(.system(size: 9, weight: .bold))
                                    
                                }
                                .padding(.bottom, 55)
                            
                        }
                        Image(isWin ? "Anjayy" : "Noob" )
                            .resizable()
                            .frame(width: 278, height: 278)
                        Text(isWin ? "\(multipeerController.currentPlayer) Here \n\(multipeerController.currentPlayer) Hears" : "Find a New \nFriend" )
                            .font(.system(size: 32, weight: .bold))
                            .foregroundColor(Color("Second"))
                            .multilineTextAlignment(.center)
                        ZStack{
                            RoundedRectangle(cornerRadius: 12)
                                .frame(width: 290, height: 168)
                                .foregroundColor(Color("Second"))
                                .overlay {
                                    
                                    if multipeerController.isPlayer {
                                        Text(multipeerController.isWin ? "Keren banget lo! Beneran perhatiin yak ternyata 😆" : "Eh lo! Lain kali perhatikan yak 🤬!")
                                            .font(.system(size: 17, weight: .medium))
                                            .multilineTextAlignment(.center)
                                            .padding()
                                    }
                                    else {
                                        Text(multipeerController.isWin ? "Hey, teman kamu mendengarkan dengan baik, ayo traktir dia kopi susu gula aren" : "Lu cari temen baru aja breeee")
                                            .font(.system(size: 17, weight: .medium))
                                            .multilineTextAlignment(.center)
                                            .padding()
                                    }
                                }
                            Capsule()
                                .stroke(Color("Second"), lineWidth: 3)
                                .frame(width: 120, height: 28)                        .overlay {
                                    Capsule()
                                        .foregroundColor(Color("Background"))
                                    Text(isWin ? "Anjayy" : "Noob" )
                                        .foregroundColor(Color("Second"))
                                        .font(.system(size: 12, weight: .bold))
                                }
                                .padding(.bottom, 160)
                            Circle()
                                .stroke(Color("Second"), lineWidth : 4)
                                .frame(width: 100)
                                .overlay{
                                    Circle()
                                        .foregroundColor(Color("Background"))
                                    Text("\(multipeerController.lobby.currentQuestionIndex) / \(multipeerController.lobby.numberOfQuestion)")
                                        .font(.system(size: 16, weight: .semibold))
                                        .foregroundColor(Color("Second"))
                                    
                                }
                                .padding(.top, 170)
                            
                        }
                        
                        
                        Button {
                            print("Repeat Sound")
                            //                    AnswerNo = true
                        } label: {
                            ZStack{
                                RoundedRectangle(cornerRadius: 20)
                                    .frame(width: 76, height: 30)
                                    .foregroundColor(Color("Main"))
                                Image(systemName: "speaker.wave.3.fill")
                                    .resizable()
                                    .frame(width: 22, height: 16)
                                    .foregroundColor(Color("Second"))
                                
                            }
                        }
                        
                    }
                    Spacer()
                }
                .onAppear() {
                    if multipeerController.lobby.numberOfQuestion == multipeerController.lobby.currentQuestionIndex {
                        isDoneAllQuestion = true
                    }
                }
            }
        }
    }
}

struct LooseView: View {
    var body: some View {
        VStack {
            Spacer()
            Image(systemName: "hand.thumbsdown.fill")
            Text("Lorem Ipsum Dolor")
            NavigationLink(
                destination: AskedView()
            )
            {
                Label("\u{200B}", systemImage: "arrow.right.to.line")
            }
            .buttonStyle(MultipeerButtonStyle())
            .onTapGesture {
                
            }
            Spacer()
        }
    }
}

struct ResultView_Previews: PreviewProvider {
    static let player = Player(name: "YourDisplayName", lobbyRole: .host, gameRole: .asked)
    static var playerData = PlayerData(mainPlayer: player, playerList: [player])
    static let multipeerController = MultipeerController("YourDisplayName")
    
    static var previews: some View {
        ResultView(isWin: false)
            .environmentObject(multipeerController)
            .environmentObject(playerData)
            .environmentObject(LobbyViewModel())
    }
}
