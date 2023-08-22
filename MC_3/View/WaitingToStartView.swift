//
//  WaitingToStartView.swift
//  MC_3
//
//  Created by Sayed Zulfikar on 28/07/23.
//

import SwiftUI

struct WaitingToStartView: View {
    var screenWidth: CGFloat {
        UIScreen.main.bounds.width
    }

    var screenHeight: CGFloat {
        UIScreen.main.bounds.height
    }

    @EnvironmentObject private var multipeerController: MultipeerController
    @StateObject private var lobbyViewModel = LobbyViewModel()

    var body: some View {
        ZStack {
            LoadingView(textWait: "", circleSize: 60, lineWidthCircle: 20, lineWidthCircle2: 15, yOffset: screenHeight * 0.40)
            VStack {
                Text("You have joined")
                    .font(.system(size: 18, weight: .light))
                    .foregroundColor(Color("Second"))
                    .accessibilityIdentifier("joinedGuestLabel")
                Text("\(multipeerController.hostPeerID?.displayName ?? "Unknown")’s Lobby")
                    .font(.system(size: 32, weight: .bold))
                    .foregroundColor(Color("Second"))
                    .accessibilityIdentifier("lobbyNameLabel")
                RoundedRectangle(cornerRadius: 21)
                    .stroke(lineWidth: 2)
                    .frame(width: 234, height: 32)
                    .overlay {
                        HStack {
                            Image(systemName: "person.3.fill")
                            Text("Total Player")
                                .accessibilityIdentifier("totalPlayerLabel")
                            Spacer()
                            Text("\(multipeerController.getConnectedPeers().count)")
                                .accessibilityIdentifier("totalPlayerText")
                        }
                        .padding()
                    }
                    .foregroundColor(Color("Second"))
                Image("phone")
                    .padding(.top, 20)
                    .accessibilityIdentifier("phoneImage")
                Text("Wait for the host to start...")
                    .foregroundColor(Color("Second"))
                    .font(.system(size: 30, weight: .light))
                    .padding(.top, 50)
                    .accessibilityIdentifier("waitingForHostLabel")
            }
            .navigationDestination(isPresented: $multipeerController.navigateToWaitingInvitation) {
                WaitingForInvitationView()
                    .environmentObject(multipeerController)
            }
        }
        .onAppear {
            multipeerController.resetNavigateVar()
        }
        .navigationDestination(isPresented: $multipeerController.navigateToListen) {
            ListenView()
                .environmentObject(multipeerController)
                .environmentObject(lobbyViewModel)
        }
    }
}

struct WaitingToStartView_Previews: PreviewProvider {
    static var previews: some View {
        WaitingToStartView()
            .environmentObject(MultipeerController("Player"))
    }
}
