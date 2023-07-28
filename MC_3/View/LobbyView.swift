//
//  LobbyView.swift
//  MC_3
//
//  Created by Sayed Zulfikar on 18/07/23.
//

import SwiftUI
import MultipeerConnectivity

struct LobbyView: View {
    @State var lobby: Lobby
    @EnvironmentObject var lobbyViewModel: LobbyViewModel
    @EnvironmentObject var multipeerController: MultipeerController
    @EnvironmentObject private var playerData: PlayerData
    @State private var navigateToListenView = false
    @State private var showingConfirmationAlert = false
    @State private var guestToRemove: MCPeerID?
    let silentDurationOptions = [10, 15, 20] // Example options for silent duration in seconds
    let numberOfQuestionOptions = [1, 2, 3, 4]
    
    var body: some View {
        NavigationView { // Add the main NavigationView here
            ZStack {
                Color.clear.backgroundStyle()
                    .ignoresSafeArea()
                Image("CircleHost")
                    .resizable()
                    .scaledToFill()
                    .ignoresSafeArea()
                    .padding(.top, 130)
                Text("Waiting For Friends \n (Max: 8)")
                    .font(.system(size: 36, weight: .bold,design: .rounded))
                    .multilineTextAlignment(.center)
                    .foregroundColor(Color("Second"))
                    .opacity(multipeerController.allGuest.count == 0 ? 0.3 : 0.0)
                VStack (spacing : 25){
                    Text("Lobby")
                        .foregroundColor(Color("Second"))
                        .font(.system(size: 38, design: .rounded))
                        .fontWeight(.bold)
                    HStack(spacing : 30){
                        RoundedRectangle(cornerRadius: 10)
                            .frame(width: 148, height: 40)
                            .foregroundColor(.white)
                            .overlay {
                                HStack {
                                    Text("Silent Period:")
                                        .font(.system(size: 15, weight: .medium))
                                        .frame(width: 100)
                                    Picker("Silent Period", selection: $lobbyViewModel.lobby.silentDuration) {
                                        ForEach(silentDurationOptions, id: \.self) { duration in
                                            Text(" \(duration)s     ")
                                                .tag(duration)
                                        }
                                    }
                                    .pickerStyle(MenuPickerStyle())
                                }
                                .foregroundColor(.black)
                            }
                        RoundedRectangle(cornerRadius: 10)
                            .frame(width: 148, height: 40)
                            .foregroundColor(.white)
                            .overlay {
                                HStack {
                                    Text("Question:")
                                        .frame(width: 100)
                                    Picker("Number of Questions", selection: $lobbyViewModel.lobby.numberOfQuestion) {
                                        ForEach(numberOfQuestionOptions, id: \.self) { number in
                                            Text(" \(number)  ")
                                            
                                                .tag(number)
                                        }
                                    }
                                    .pickerStyle(MenuPickerStyle())
                                }
                                .foregroundColor(.black)
                            }
                    }
                    RoundedRectangle(cornerRadius: 21)
                        .stroke(lineWidth: 2)
                        .frame(width: 234, height: 32)
                        .overlay {
                            HStack{
                                Image(systemName: "person.3.fill")
                                Text("JOINED PLAYER")
                                    .font(.system(size: 12, design: .rounded))
                                    .fontWeight(.medium)
                                Spacer()
                                Text("\(multipeerController.allGuest.filter { $0.status == .connected }.count)")
                            }
                            .padding()
                            
                        }
                        .foregroundColor(Color("Second"))
                    List {
                        Section(
                            header: HStack(spacing: 8) {
                                Text("All Guests")
                                    .foregroundColor(Color("Second"))
                                Spacer()
                                ProgressView()
                            }) {
                                ForEach(multipeerController.allGuest, id: \.self) { guest in
                                    ZStack{
                                        RoundedRectangle(cornerRadius: 12)
                                            .frame(width: 314, height: 80)
                                            .foregroundColor(guest.status.BackgroundColor)
                                            .shadow(color : .indigo, radius : 5)
                                            .overlay {
                                                HStack(spacing : 20) {
                                                    Circle()
                                                        .stroke(lineWidth: 2)
                                                        .frame(width : 20)
                                                        .overlay{
                                                            Circle()
                                                                .foregroundColor(guest.status.circleColor)
                                                                .frame(width : 18)
                                                        }
                                                    
                                                    
                                                    Capsule()
                                                        .frame(width: 2)
                                                    VStack(alignment: .leading){
                                                        Text(guest.id.displayName)
                                                            .font(.system(size : 24, weight : .bold))
                                                        Text(guest.status.stringValue)
                                                            .font(.system(size: 12, design: .rounded))
                                                            .fontWeight(.regular)
                                                    }
                                                    
                                                    Spacer()
                                                    Image(systemName: guest.status.ImageButtonAdd)
                                                        .resizable()
                                                        .frame(width : 30, height : 30)
                                                        .onTapGesture {
                                                            if guest.status == .connected {
                                                                guestToRemove = guest.id
                                                                showingConfirmationAlert = true
                                                            }
                                                            else {
                                                                multipeerController.invitePeer(guest.id, to: lobby)
                                                            }
                                                        }
                                                }.foregroundColor(guest.status.TextColor)
                                                    .padding()
                                            }
                                    }
                                    .alert(isPresented: $showingConfirmationAlert) {
                                                Alert(
                                                    title: Text("Disconnect Peer"),
                                                    message: Text("Are you sure you want to disconnect \(guestToRemove?.displayName ?? "this peer")?"),
                                                                  primaryButton: .destructive(Text("Yes")) {
                                                        if let peerToRemove = guestToRemove {
                                                            multipeerController.disconnectPeer(peerToRemove: peerToRemove)
                                                        }
                                                    },
                                                    secondaryButton: .cancel()
                                                )
                                            }
                                    
                                }
                                .listRowBackground(Color.clear)
                                
                            }
                    }
                    .listStyle(InsetGroupedListStyle())
                    .scrollContentBackground(.hidden)
                    //                    .navigationTitle("\(lobby.name)'s Lobby")
                    .onAppear {
                        multipeerController.startBrowsing()
                    }
                    .onDisappear {
                        multipeerController.stopBrowsing()
                    }
                    
                    Button {
                        let connectedGuest = multipeerController.getConnectedPeers()
                        multipeerController.lobby.silentDuration = lobbyViewModel.lobby.silentDuration
                        multipeerController.lobby.numberOfQuestion = lobbyViewModel.lobby.numberOfQuestion
                        
                        multipeerController.sendMessage(MsgCommandConstant.startListen, to: connectedGuest)
                        navigateToListenView = true
                        
                    } label: {
                        Text("Start!")
                            .font(.system(size: 28, design: .rounded))
                            .fontWeight(.bold)
                    }
                    .buttonStyle(MultipeerButtonStyle())
                    .padding(.bottom, 50)
                    
                    //                Spacer() // Optional spacer to push the button to the bottom
                }
                .padding(.top, 60)
            }
            .background(
                NavigationLink(
                    destination: ListenView()
                        .environmentObject(lobbyViewModel)
                        .environmentObject(multipeerController)
                        .environmentObject(playerData),
                    isActive: $navigateToListenView
                ) {
                    EmptyView()
                }
            )
        }
    }
    
}

struct LobbyView_Previews: PreviewProvider {
    
    static let player = Player(name: "Player", lobbyRole: .noLobbyRole, gameRole: .asked)
    
    static var playerData = PlayerData(mainPlayer: player, playerList: [player])
    
    static var lobby = Lobby(name: player.name, silentDuration: 10, numberOfQuestion: 1)
    
    static var previews: some View {
        LobbyView(lobby: lobby)
            .environmentObject(MultipeerController(player.name))
            .environmentObject(playerData)
            .environmentObject(LobbyViewModel())
    }
}
