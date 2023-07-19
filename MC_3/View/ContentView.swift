//
//  ContentView.swift
//  MC_3
//
//  Created by Irvan P. Saragi on 14/07/23.
//

import SwiftUI

struct ContentView: View {
    @State private var playerData: PlayerData?
    @State private var connectionManager: ConnectionManager?
    var defaultPlayer = Player(name: "Player", role: .noRole)
    
    @StateObject var vm = DataApp()
    @State private var navigateToNextView = false
    

    var body: some View {
        NavigationView {
            ZStack {
                Color("Background")
                    .ignoresSafeArea()
                VStack {
                    Text("Welcome")
                        .font(.system(.largeTitle, design: .rounded, weight: .semibold))
                    Text("Before starting, let's fill in your name first!")
                        .font(.system(size: 18))
                    Image("Image1")
                        .resizable()
                        .frame(width: 260, height: 260)
                    ZStack {
                        Capsule()
                            .frame(width: 250, height: 70)
                        TextField("Name", text: $vm.nama, onCommit: {
                            navigateToNextView = true
                        })
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
                        .environmentObject(connectionManager ?? ConnectionManager(UIDevice.current.name))
                    )
                    {
                            Label("Enter", systemImage: "hand.point.right.fill")
                    }
                    .buttonStyle(MultipeerButtonStyle())
                    .simultaneousGesture(
                        TapGesture().onEnded {
                            let player = Player(name: vm.nama, role: .noRole)
                            playerData = PlayerData(mainPlayer: player, playerList: [player])
                            connectionManager = ConnectionManager(player.name)
                        }
                    )
                    
                }//Vstack
                .foregroundColor(Color("ColorText"))
            }// ZStack
            .navigationBarHidden(true)
            .navigationBarTitle("")
            .navigationBarBackButtonHidden(true)
            .background(
                NavigationLink(
                    destination: TrainVoiceView(name: vm.nama, title: vm.dataModels.map { $0.title }),
                    isActive: $navigateToNextView) {
                    Text("Go to TrainVoiceView")
                }

            )
        }// Navigation View
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}




