//
//  TrainVoiceView.swift
//  MC_3
//
//  Created by Irvan P. Saragi on 16/07/23.
//

import SwiftUI

struct EndGameView: View {
    @EnvironmentObject var lobbyViewModel: LobbyViewModel
    @EnvironmentObject private var multipeerController: MultipeerController
    @EnvironmentObject private var playerData: PlayerData
    
    var body: some View {
        if multipeerController.gameState == .listening {
            ListenView()
                .environmentObject(lobbyViewModel)
                .environmentObject(multipeerController)
                .environmentObject(playerData)
        }
        else if multipeerController.gameState == .reset {
            ChooseRoleView()
                .environmentObject(playerData)
                .environmentObject(multipeerController)
                .environmentObject(lobbyViewModel)
        }
        else {
            ZStack {
                BubbleView()
                VStack(spacing : 16){
                    Text("CONTINUE\nHANGOUT?")
                        .font(.system(size: 40, design: .rounded))
                        .fontWeight(.bold)
                        .foregroundColor(Color("Second"))
                        .multilineTextAlignment(.center)
                        .padding(.bottom, 100)
                    
                    Button {
                        let connectedGuest = multipeerController.getConnectedPeers()
                        //reset setting
                        multipeerController.sendMessage(MsgCommandConstant.resetAllVarToDefault, to: connectedGuest)
                        multipeerController.resetVarToDefault()
                        Button {
                            // reset
                            let connectedGuest = multipeerController.getConnectedPeers()
                            multipeerController.sendMessage(MsgCommandConstant.resetGame, to: connectedGuest)
                            multipeerController.resetGame()
                            
                            //                            goToChooseRoleView = true
                            print("STOP ")
                        }
//                    label: {
//                            RoundedRectangle(cornerRadius: 40)
//                                .stroke(Color("Main"), lineWidth : 2)
//                                .frame(width: 314, height: 48)
//                                .overlay {
//                                    Text("Stop")
//                                        .font(.system(size: 28, design: .rounded))
//                                        .fontWeight(.bold)
//                                        .foregroundColor(Color("Second"))
//                                }
//                        }
                    label: {
                            Text("Continue")
                                .font(.system(size: 28, design: .rounded))
                                .fontWeight(.bold)
                        }
                        .buttonStyle(MultipeerButtonStyle())
                    }
                    else {
                        Text("WAITING\nDECISSION")
                            .font(.system(size: 40, design: .rounded))
                            .fontWeight(.bold)
                    }
                    .buttonStyle(MultipeerButtonStyle())
                    
                    Button {
                        // reset
                        let connectedGuest = multipeerController.getConnectedPeers()
                        multipeerController.sendMessage(MsgCommandConstant.resetGame, to: connectedGuest)
                        multipeerController.resetGame()
                        print("STOP ")
                    } label: {
                        RoundedRectangle(cornerRadius: 40)
                            .stroke(Color("Main"), lineWidth : 2)
                            .frame(width: 314, height: 48)
                            .overlay {
                                Text("Stop")
                                    .font(.system(size: 28, design: .rounded))
                                    .fontWeight(.bold)
                                    .foregroundColor(Color("Second"))
                            }
                        
                    }
                    
                    
                    
                }
            }
        }
    }
}



struct EndGameView_Previews: PreviewProvider {
    static let player = Player(name: "YourDisplayName", lobbyRole: .host, gameRole: .asked)
    static var playerData = PlayerData(mainPlayer: player, playerList: [player])
    static let multipeerController = MultipeerController("YourDisplayName")
    static var previews: some View {
        EndGameView()
            .environmentObject(multipeerController)
            .environmentObject(playerData)
            .environmentObject(LobbyViewModel())
    }
}
