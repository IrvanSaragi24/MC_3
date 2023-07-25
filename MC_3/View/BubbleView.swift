//
//  TimerView.swift
//  MC_3
//
//  Created by Irvan P. Saragi on 19/07/23.
//

import SwiftUI

struct BubbleView: View {
    @State private var ButtonStop = false
    @State private var circle1Offset = CGSize(width: 150, height: 200)
    @State private var circle1Opacity = 0.4
    @State private var circle2Offset = CGSize(width: -130, height: -100)
    @State private var circle2Opacity = 0.4
    @State private var circle3Offset = CGSize(width: 130, height: -300)
    @State private var circle3Opacity = 0.4
    @State private var circle4Offset = CGSize(width: -130, height: 300)
    @State private var circle4Opacity = 0.4
    
    private let animationDuration = 6.0
    
    var body: some View {
        ZStack{
            Color("Background")
                .ignoresSafeArea()
            ForEach(0..<4) { index in
                Circle()
                    .frame(width: index.isMultiple(of: 2) ? 167 : 268)
                    .foregroundColor(index.isMultiple(of: 2) ? Color("Second") : Color("Main"))
                    .opacity(getCircleOpacity(index: index))
                    .offset(getCircleOffset(index: index))
                    .shadow(color: .white, radius: 5)
                    .animation(Animation.easeInOut(duration: animationDuration))
            }
//            if ButtonStop {
//                pickupphone()
//            }else{
//                ListeningView(ButtonStop: $ButtonStop)
//            }
        }.onAppear {
            animateCircles()
        }
    }
    private func animateCircles() {
        _ = UIScreen.main.bounds.width
        _ = UIScreen.main.bounds.height
        
        // Randomize initial positions and opacities
        circle1Offset = randomOffset()
        circle2Offset = randomOffset()
        circle3Offset = randomOffset()
        circle4Offset = randomOffset()
        
        circle1Opacity = Double.random(in: 0.0...0.6)
        circle2Opacity = Double.random(in: 0.0...0.6)
        circle3Opacity = Double.random(in: 0.0...0.6)
        circle4Opacity = Double.random(in: 0.0...0.6)
        
        // Randomize animations
        withAnimation(Animation.easeInOut(duration: animationDuration)) {
            circle1Offset = randomOffset()
            circle2Offset = randomOffset()
            circle3Offset = randomOffset()
            circle4Offset = randomOffset()
        }
        
        // Randomly disappear and reappear the circles
        DispatchQueue.main.asyncAfter(deadline: .now() + animationDuration / 2) {
            withAnimation(Animation.easeInOut(duration: animationDuration / 2)) {
                circle1Opacity = Double.random(in: 0.0...0.2)
                circle2Opacity = Double.random(in: 0.0...0.2)
                circle3Opacity = Double.random(in: 0.0...0.2)
                circle4Opacity = Double.random(in: 0.0...0.2)
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + animationDuration / 2) {
                withAnimation(Animation.easeInOut(duration: animationDuration / 2)) {
                    circle1Opacity = Double.random(in: 0.0...0.6)
                    circle2Opacity = Double.random(in: 0.0...0.6)
                    circle3Opacity = Double.random(in: 0.0...0.6)
                    circle4Opacity = Double.random(in: 0.0...0.6)
                }
                animateCircles() // Repeat the animation loop
            }
        }
    }
    
    func randomOffset() -> CGSize {
        let screenWidth = UIScreen.main.bounds.width
        let screenHeight = UIScreen.main.bounds.height
        return CGSize(width: CGFloat.random(in: -screenWidth...screenWidth),
                      height: CGFloat.random(in: -screenHeight...screenHeight))
    }
    
    func getCircleOffset(index: Int) -> CGSize {
        switch index {
        case 0: return circle1Offset
        case 1: return circle2Offset
        case 2: return circle3Offset
        case 3: return circle4Offset
        default: return .zero
        }
    }
    
    func getCircleOpacity(index: Int) -> Double {
        switch index {
        case 0: return circle1Opacity
        case 1: return circle2Opacity
        case 2: return circle3Opacity
        case 3: return circle4Opacity
        default: return 0.0
        }
    }
}

struct BubbleView_Previews: PreviewProvider {
    static var previews: some View {
        BubbleView()
    }
}
//
//struct ListeningView: View {
//    @Binding var ButtonStop : Bool
//    var body: some View {
//        VStack(spacing : 44){
//            Circle()
//                .stroke(Color("Main"), lineWidth: 10)
//                .frame(width: 234)
//                .overlay {
//                    Circle()
//                        .foregroundColor(Color.red)
//                    Image("Music")
//                        .resizable()
//                        .scaledToFit()
//                        .frame(width: 225)
//                }
//                .padding(.top, 24)
//            Text("Listening..")
//                .font(.system(size: 36, weight: .semibold))
//                .foregroundColor(Color("Second"))
//            ZStack{
//                RoundedRectangle(cornerRadius: 20)
//                    .stroke(Color("Second"), lineWidth: 4)
//                    .frame(width: 234, height: 56)
//                    .overlay {
//                        RoundedRectangle(cornerRadius: 20)
//                            .foregroundColor(Color("Second"))
//                            .opacity(0.2)
//                    }
//                Text("10.30")
//                    .font(.system(size: 32))
//                    .fontWeight(.semibold)
//                    .foregroundColor(Color("Second"))
//            }
//            Spacer()
//            Button {
//                ButtonStop = true
//            } label: {
//                ZStack{
//                    RoundedRectangle(cornerRadius: 20)
//
//                        .frame(width: 358, height: 48)
//                        .foregroundColor(Color("Main"))
//                        .overlay(
//                            RoundedRectangle(cornerRadius: 20)
//                                .stroke(Color("Second"), lineWidth: 4)
//                        )
//
//                    Text("Stop!")
//                        .font(.system(size: 28, weight: .heavy))
//                        .foregroundColor(Color("Second"))
//                }
//            }
//
//
//        }
//    }
//}
//struct pickupphone : View{
//    @State private var ButtonPick : Bool = false
//    var body: some View{
//        if ButtonPick{
//            QuestionView()
//        }
//        else{
//            VStack{
//                Spacer()
//                Text("Pick \n up \n your \n Phone")
//                    .font(.system(size: 72, weight: .bold))
//                    .multilineTextAlignment(.center)
//                    .foregroundColor(Color("Main"))
//                    .overlay(
//                        Text("Pick \n up \n your \n Phone")
//                            .font(.system(size: 72, weight: .bold))
//                            .foregroundColor(Color("Second"))
//                            .offset(x: 2, y: 2) // Offset the white text to create a stroke effect
//                    )
//                    .multilineTextAlignment(.center)
//                Spacer()
//                Button {
//                    ButtonPick = true
//                } label: {
//                    ZStack{
//                        RoundedRectangle(cornerRadius: 20)
//
//                            .frame(width: 358, height: 48)
//                            .foregroundColor(Color("Main"))
//                            .overlay(
//                                RoundedRectangle(cornerRadius: 20)
//                                    .stroke(Color("Second"), lineWidth: 4)
//                            )
//
//                        Text("Question")
//                            .font(.system(size: 28, weight: .heavy))
//                            .foregroundColor(Color("Second"))
//                    }
//                }
//
//            }
//        }
//    }
//}
