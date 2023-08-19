//
//  LoadingView.swift
//  MC_3
//
//  Created by Irvan P. Saragi on 22/07/23.
//

import SwiftUI

struct LoadingView: View {
    @State private var isWaiting: Bool = false
    @State var textWait: String
    @State var circleSize: CGFloat
    @State var lineWidthCircle: CGFloat
    @State var lineWidthCircle2: CGFloat

    var yOffset: CGFloat

    var body: some View {
        ZStack {
            Color.clear.backgroundStyle()
            Circle()
            .foregroundColor(Color("Main"))
            .frame(width: 301, height: 301)
            .opacity(0.3)
            .offset(x: 130, y: -200)
            Circle()
            .foregroundColor(Color("Main"))
            .frame(width: 569)
            .opacity(0.3)
            .offset(x: -130, y: 250)
            VStack(spacing: 100) {
                ZStack {
                    Circle()
                        .stroke(Color("Second"), lineWidth: lineWidthCircle)
                        .frame(width: circleSize)
                        .opacity(0.4)
                        .offset(x: 0, y: yOffset)
                    Circle()
                        .trim(from: 0.4, to: 0.8)
                        .stroke( Color("Second"), style: StrokeStyle(lineWidth: lineWidthCircle2, lineCap: .round))
                        .frame(width: circleSize)
                        .rotationEffect(Angle(degrees: isWaiting ? 0 : -360))
                        .animation(Animation.linear(duration: 2)
                        .repeatForever(autoreverses: false), value: isWaiting)
                        .offset(x: 0, y: yOffset)
                }
                Text(textWait)
                    .foregroundColor(Color("Second"))
                    .font(.system(size: 24, weight: .medium))
            }
            .padding(.top, 50)
        }
        .edgesIgnoringSafeArea(.all)
        .onAppear {
            isWaiting = true
        }
    }
}

struct LoadingView_Previews: PreviewProvider {
    static var previews: some View {
        LoadingView(textWait: "Hello", circleSize: 166, lineWidthCircle: 40, lineWidthCircle2: 35, yOffset: 300)
    }
}
