//
//  TrainVoiceView.swift
//  MC_3
//
//  Created by Irvan P. Saragi on 16/07/23.
//

import SwiftUI

struct TrainVoiceView: View {
    
    let minValue: Double = 0.0
    let maxValue: Double = 10.0
    let step: Double = 0.1 // Set the step size for the picker
    @State private var swapOffset: CGFloat = 0
    @State private var opacity: Double = 1.0
    
    var body: some View {
        HStack() {
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
                        .opacity(opacity) // The second image's opacity is the opposite of the first one
                        .animation(Animation.easeInOut(duration: 1.0).repeatForever())
                }
                .onAppear {
                    withAnimation(Animation.easeInOut(duration: 2.0).repeatForever()) {
                        swapOffset = 30 // Set the desired horizontal offset for swapping
                        opacity = 0.5 // Set the desired opacity for the animation
                    }
                }
    }
}


struct TrainVoiceView_Previews: PreviewProvider {
    static var previews: some View {
        TrainVoiceView()
    }
}
