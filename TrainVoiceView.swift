//
//  TrainVoiceView.swift
//  MC_3
//
//  Created by Irvan P. Saragi on 16/07/23.
//

import SwiftUI

struct TrainVoiceView: View {
    
    @State private var dots: String = ""
    private let dotCount = 3
    private let dotDelay = 0.5
    var body: some View {
        Text("Wew\(dots)")
            .font(.system(size: 32, weight: .bold))
            .foregroundColor(Color("Second"))
            .onAppear {
                animateDots()
            }
    }
    
    private func animateDots() {
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

struct TrainVoiceView_Previews: PreviewProvider {
    static var previews: some View {
        TrainVoiceView()
    }
}
