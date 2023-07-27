//
//  HangOutView.swift
//  MC_3
//
//  Created by Irvan P. Saragi on 17/07/23.
//

import SwiftUI

struct HangOutView: View {
    @State private var vibrateOnRing = false
    @State private var showRoles = false
    @State private var circleScale: CGFloat = 1.0
    var body: some View {
        if vibrateOnRing {
            ContentView()
        } else {
            ZStack{
                Color("Second")
                    .ignoresSafeArea()
                ZStack{
                    ZStack{
                        Circle()
                            .foregroundColor(Color("Main"))
                            .frame(width: 694)
                        Circle()
                            .foregroundColor(Color("Background"))
                            .frame(width: 560)
                    }
                    .scaleEffect(circleScale)
                    VStack{
                        Text("HANGOUT\nMODE")
                            .multilineTextAlignment(.center)
                            .foregroundColor(Color("Second"))
                            .font(.system(size: 50, design: .rounded))
                            .fontWeight(.bold)
                        //                        ExtractedView()
                        ButtonSlider(circleScale: $circleScale, vibrateOnRing: $vibrateOnRing)
                        
                    }
                }
            }
        }
    }
}

struct HangOutView_Previews: PreviewProvider {
    static var previews: some View {
        HangOutView()
    }
}

struct ButtonSlider: View {
    @State private var buttonWidth: Double = UIScreen.main.bounds.width - 90
    @State private var buttonOffset: CGFloat = 0
    @Binding var circleScale: CGFloat
    @Binding var vibrateOnRing : Bool
    var body: some View {
        ZStack {
            ZStack {
                Capsule()
                    .fill(Color("Main").opacity(0.2))
                Capsule()
                    .fill(Color("Second").opacity(0.2))
                    .padding(8)
                Text("Let's Play!")
                    .font(.system(size: 20, design: .rounded))
                    .fontWeight(.medium)
                    .foregroundColor(Color("Second"))
                    .opacity(0.6)
                    .offset(x: 20)
                HStack {
                    Capsule()
                        .fill(Color("Background"))
                        .shadow(color: .white, radius: 4)
                        .frame(width: buttonOffset + 80)
                    Spacer()
                }
                HStack {
                    ZStack {
                        Circle()
                            .stroke(Color("Second"), lineWidth : 2)
                        Circle()
                            .fill(Color.white.opacity(0.15))
                            .padding(8)
                        Image(systemName: "chevron.right.2")
                            .font(.system(size: 24, weight: .bold))
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
                                        
                                        buttonOffset = buttonWidth - 80
                                        vibrateOnRing = true
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
