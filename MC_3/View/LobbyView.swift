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
                    .font(.system(size: 36, weight: .bold))
                    .multilineTextAlignment(.center)
                    .foregroundColor(Color("Second"))
                    .opacity(0.3)
                VStack (spacing : 25){
                    Text("Lobby")
                        .foregroundColor(Color("Second"))
                        .font(.system(size: 38, weight: .bold))
                    HStack(spacing : 30){
                        RoundedRectangle(cornerRadius: 10)
                            .frame(width: 148, height: 40)
                            .foregroundColor(.white)
                            .overlay {
                                HStack {
                                    Text("Silent period")
                                        .frame(width: 100)
                                    TextField("..", value: $lobbyViewModel.lobby.silentDuration, formatter: NumberFormatter())
                                        .keyboardType(.numberPad)
                                        .multilineTextAlignment(.trailing)
                                        .padding(.trailing, 20)
                                    
                                }
                                
                            }
                        RoundedRectangle(cornerRadius: 10)
                            .frame(width: 148, height: 40)
                            .foregroundColor(.white)
                            .overlay {
                                HStack {
                                    HStack {
                                        Text("Question:")
                                            .frame(width: 100)
                                        TextField("Number of question", value: $lobbyViewModel.lobby.numberOfQuestion, formatter: NumberFormatter())
                                            .keyboardType(.numberPad)
                                    }
                                }
                                
                            }
                    }
                    RoundedRectangle(cornerRadius: 21)
                        .stroke(lineWidth: 2)
                        .frame(width: 234, height: 32)
                        .overlay {
                            HStack{
                                Image(systemName: "person.3.fill")
                                Text("Joined Player")
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
                                                            .font(.system(size : 12, weight : .regular))
                                                    }
                                                    
                                                    Spacer()
                                                    Image(systemName: guest.status.ImageButtonAdd)
                                                        .resizable()
                                                        .frame(width : 30, height : 30)
                                                        .onTapGesture {
                                                            multipeerController.invitePeer(guest.id, to: lobby)
                                                        }
                                                }.foregroundColor(guest.status.TextColor)
                                                    .padding()
                                            }
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
                        let connectedGuest = multipeerController.allGuest
                            .filter { $0.status == .connected }
                            .map { $0.id }
                        
                        multipeerController.sendMessage("START LISTEN", to: connectedGuest)
                        navigateToListenView = true
                        
                    } label: {
                        
                        
                        Text("Start!")
                            .font(.system(size: 28, weight : .bold))
                        
                        
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
    }
}
