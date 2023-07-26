//
//  AskedView.swift
//  MC_3
//
//  Created by Sayed Zulfikar on 19/07/23.
// Ini orang yang ditanya


import SwiftUI

struct AskedView: View {
    @StateObject var synthesizerViewModel = SynthesizerViewModel()
    @EnvironmentObject var lobbyViewModel: LobbyViewModel
    @EnvironmentObject private var multipeerController: MultipeerController
    @EnvironmentObject private var playerData: PlayerData
//    @Binding var question: String
    @State var colors: [Color] = [.clear, .clear, Color("Second"), .red]
    @State private var AnswerNo : Bool = false
    @State private var dots: String = ""
    private let dotCount = 3
    private let dotDelay = 0.5
    
    var body: some View {
        ZStack{
            BubbleView()
            VStack(spacing : 20) {
                ZStack{
                    RoundedRectangle(cornerRadius: 12)
                        .frame(width: 170, height: 60)
                        .foregroundColor(Color("Second"))
                    Capsule()
                        .stroke(Color("Second"), lineWidth: 3)
                        .frame(width: 58, height: 14)
                        .overlay {
                            Capsule()
                                .foregroundColor(Color("Background"))
                            Text("Player")
                                .foregroundColor(Color("Second"))
                                .font(.system(size: 10, weight: .bold))
                        }
                        .padding(.bottom, 55)
                    Text("Adhi")
                        .font(.system(size: 32, weight: .bold))
                }
                Image(AnswerNo ? "Noob" : "Anjayy")
                    .resizable()
                    .frame(width: 278, height: 278)
                Text("Waiting for Judges to vote \nVoting : 4/6\(dots)")
                    .font(.system(size: 28, weight: .bold))
                    .foregroundColor(Color("Second"))
                    .multilineTextAlignment(.center)
                    .onAppear {
                        animateDots()
                    }
                ZStack{
                    RoundedRectangle(cornerRadius: 12)
                        .frame(width: 290, height: 168)
                        .foregroundColor(Color("Second"))
                        .overlay {
                            Text(multipeerController.receivedQuestion)
                                .font(.system(size: 17, weight: .medium))
                                .multilineTextAlignment(.center)
                                .padding()
                        }
                    Capsule()
                        .stroke(Color("Second"), lineWidth: 3)
                        .frame(width: 120, height: 28)
                        .overlay {
                            Capsule()
                                .foregroundColor(Color("Background"))
                            Text("Question")
                                .foregroundColor(Color("Second"))
                                .font(.system(size: 12, weight: .bold))
                        }
                        .padding(.bottom, 160)
                    Circle()
                        .stroke(Color("Second"), lineWidth : 4)
                        .frame(width: 100)
                        .overlay{
                            Circle()
                                .foregroundColor(Color("Background"))
                            Text("\(lobbyViewModel.lobby.currentQuestionIndex) / \(lobbyViewModel.lobby.numberOfQuestion)")
                                .font(.system(size: 16, weight: .semibold))
                                .foregroundColor(Color("Second"))
                            
                        }
                        .padding(.top, 170)
                    
                }
                
                
                Button {
                    synthesizerViewModel.startSpeaking(spokenString: multipeerController.receivedQuestion)
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
        }
        .task {
            synthesizerViewModel.startSpeaking(spokenString: multipeerController.receivedQuestion)
        }
    }
    
    func animateDots() {
        var count = 1
        dots = ""
        
        func addDot() {
            dots += "."
            count += 1
            if count <= dotCount {
                DispatchQueue.main.asyncAfter(deadline: .now() + dotDelay) {
                    addDot()
                }
            } else {
                DispatchQueue.main.asyncAfter(deadline: .now() + dotDelay) {
                    animateDots() // Start the animation again
                }
            }
        }
        
        addDot()
    }
}

struct AskedView_Previews: PreviewProvider {
    static let player = Player(name: "YourDisplayName", lobbyRole: .host, gameRole: .asked)
    static var playerData = PlayerData(mainPlayer: player, playerList: [player])
    static let multipeerController = MultipeerController("YourDisplayName") // Use the same instance
    @StateObject var synthesizerViewModel = SynthesizerViewModel()
    
    @State static var previewQuestion = "Sample Question"
    
    static var previews: some View {
//        AskedView(question: .constant("Hello"))
        AskedView()
            .environmentObject(multipeerController) // Use the same instance
            .environmentObject(playerData)
            .environmentObject(LobbyViewModel()) // Provide LobbyViewModel here
    }
}

