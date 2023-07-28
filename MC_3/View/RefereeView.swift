//
//  JudgeView.swift
//  MC_3
//
//  Created by Sayed Zulfikar on 19/07/23.
//

import SwiftUI

struct RefereeView: View {
    @StateObject var motionViewModel = MotionViewModel()
    @EnvironmentObject var lobbyViewModel: LobbyViewModel
    @EnvironmentObject private var multipeerController: MultipeerController
    @EnvironmentObject private var playerData: PlayerData
    @State var colors: [Color] = [.clear, .clear, Color("Second"), .red]
    @State private var currentQuestionIndex = 0
    @State private var vibrateOnRing = false
    @State private var vibrateOnRing1 = false
    @State private var circleScale: CGFloat = 1.0
    @State private var dots: String = ""
    @State private var message: String = "Default"
    private let dotCount = 3
    private let dotDelay = 0.5
    
    var body: some View {
        
        if multipeerController.isPlayer {
            AskedView()
                .environmentObject(multipeerController)
                .environmentObject(playerData)
                .environmentObject(lobbyViewModel)
        }
        else {
            if multipeerController.isResultView {
                ResultView()
                    .environmentObject(multipeerController)
                    .environmentObject(playerData)
                    .environmentObject(lobbyViewModel)
            }
            else {
                ZStack{
                    BubbleView()
                    GifImage("Time")
                    .frame(width: 450, height: 400)
                    .padding(.bottom, 170)
                    VStack{
                        //                Text(message)
                        ZStack{
                            RoundedRectangle(cornerRadius: 12)
                                .frame(width: 170, height: 60)
                                .foregroundColor(Color("Second"))
                                .overlay {
                                    Text("\(multipeerController.myPeerId.displayName)")
                                        .frame(width: 170, height: 60)
                                        .font(.system(size: 24, design: .rounded))
                                        .fontWeight(.bold)
                                    //                                .fontWeight(.bold)
                                        .foregroundColor(Color("Background"))
                                        .multilineTextAlignment(.center)
                                }
                            Capsule()
                                .stroke(Color("Second"), lineWidth: 3)
                                .frame(width: 58, height: 14)
                                .overlay {
                                    Capsule()
                                        .foregroundColor(Color("Background"))
                                    Text("REFEREE")
                                        .foregroundColor(Color("Second"))
                                        .font(.system(size: 9, design: .rounded))
                                        .fontWeight(.bold)
                                    
                                }
                                .padding(.bottom, 55)
                            
                        }
                        .padding(.bottom, 300)
//                        Image("ImageReferee")
//                            .resizable()
//                            .frame(width: 234, height: 234)
                        
                        
                        ZStack{
                            ZStack{
                                Text(vibrateOnRing || vibrateOnRing1 ? "Wait for referees to vote \nVoting : \(multipeerController.totalVote)/\(multipeerController.getConnectedPeers().count)\(dots)" : "Judge The \n Player")
                                    .font(.system(size:vibrateOnRing || vibrateOnRing1 ?  20 : 32 ,weight: .bold, design: .rounded))
                                    .multilineTextAlignment(.center)
                                    .foregroundColor(Color("Second"))
                                    .padding(.bottom, 170)
                                    .onAppear {
                                        animateDots()
                                    }
                                ButtonSliderReferee(circleScale: $circleScale, vibrateOnRing: $vibrateOnRing1, vibrateOnRing1: $vibrateOnRing1, message: .constant("No:VoteStatus"))
                                    .rotationEffect(Angle(degrees: 90))
                                    .padding(.leading, 290)
                                    .padding(.top, 100)
                                    .opacity(vibrateOnRing || vibrateOnRing1 ? 0 : 1)
                                    .environmentObject(multipeerController)
                                ButtonSliderReferee(circleScale: $circleScale, vibrateOnRing: $vibrateOnRing, vibrateOnRing1: $vibrateOnRing, message: .constant("Yes:VoteStatus"))
                                    .rotationEffect(Angle(degrees: -90))
                                    .padding(.trailing, 280)
                                    .opacity(vibrateOnRing || vibrateOnRing1 ? 0 : 1)
                                    .environmentObject(multipeerController)
                                Image("Like")
                                    .resizable()
                                    .frame(width: 132, height: 132)
                                    .padding(.top, 60)
                                    .opacity(vibrateOnRing ? 1 : 0)
                                Image("Dislike")
                                    .resizable()
                                    .frame(width: 132, height: 132)
                                    .padding(.top, 60)
                                    .opacity(vibrateOnRing1 ? 1 : 0)
                                
                            }
                            Text(vibrateOnRing || vibrateOnRing1 ? "You’ve Casted Your Vote!":"Swipe To Judge\n The Player" )
                                .font(.system(size: 20,weight: .semibold, design: .rounded))
                                .foregroundColor(Color("Second"))
                                .opacity(0.4)
                                .multilineTextAlignment(.center)
                                .padding(.top, 250)
                        }
                    }
                }
                .onAppear() {
                    multipeerController.isChoosingView = false
                    vibrateOnRing = false
                    vibrateOnRing1 = false
                    motionViewModel.startNoddingDetection()
                    motionViewModel.startShakingDetection()
                }
                .onChange(of: motionViewModel.isShakingDetected) { newValue in
                    if newValue == true {
                        multipeerController.sendMessage(MsgCommandConstant.voteNo, to: multipeerController.getConnectedPeers())
                        multipeerController.noVote += 1
                        multipeerController.totalVote += 1
                    }
                }
                .onChange(of: motionViewModel.isNoddingDetected) { newValue in
                    if newValue == true {
                        multipeerController.sendMessage(MsgCommandConstant.voteYes, to: multipeerController.getConnectedPeers())
                        multipeerController.yesVote += 1
                        multipeerController.totalVote += 1
                    }
                }
            }
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

struct RefereeView_Previews: PreviewProvider {
    static var previews: some View {
        let player = Player(name: "Player", lobbyRole: .host, gameRole: .asked)
        let playerData = PlayerData(mainPlayer: player, playerList: [player])
        let lobbyViewModel = LobbyViewModel()
        let multipeerController = MultipeerController("YourDisplayName")
        
        RefereeView()
            .environmentObject(lobbyViewModel)
            .environmentObject(multipeerController)
            .environmentObject(playerData)
    }
}

struct ButtonSliderReferee: View {
    @State private var buttonWidth: Double = UIScreen.main.bounds.width - 80
    @State private var buttonOffset: CGFloat = 0
    @Binding var circleScale: CGFloat
    @Binding var vibrateOnRing : Bool
    @Binding var vibrateOnRing1 : Bool
    @State private var swapOffset: CGFloat = 0
    @State private var opacity: Double = 1.0
    @EnvironmentObject private var multipeerController: MultipeerController
    @Binding var message: String
    var body: some View {
        ZStack {
            ZStack {
                ZStack {
                    HStack{
                        Image(systemName: "chevron.right.2")
                            .font(.system(size: 50, weight: .bold, design: .rounded))
                            .foregroundColor(Color("Main"))
                            .offset(x: swapOffset)
                            .opacity(opacity)
                            .animation(Animation.easeInOut(duration: 1.0).repeatForever())
                        Image(systemName: "chevron.right.2")
                            .font(.system(size: 50, weight: .bold, design: .rounded))
                            .foregroundColor(Color("Main"))
                            .offset(x: swapOffset)
                            .opacity(opacity)
                            .animation(Animation.easeInOut(duration: 1.0).repeatForever())
                    }
                    .onAppear {
                        withAnimation(Animation.easeInOut(duration: 3.0).repeatForever()) {
                            swapOffset = 5 // Set the desired horizontal offset for swapping
                            opacity = 0 // Set the desired opacity for the animation
                        }
                    }
                }
                
                .padding(.leading, 60)
                
                
                HStack {
                    Capsule()
                        .fill(Color("Background"))
                        .shadow(color: .white, radius: 1)
                        .frame(width: buttonOffset + 80)
                    Spacer()
                }
                HStack {
                    ZStack {
                        Circle()
                            .stroke(Color("Second"), lineWidth : 2)
                        Circle()
                            .fill(Color("Main").opacity(0.8))
                            .padding(8)
                        Image(systemName: "hand.thumbsup.fill")
                            .font(.system(size: 32, weight: .bold))
                            .rotationEffect(Angle(degrees: 90))
                        
                    }
                    .foregroundColor(Color("Second"))
                    .frame(width: 80, height: 80, alignment: .center)
                    .offset(x: buttonOffset)
                    .gesture(
                        DragGesture()
                            .onChanged { gesture in
                                if gesture.translation.width > 0 && buttonOffset <= buttonWidth - 100 {
                                    buttonOffset = gesture.translation.width
                                    circleScale = scaleCircle(offset: gesture.translation.width)
                                }
                            }
                            .onEnded { _ in
                                withAnimation(Animation.easeOut(duration: 1.0)) {
                                    if buttonOffset > buttonWidth / 2 {
                                        
                                        let selectedMessage = message
                                        
                                        
                                        if selectedMessage == "Yes:VoteStatus" {
                                            multipeerController.sendMessage(MsgCommandConstant.voteYes, to: multipeerController.getConnectedPeers())
                                            multipeerController.yesVote += 1
                                            multipeerController.totalVote += 1
                                            
                                        } else if selectedMessage == "No:VoteStatus" {
                                            multipeerController.sendMessage(MsgCommandConstant.voteNo, to: multipeerController.getConnectedPeers())
                                            multipeerController.noVote += 1
                                            multipeerController.totalVote += 1
                                            
                                        }
                                        
                                        buttonOffset = buttonWidth - 80
                                        vibrateOnRing = true
                                        vibrateOnRing1 = true
                                    } else {
                                        buttonOffset = 0
                                    }
                                    circleScale = 1.0
                                    
                                }
                            }
                    )
                    Spacer()
                }
            }
            .frame(width: buttonWidth, height: 80, alignment: .center)
            .padding()
            
            
        }
    }
    private func scaleCircle(offset: CGFloat) -> CGFloat {
        let scaledOffset = offset / (buttonWidth - 90) // Normalize the offset
        let scaleFactor = 1 + (scaledOffset * 0.5) // Adjust the scale factor as needed
        return min(1.5, scaleFactor) // Ensure the maximum scale is 1.5
    }
}
