//
//  ResultView.swift
//  MC_3
//
//  Created by Sayed Zulfikar on 22/07/23.
//

import SwiftUI

struct ResultView: View {
    var screenWidth: CGFloat {
        UIScreen.main.bounds.width
    }
    
    var screenHeight: CGFloat {
        UIScreen.main.bounds.height
    }
    
    @StateObject var playerViewModel = PlayerViewModel()
    @EnvironmentObject var lobbyViewModel: LobbyViewModel
    @EnvironmentObject private var multipeerController: MultipeerController
    
    @State private var isDoneAllQuestion = false
    
    var body: some View {
        
        ZStack {
            BubbleView()
            GifImage(multipeerController.isWin ? "Cool" : "Huh!")
            .frame(width: 300, height: 300)
            .padding(.bottom, 170)
            VStack(spacing : 20) {
                ZStack{
                    RoundedRectangle(cornerRadius: 12)
                        .frame(width: 170, height: 60)
                        .foregroundColor(Color("Second"))
                        .overlay {
                            Text("\(multipeerController.currentPlayer)")
                                .frame(width: 170, height: 60)
                                .font(.system(size: 24, design: .rounded))
                                .fontWeight(.bold)
                                .foregroundColor(Color("Background"))
                                .multilineTextAlignment(.center)
                        }
                    Capsule()
                        .stroke(Color("Second"), lineWidth: 3)
                        .frame(width: 58, height: 14)
                        .overlay {
                            Capsule()
                                .foregroundColor(Color("Background"))
                            Text("PLAYER")
                                .foregroundColor(Color("Second"))
                                .font(.system(size: 10, design: .rounded))
                                .fontWeight(.bold)
                            
                        }
                        .padding(.bottom, 55)
                }
                .padding(.bottom, 250)
                Text(multipeerController.isWin ? "\(multipeerController.currentPlayer)'s Here \n\(multipeerController.currentPlayer) Hears" : "Find a New \nFriend" )
                    .font(.system(size: 32, design: .rounded))
                    .fontWeight(.bold)
                    .foregroundColor(Color("Second"))
                    .multilineTextAlignment(.center)
                ZStack{
                    RoundedRectangle(cornerRadius: 12)
                        .frame(width: 290, height: 168)
                        .foregroundColor(Color("Second"))
                        .overlay {
                            
                            if multipeerController.isPlayer {
                                Text(multipeerController.isWin ? "Keren banget! Kamu beneran perhatiin yak ternyata. 😆" : "Ah, gimana, deh! Gak asik banget nongkrong tapi gak dengerin. 🤬!")
                                     .font(.system(size: 17, design: .rounded))
                                     .fontWeight(.medium)
                                     .multilineTextAlignment(.center)
                                     .padding()
                            }
                            else {
                                Text(multipeerController.isWin ? "Hey, teman kamu mendengarkan dengan baik! Ayo traktir dia kopi susu gula aren!" : "Mendingan kamu cari temen baru aja, deh. Dia gak asik, ga dengerin pembicaraan!")
                                    .font(.system(size: 17, design: .rounded))
                                    .fontWeight(.medium)
                                    .multilineTextAlignment(.center)
                                    .padding()
                            }
                        }
                    Capsule()
                        .stroke(Color("Second"), lineWidth: 4)
                        .frame(width: 120, height: 28)
                        .overlay {
                            Capsule()
                                .foregroundColor(Color("Background"))
                            Text(multipeerController.isWin ? "Nice!" : "Booo!" )
                                .foregroundColor(Color("Second"))
                                .font(.system(size: 12, design: .rounded))
                                .fontWeight(.bold)
                        }
                        .padding(.bottom, 160)
                    Circle()
                        .stroke(Color("Second"), lineWidth : 4)
                        .frame(width: 60)
                        .overlay{
                            Circle()
                                .frame(width: 60)
                                .foregroundColor(Color("Background"))
                            Text("\(multipeerController.lobby.currentQuestionIndex) / \(multipeerController.lobby.numberOfQuestion)")
                                .font(.system(size: 16, design: .rounded))
                                .fontWeight(.semibold)
                                .foregroundColor(Color("Second"))
                            
                        }
                        .padding(.top, 170)
                    
                }
                
                
                Button {
                    if multipeerController.isPlayer {
                        playerViewModel.playAudio(fileName: multipeerController.isWin ? "WinPlayer" : "LosePlayer")
                    }
                    else {
                        playerViewModel.playAudio(fileName: multipeerController.isWin ? "WinReferee" : "LoseReferee")
                    }
                } label: {
                    ZStack{
                        RoundedRectangle(cornerRadius: 20)
                            .frame(width: 76, height: 30)
                            .foregroundColor(Color("Main"))
                        Image(systemName: "speaker.wave.3.fill")
                            .resizable()
                            .frame(width: 22, height: 16)
                            .foregroundColor(Color("Second"))
                        
                    }
                }
                
            }
            .padding(.top, 40)
            
            
            Button {
                if multipeerController.isPlayer {
                    let connectedGuest = multipeerController.getConnectedPeers()
                    
                    if isDoneAllQuestion {
                        // Go to End
                        multipeerController.sendMessage(NavigateCommandConstant.navigateToEnd, to: connectedGuest)
                        multipeerController.navigateToEnd = true
                        
                    }
                    else {
                        multipeerController.resetParameters(page: NavigateCommandConstant.navigateToChoosingPlayer)
                        
                        multipeerController.sendMessage(NavigateCommandConstant.navigateToChoosingPlayer, to: connectedGuest)
                        multipeerController.navigateToChoosingPlayer = true
                        
                    }
                }
                
            } label: {
                ZStack{
                    Text(multipeerController.isPlayer ? "Next >" : "")
                        .font(.system(size: 17, weight : .regular))
                        .foregroundColor(Color("Second"))
                    Rectangle()
                        .foregroundColor(.clear)
                }
            }
            .buttonStyle(HeaderButtonStyle())
            .offset(x: screenWidth * 0.35, y: -screenHeight * 0.44)
        }
        .navigationBarBackButtonHidden(true)
        .background(
            NavigationLink(
                destination: EndView()
                    .environmentObject(multipeerController)
                    .environmentObject(lobbyViewModel),
                isActive: $multipeerController.navigateToEnd
            ) {
                EmptyView()
            }
        )
        .onAppear() {
            multipeerController.resetNavigateVar()
            
            if multipeerController.totalQuestion == multipeerController.currentQuestion {
                isDoneAllQuestion = true
            }
            
            if multipeerController.isPlayer {
                playerViewModel.playAudio(fileName: multipeerController.isWin ? "WinPlayer" : "LosePlayer")
            }
            else{
                playerViewModel.playAudio(fileName: multipeerController.isWin ? "WinReferee" : "LoseReferee")
            }
        }
        
        
        
    }
}

struct ResultView_Previews: PreviewProvider {
    
    static var previews: some View {
        ResultView()
            .environmentObject(MultipeerController("YourDisplayName"))
            .environmentObject(LobbyViewModel())
    }
}
