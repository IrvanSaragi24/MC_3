//
//  TrainVoiceView.swift
//  MC_3
//
//  Created by Irvan P. Saragi on 16/07/23.
//

import SwiftUI

struct EndView: View {
    @EnvironmentObject var lobbyViewModel: LobbyViewModel
    @EnvironmentObject private var multipeerController: MultipeerController
    @EnvironmentObject private var playerData: PlayerData

    var body: some View {
        ZStack {
            BubbleView()
            VStack(spacing: 16) {
                Text("CONTINUE\nHANGOUT?")
                    .font(.system(size: 40, design: .rounded))
                    .fontWeight(.bold)
                    .foregroundColor(Color("Second"))
                    .multilineTextAlignment(.center)
                    .padding(.bottom, 100)
                    .accessibilityIdentifier("continueHangoutLabel")
                if multipeerController.isPlayer {
                    Button {
                        let connectedGuest = multipeerController.getConnectedPeers()
                        // Reset setting
                        multipeerController.sendMessage(NavigateCommandConstant.navigateToListen, to: connectedGuest)
                        multipeerController.resetParameters(page: NavigateCommandConstant.navigateToListen
                        )
                        multipeerController.navigateToListen = true
                    } label: {
                        Text("Continue")
                            .font(.system(size: 28, design: .rounded))
                            .fontWeight(.bold)
                    }
                    .buttonStyle(MultipeerButtonStyle())
                    .accessibilityIdentifier("endViewContinueListeningButton")
                    Button {
                        // Reset
                        let connectedGuest = multipeerController.getConnectedPeers()
                        multipeerController.sendMessage(NavigateCommandConstant.navigateToChooseRole, to: connectedGuest)
                        multipeerController.resetParameters(page: NavigateCommandConstant.navigateToChooseRole
                        )
                        multipeerController.navigateToChooseRole = true
                    } label: {
                    Text("End Session")
                        .font(.system(size: 28, design: .rounded))
                        .fontWeight(.bold)
                    }
                    .buttonStyle(SecondButtonStyle())
                    .accessibilityIdentifier("endViewStopListeningButton")
                } else {
                    Text("Waiting for decision..")
                        .font(.system(size: 28, design: .rounded))
                        .fontWeight(.bold)
                        .foregroundColor(Color("Second"))
                        .multilineTextAlignment(.center)
                        .accessibilityIdentifier("waitingForDecisionText")
                }
            }
            .navigationDestination(isPresented: $multipeerController.navigateToListen) {
                ListenView()
                    .environmentObject(multipeerController)
                    .environmentObject(lobbyViewModel)
            }
        }
        .navigationBarBackButtonHidden(true)
        .navigationDestination(isPresented: $multipeerController.navigateToChooseRole) {
            ChooseRoleView()
                .environmentObject(multipeerController)
                .environmentObject(lobbyViewModel)
        }
        .onAppear {
            multipeerController.resetNavigateVar()
        }
    }
}

struct EndView_Previews: PreviewProvider {
    static var previews: some View {
        EndView()
            .environmentObject(MultipeerController("YourDisplayName"))
            .environmentObject(LobbyViewModel())
    }
}
