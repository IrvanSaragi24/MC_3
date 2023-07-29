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
    @State private var isInformasiModal = false
    let silentDurationOptions = [10, 15, 20, 25] // Example options for silent duration in seconds
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
                Text("8 player \n maximum limit")
                    .font(.system(size: 36, weight: .bold,design: .rounded))
                    .multilineTextAlignment(.center)
                    .foregroundColor(Color("Second"))
                    .opacity(multipeerController.allGuest.count == 0 ? 0.3 : 0.0)
                VStack (spacing : 25){
                    HStack{
                        Spacer()
                        Text("Lobby")
                            .foregroundColor(Color("Second"))
                            .font(.system(size: 38, design: .rounded))
                            .fontWeight(.bold)
                        Spacer()
                        Button {
                            isInformasiModal = true
                        } label: {
                            Image(systemName: "info.circle")
                                .resizable()
                                .frame(width: 25, height: 25)
                                .foregroundColor(Color("Informasi"))
                        }
                        .sheet(isPresented: $isInformasiModal) {
                            InformasiModal()
                                .presentationDetents([.height(600)])
                            }
                        .padding(.trailing, 30)

                    }
                    .padding(.leading, 40)
                    HStack(spacing : 30){
                        RoundedRectangle(cornerRadius: 10)
                            .frame(width: 148, height: 40)
                            .foregroundColor(.white)
                            .overlay {
                                HStack {
                                    Text("SP:")
                                        .fontWeight(.bold)
//                                        .frame(width: 100)
                                    Spacer()
                                    Picker("Silent Period", selection: $lobbyViewModel.lobby.silentDuration) {
                                        ForEach(silentDurationOptions, id: \.self) { duration in
                                            Text("\(duration)s")
                                                .tag(duration)
                                        }
                                    }
                                    .pickerStyle(MenuPickerStyle())
                                }
                                .padding()
                                .foregroundColor(.black)
                            }
                        RoundedRectangle(cornerRadius: 10)
                            .frame(width: 148, height: 40)
                            .foregroundColor(.white)
                            .overlay {
                                HStack {
                                    Text("QA:")
                                        .fontWeight(.bold)
                                    Spacer()
                                    Picker("Number of Questions", selection: $lobbyViewModel.lobby.numberOfQuestion) {
                                        ForEach(numberOfQuestionOptions, id: \.self) { number in
                                            Text("\(number)")
                                            
                                                .tag(number)
                                        }
                                    }
                                    .pickerStyle(MenuPickerStyle())
                                }
                                .padding()
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
                        print(lobbyViewModel.lobby.silentDuration)
                        let connectedGuest = multipeerController.getConnectedPeers()
                        
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

struct InformasiModalX: View {
    
    
    var body: some View {
        VStack(alignment: .center, spacing: 10){
            Text("How it Works ?")
//                .padding(.leading, 120)
                .fontWeight(.semibold)
            Divider()
            //SP
            Text("SP")
                .fontWeight(.semibold)
            Text("So what is SP (Silent Period) and what does it do? ")
                .fontWeight(.bold)
            Text("SP or Silent Period is a moment of time when the conversation goes silent. Within that period, no one talks and it could be because you have no more topics to talk about and somehow someone told a joke and no one laughed because it wasn’t funny.")
                .fontWeight(.light)
            Text("If you set the Silent Period to 10 seconds (default), the game will start automatically after no one is talking in 10 seconds. Otherwise, you can start manually by clicking on the “Quiz Time!” button.")
                .fontWeight(.light)
            Divider()
                // QA
            Text("QA")
                .fontWeight(.bold)
            Text("So what is QA (Question Amount) and what does it do?")
                .fontWeight(.bold)
            Text("Question Amount is the total of questions asked to players chosen randomly. Each question will be asked to random players.")
                .fontWeight(.light)
                .padding(.leading, -2)
        }
        .padding()
    }
}
