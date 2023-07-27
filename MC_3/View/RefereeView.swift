//
//  JudgeView.swift
//  MC_3
//
//  Created by Sayed Zulfikar on 19/07/23.
//

import SwiftUI

struct RefereeView: View {
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
                .environmentObject(multipeerController) // Use the same instance
                .environmentObject(playerData)
                .environmentObject(LobbyViewModel()) // Provide LobbyViewModel
        }
        else {
            ZStack{
            Color.clear.backgroundStyle()
            BubbleView()
            VStack{
//                Text(message)
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
                            Text("REFEREE")
                                .foregroundColor(Color("Second"))
                                .font(.system(size: 9, weight: .bold))
                        }
                        .padding(.bottom, 55)
                    Text("\(multipeerController.myPeerId.displayName)")
                        .font(.system(size: 32, weight: .bold))
                }
                Image("ImageReferee")
                    .resizable()
                    .frame(width: 234, height: 234)
                
                
                ZStack{
                    Text(vibrateOnRing || vibrateOnRing1 ? "Wait for referees to vote \nVoting : \(multipeerController.nonNullVotes)/\(multipeerController.getConnectedPeers().count)\(dots)" : "Judge The \n Player")
                        .font(.system(size:vibrateOnRing || vibrateOnRing1 ?  20 : 32 , weight: .bold))
                        .multilineTextAlignment(.center)
                        .foregroundColor(Color("Second"))
                        .padding(.bottom, 100)
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
                        .padding(.top, 140)
                        .opacity(vibrateOnRing ? 1 : 0)
                    Image("Dislike")
                        .resizable()
                        .frame(width: 132, height: 132)
                        .padding(.top, 140)
                        .opacity(vibrateOnRing1 ? 1 : 0)
                    
                }
                Text(vibrateOnRing || vibrateOnRing1 ? "You’ve Casted Your Vote!":"Swipe To Judge\n The Player" )
                    .font(.system(size: 20,weight: .semibold))
                    .foregroundColor(Color("Second"))
                    .opacity(0.4)
                    .multilineTextAlignment(.center)
                    .padding()
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
                HStack{
                    Image(systemName: "chevron.right.2")
                        .font(.system(size: 50, weight: .bold))
                        .foregroundColor(Color("Main"))
                        .offset(x: swapOffset)
                        .opacity(opacity)
                        .animation(Animation.easeInOut(duration: 1.0).repeatForever())
                    Image(systemName: "chevron.right.2")
                        .font(.system(size: 50, weight: .bold))
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
                                        multipeerController.sendMessage(selectedMessage, to: multipeerController.getConnectedPeers())

                                        if selectedMessage == "Yes:VoteStatus" {
                                            multipeerController.updateVotes(vote: Vote(voterID: multipeerController.myPeerId, status: .yes))
                                        } else if selectedMessage == "No:VoteStatus" {
                                            multipeerController.updateVotes(vote: Vote(voterID: multipeerController.myPeerId, status: .no))
                                        }
//                                        message = message
//                                        multipeerController.sendMessage("Yes:VoteStatus", to: multipeerController.getConnectedPeers())
//                                        multipeerController.updateVotes(vote: Vote(voterID: multipeerController.myPeerId, status: .yes))
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
