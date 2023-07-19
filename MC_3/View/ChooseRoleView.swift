//
//  ChooseRoleView.swift
//  MC_3
//
//  Created by Sayed Zulfikar on 18/07/23.
//

import SwiftUI

struct ChooseRoleView: View {
    @EnvironmentObject private var connectionManager: ConnectionManager
    
    @State private var isWaiting = false
    
    var body: some View {
        NavigationView {
            VStack {
                if isWaiting {
                    Text("Waiting Host")
                    LoaderView(tintColor: .purple, scaleSize: 5.0).padding()
                    
                }
                else {
                    
                    Spacer()
                    
                    NavigationLink(destination: LobbyView().environmentObject(connectionManager)) {
                        Label("Host", systemImage: "house.fill")
                    }
                    .buttonStyle(MultipeerButtonStyle())
                    
                    Spacer()
                    
                    Button(
                        action: {
                            connectionManager.isReceivingHangout = true
                            isWaiting = true
                        }, label: {
                            Label("Guest", systemImage: "paperplane.fill")
                        })
                    .buttonStyle(MultipeerButtonStyle())
                    
                    Spacer()
                    Spacer()
                }
            }
            .navigationTitle("Choose Your Role")
        }
        
    }
}

struct LoaderView: View {
    var tintColor: Color = .blue
    var scaleSize: CGFloat = 1.0
    
    var body: some View {
        ProgressView()
            .scaleEffect(scaleSize, anchor: .center)
            .progressViewStyle(CircularProgressViewStyle(tint: tintColor))
    }
}

struct ChooseRoleView_Previews: PreviewProvider {
    static var previews: some View {
        ChooseRoleView()
            .environmentObject(ConnectionManager())
    }
}
