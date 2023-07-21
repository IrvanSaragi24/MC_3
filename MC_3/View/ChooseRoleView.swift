//
//  ChooseRoleView.swift
//  MC_3
//
//  Created by Sayed Zulfikar on 18/07/23.
//

import SwiftUI

struct ChooseRoleView: View {
    var namePlayer : String
    @EnvironmentObject private var connectionManager: ConnectionManager
    @EnvironmentObject private var playerData: PlayerData
    
    
    @State private var isWaiting = false
    @State private var hideBackButton = false
    
    var body: some View {
        NavigationView{
            VStack {
                if isWaiting {
                    Text("Waiting Host")
                    LoaderView(tintColor: .purple, scaleSize: 5.0).padding()
                    
                }
                else {
                    ZStack{
                        Color.clear.backgroundStyle()
                        VStack(){
                            Text("HANGOUT MODE")
                                .font(.system(size: 36, weight: .bold))
                                .foregroundColor(Color("Second"))
                            NavigationLink(
                                destination: LobbyView(name: namePlayer)
                                    .environmentObject(connectionManager)
                                    .environmentObject(playerData),
                                isActive: $hideBackButton
                            )
                            {
                                ZStack{
                                    Circle()
                                        .shadow(color: .black, radius: 2)
                                        .foregroundColor(Color("Second"))
                                    VStack{
                                        Image(systemName: "crown.fill")
                                            .resizable()
                                            .frame(width: 25, height: 25)
                                        Image(systemName: "person.fill")
                                            .resizable()
                                            .frame(width: 55, height: 55)
                                        Text("HOST")
                                            .font(.title)
                                            .fontWeight(.bold)
                                    }
                                    .foregroundColor(Color("User"))
                                }
                                .frame(width: 262)
                            }.padding(.bottom, 65)
//
                            Button(
                                action: {
                                    connectionManager.isReceivingHangout = true
                                    isWaiting = true
                                }, label: {
                                    ZStack{
                                        Circle()
                                            .shadow(color: .black, radius: 2)
                                            .foregroundColor(Color("Second"))
                                        
                                        
                                        VStack{
                                            Image(systemName: "person.fill")
                                                .resizable()
                                                .frame(width: 55, height: 55)
                                            Text("GUEST")
                                                .font(.title)
                                                .fontWeight(.bold)
                                            
                                        }
                                        
                                        .foregroundColor(Color("User"))
                                    }
                                    .frame(width: 262)
                                })
                            .onTapGesture {
                                playerData.mainPlayer.role = .guest
                            }
                        }
                    }
                }
            }
//            .navigationTitle("HANGOUT MODE")
////            .navigationViewStyle(Color("Main"))
            
        }
        .navigationBarBackButtonHidden(hideBackButton)
            .animation(nil, value: hideBackButton)
        
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
    static let player = Player(name: "Player", role: .noRole)
    static var playerData = PlayerData(mainPlayer: player, playerList: [player])
    
    static var previews: some View {
        ChooseRoleView(namePlayer: "")
            .environmentObject(ConnectionManager(player.name))
            .environmentObject(playerData)
    }
}

