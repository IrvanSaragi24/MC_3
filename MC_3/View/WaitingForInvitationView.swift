//
//  WaitingForInvitationView.swift
//  MC_3
//
//  Created by Sayed Zulfikar on 28/07/23.
//

import SwiftUI

struct WaitingForInvitationView: View {
    @EnvironmentObject private var multipeerController: MultipeerController

    var body: some View {
        LoadingView(textWait: "Waiting invitation from a host...", circleSize: 166, lineWidthCircle: 40, lineWidthCircle2: 35, yOffset: 0)
            .onDisappear {
                multipeerController.isAdvertising = false
            }
            .onAppear {
                multipeerController.resetNavigateVar()
                multipeerController.isAdvertising = true
            }
            .navigationDestination(isPresented: $multipeerController.navigateToWaitingStart) {
                WaitingToStartView()
                    .environmentObject(multipeerController)
            }
    }
}

struct WaitingForInvitationView_Previews: PreviewProvider {
    static var previews: some View {
        WaitingForInvitationView()
            .environmentObject(MultipeerController("Player"))
    }
}
