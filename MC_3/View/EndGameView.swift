//
//  TrainVoiceView.swift
//  MC_3
//
//  Created by Irvan P. Saragi on 16/07/23.
//

import SwiftUI

struct EndGameView: View {
    var body: some View {
        ZStack {
            BubbleView()
            VStack(spacing : 16){
                Text("CONTINUE\nHANGOUT?")
                    .font(.system(size: 40, design: .rounded))
                    .fontWeight(.bold)
                    .foregroundColor(Color("Second"))
                    .multilineTextAlignment(.center)
                    .padding(.bottom, 100)
                
                Button {
                    print("Continue Listening")
                } label: {
                    Text("Continue")
                        .font(.system(size: 28, design: .rounded))
                        .fontWeight(.bold)
                }
                .buttonStyle(MultipeerButtonStyle())
               
                Button {
                    print("Back to Hangout Mode")
                } label: {
                    RoundedRectangle(cornerRadius: 40)
                        .stroke(Color("Main"), lineWidth : 2)
                        .frame(width: 314, height: 48)
                        .overlay {
                            Text("Stop")
                                .font(.system(size: 28, design: .rounded))
                                .fontWeight(.bold)
                                .foregroundColor(Color("Second"))
                        }
                    
                }
               
            
                
            }
        }
    }
}



struct EndGameView_Previews: PreviewProvider {
    static var previews: some View {
        EndGameView()
    }
}
