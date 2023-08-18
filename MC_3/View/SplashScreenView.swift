//
//  SplashScreen.swift
//  MC_3
//
//  Created by Irvan P. Saragi on 26/07/23.
//

import SwiftUI

struct SplashScreenView: View {
    @State private var scale: CGFloat = 0.5
    @State private var waveAngle: Double = 0.0
    @Environment(\.colorScheme) var colorScheme
    var body: some View {
        ZStack {
            BubbleView()
            VStack {
                if colorScheme == .dark {
                    // Use the dark mode logo
                    Image("LogoLight")
                        .resizable()
                        .rotationEffect(Angle(degrees: 30))
                        .frame(width: 200, height: 200)
                        .rotationEffect(.degrees(waveAngle))
                        .animation(Animation.easeInOut(duration: 1.0).repeatForever()) // Repeat the animation indefinitely
                        .onAppear {
                            withAnimation {
                                waveAngle = -30.0 // Set the initial wave angle to -30 degrees
                            }
                        }
                        .padding()
                } else {
                    Image("LogoDark")
                        .resizable()
                        .rotationEffect(Angle(degrees: 30))
                        .frame(width: 200, height: 200)
                        .rotationEffect(.degrees(waveAngle))
                        .animation(Animation.easeInOut(duration: 1.0).repeatForever()) // Repeat the animation indefinitely
                        .onAppear {
                            withAnimation {
                                waveAngle = -30.0 // Set the initial wave angle to -30 degrees
                            }
                        }
                }
                // Image("Ehlo")
                Text("EhLo")
                    .font(.system(size: 40, weight: .heavy, design: .rounded))
                    .foregroundColor(Color("Second"))
                    .padding(.top, 50)
            }
            .scaleEffect(scale) // Apply scaling effect to ContentView
            .animation(.easeInOut(duration: 0.5)) // Customize animation
            .onAppear {
                scale = 1.2 // Scale to 1.2 when ContentView appears
            }
        }
    }
}

struct SplashScreenView_Previews: PreviewProvider {
    static var previews: some View {
        SplashScreenView()
    }
}
