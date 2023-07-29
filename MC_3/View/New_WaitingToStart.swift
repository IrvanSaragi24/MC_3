//
//  New_WaitingToStart.swift
//  MC_3
//
//  Created by Sayed Zulfikar on 28/07/23.
//

import SwiftUI

struct New_WaitingToStart: View {
    @EnvironmentObject private var multipeerController: MultipeerController
    
    var body: some View {
        ZStack {
            LoadingView(textWait: "", circleSize: 60, LineWidtCircle: 20, LineWidtCircle2: 15)
            VStack{
                Text("You have joined")
                    .font(.system(size: 18, weight: .light))
                    .foregroundColor(Color("Second"))
                Text("\(multipeerController.hostPeerID?.displayName ?? "Unknown")’s Lobby")
                    .font(.system(size: 32, weight: .bold))
                    .foregroundColor(Color("Second"))
                RoundedRectangle(cornerRadius: 21)
                    .stroke(lineWidth: 2)
                    .frame(width: 234, height: 32)
                    .overlay {
                        HStack{
                            Image(systemName: "person.3.fill")
                            Text("Total Player")
                            Spacer()
                            Text("\(multipeerController.getConnectedPeers().count)")
                        }
                        .padding()
                        
                    }
                    .foregroundColor(Color("Second"))
                Image("phone")
                    .padding(.top, 20)
                Text("Wait for the host to start...")
                    .foregroundColor(Color("Second"))
                    .font(.system(size: 30, weight: .light))
                    .padding(.top, 50)
                
            }
            
        }
        .onDisappear(){
            multipeerController.navigateToWaitingStart = false
        }
        .padding(.top, 40)
        
            .background(
                NavigationLink(
                    destination: New_ListenView()
                        .environmentObject(multipeerController),
                    isActive: $multipeerController.navigateToListen
                ) {
                    EmptyView()
                }
            )
    }
}

struct New_WaitingToStart_Previews: PreviewProvider {
    static var previews: some View {
        New_WaitingToStart()
            .environmentObject(MultipeerController("Player"))
    }
}
