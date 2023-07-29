//
//  New_WaitingForInvitationView.swift
//  MC_3
//
//  Created by Sayed Zulfikar on 28/07/23.
//

import SwiftUI

struct New_WaitingForInvitationView: View {
    @EnvironmentObject private var multipeerController: MultipeerController
    
    var body: some View {
        
        LoadingView(textWait: "Waiting invitation from a host...", circleSize: 166, LineWidtCircle: 40, LineWidtCircle2: 35)
            .onDisappear(){
                multipeerController.isAdvertising = false
            }
            .onAppear(){
                multipeerController.resetNavigateVar()
                multipeerController.isAdvertising = true
            }
            .background(
                NavigationLink(
                    destination: New_WaitingToStart()
                        .environmentObject(multipeerController),
                    isActive: $multipeerController.navigateToWaitingStart
                ) {
                    EmptyView()
                }
            )
        
    }
}

struct New_WaitingForInvitationView_Previews: PreviewProvider {
    static var previews: some View {
        New_WaitingForInvitationView()
            .environmentObject(MultipeerController("Player"))
    }
}
