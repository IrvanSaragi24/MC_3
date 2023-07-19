//
//  LobbyView.swift
//  MC_3
//
//  Created by Sayed Zulfikar on 18/07/23.
//

import SwiftUI
import MultipeerConnectivity

struct LobbyView: View {
    @State private var lobbyName: String = ""
    @State private var silentDuration: Int = 0
    @State private var showingResultView = false

    var body: some View {
        NavigationView {
            VStack(alignment: .leading) {
                Text("Lobby Name:")
                
                TextField("Enter Lobby Name", text: $lobbyName)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    

                Text("Silent Duration")
                TextField("Enter Silent Duration Rime", value: $silentDuration, formatter: NumberFormatter())
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .keyboardType(.numberPad)
                    

                Button(action: {
                    showingResultView = true
                }) {
                    Text("Create Lobby")
                        .font(.headline)
                        .padding()
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }
                .sheet(isPresented: $showingResultView) {
                    LobbyInviteView(lobby: Lobby(name: lobbyName, date: Date.now, silentDuration: silentDuration))
                }
                Spacer()
            }
            .padding()
            .navigationTitle("Lobby")
            
        }
    }
}

struct LobbyInviteView: View {
    let lobby: Lobby
    @EnvironmentObject var connectionManager: ConnectionManager

    var body: some View {
        List {
          HStack {
            Label(
              title: {
                Text("Lobby Name")
                  .font(.headline)
              },
              icon: {
                Image(systemName: "person.3.fill")
              })
            Spacer()
              Text("\(lobby.name)")
          }
          HStack {
            Label(
              title: {
                Text("Silent Duration")
                  .font(.headline)
              },
              icon: {
                Image(systemName: "timer")
              })
            Spacer()
              Text("\(lobby.silentDuration)")
          }
          Section(
            header: HStack(spacing: 8) {
              Text("Available Guests")
              Spacer()
              ProgressView()
            }) {
              ForEach(connectionManager.guests, id: \.self) { guest in
                HStack {
                  Text(guest.displayName)
                    .font(.headline)
                  Spacer()
                  Image(systemName: "arrowshape.turn.up.right.fill")
                }
                .onTapGesture {
                    connectionManager.invitePeer(guest, to: lobby)
                }

              }

          }
        }
        .listStyle(InsetGroupedListStyle())
        .navigationTitle(lobby.name)
        .onAppear {
          connectionManager.startBrowsing()
        }
        .onDisappear {
            connectionManager.stopBrowsing()
        }

      }
}

struct LobbyView_Previews: PreviewProvider {
    static var previews: some View {
        LobbyView()
            .environmentObject(ConnectionManager())
    }
}
