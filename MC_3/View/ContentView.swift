//
//  ContentView.swift
//  MC_3
//
//  Created by Irvan P. Saragi on 14/07/23.
//

import SwiftUI

struct ContentView: View {
    @State private var playerData: PlayerData?
    @State private var multipeerController: MultipeerController?
    var defaultPlayer = Player(name: "Player", lobbyRole: .noLobbyRole, gameRole: .referee)
    
    @StateObject var vm = DataApp()
    @State private var navigateToNextView = false
    

    var body: some View {
        NavigationStack {
            ZStack {
                Color("Background")
                    .ignoresSafeArea()
                VStack {
                    Text("Welcome!")
                        .font(.system(.largeTitle, design: .rounded, weight: .semibold))
                    Text("Before starting, let's fill in your name first!")
                        .font(.system(size: 18, weight: .light,design: .rounded))
                        
                    Image("Image1")
                        .resizable()
                        .frame(width: 260, height: 260)
                    ZStack {
                        Capsule()
                            .frame(width: 250, height: 70)
                        TextField("Name", text: $vm.nama)
                        .frame(width: 250, height: 70)
                        .foregroundColor(Color("Background"))
                        .multilineTextAlignment(.center)
                        .font(.system(size: 30))
                        .fontWeight(.semibold)
                        
                    }//zstack
                    .padding(.top, -10)
                    
                    NavigationLink(
                        destination: ChooseRoleView()
                            .environmentObject(playerData ?? PlayerData(mainPlayer: defaultPlayer, playerList: [defaultPlayer]))
                        .environmentObject(multipeerController ?? MultipeerController(UIDevice.current.name))
                        .environmentObject(LobbyViewModel())
                    )
                    {
                        ZStack{
                            Capsule()
                                .stroke(Color("Second"), lineWidth : 2)
                                .frame(width: 314, height: 47)
                                .overlay {
                                    Capsule()
                                        .foregroundColor(Color("Main"))
                                        .opacity(0.4)
                                }
                            Text("ENTER")
                                .font(.system(size: 28, design: .rounded))
                                .fontWeight(.bold)
                                
                                
                        }
                    }
                    .padding(.top, 65)
                    .simultaneousGesture(
                        TapGesture().onEnded {
                            let player = Player(name: vm.nama, lobbyRole: .noLobbyRole, gameRole: .referee)
                            playerData = PlayerData(mainPlayer: player, playerList: [player])
                            multipeerController = MultipeerController(player.name)
                        }
                    )
                    .disabled(vm.nama.isEmpty)
                    .opacity(vm.nama.isEmpty ? 0.4 : 1.0)
            
                    
                }//Vstack
                .foregroundColor(Color("ColorText"))
            }// ZStack
        }// Navigation View
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}




