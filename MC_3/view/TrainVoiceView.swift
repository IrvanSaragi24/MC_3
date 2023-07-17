//
//  TrainVoiceView.swift
//  MC_3
//
//  Created by Irvan P. Saragi on 16/07/23.
//

import SwiftUI

struct TrainVoiceView: View {
    var name: String
    var title : [String]
    let capsuleColors: [Color] = [Color("Second"), Color("Main"), Color("Main"), Color("Main")]
    
    var body: some View {
        ZStack{
            Color("Background")
                .ignoresSafeArea()
            VStack(spacing : 40){
                Text("welcome,")
                    .font(.system(.largeTitle, design: .rounded, weight: .semibold))
                ZStack{
                    Capsule()
                        .frame(width: 250, height: 70)
                    Text(name)
                        .foregroundColor(Color("Background"))
                        .font(.system(size: 48))
                        .fontWeight(.semibold)
                }
                Image(systemName: "mic.fill")
                    .resizable()
                    .frame(width: 80, height: 130)
                Text("Say the following word to \nsample your voice:")
                    .font(.system(size: 16))
                
                ForEach(title, id: \.self) { word in
                    Text(word)
                        .font(.system(size: 36))
                        .fontWeight(.bold)
                        .textCase(.uppercase)
                }
                Image(systemName: "checkmark.circle.fill")
                    .resizable()
                    .frame(width: 24, height: 24)
                    .foregroundColor(.green)
                Text("1 / 4")
                HStack{
                    ForEach(0..<4) { index in
                        Capsule()
                            .foregroundColor(capsuleColors[index])
                            .frame(width: 59, height: 10)

                    }
                        
                }
                
            }//vstack
            .foregroundColor(Color("ColorText"))
            .multilineTextAlignment(.center)
        }//zstack
    }
}

struct TrainVoiceView_Previews: PreviewProvider {
    static var previews: some View {
        TrainVoiceView(name: "irvan", title: ["Aku berjanji tidak phubbing"])
    }
}
