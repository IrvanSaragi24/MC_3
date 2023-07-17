//
//  HangOutView.swift
//  MC_3
//
//  Created by Irvan P. Saragi on 17/07/23.
//

import SwiftUI

struct HangOutView: View {
    @State private var vibrateOnRing = false
    @State private var vibrateOnRing2 = false
    var body: some View {
        ZStack{
            Color(vibrateOnRing ? "Background" : "Second")
                .ignoresSafeArea()
            VStack{
                
                ZStack{
                    ZStack{
                        Circle()
                            .foregroundColor(Color("Main"))
                            .frame(width: vibrateOnRing ? 800 : 600)
                            .ignoresSafeArea()
                        Circle()
                            .foregroundColor(Color("Background"))
                            .frame(width: vibrateOnRing ? 800 : 500)
                            .ignoresSafeArea()
                            
                    }
                    
                    .animation(.easeOut(duration: 0.2))
                    .opacity(vibrateOnRing ? 0 : 1)
                    
                    VStack{
                        Text(vibrateOnRing ? "HangOut Mode" : "HangOut\nMode")
                            .multilineTextAlignment(.center)
                            .foregroundColor(Color("Second"))
                            .font(.system(size: vibrateOnRing ? 36 : 50))
                            .fontWeight(.bold)
                            .offset(x: vibrateOnRing ? -50 : 0, y: vibrateOnRing ? -300 : 0)
                            .animation(.linear)
                        ZStack{
                            RoundedRectangle(cornerRadius: 50)
                                .stroke(Color("Main"), lineWidth: 8)
                                .frame(width: 160, height: 80)
                                .foregroundColor(Color("Second"))
                            
                            Button {
                                vibrateOnRing.toggle()
                            } label: {
                                ZStack{
                                    
                                    Circle()
                                        .frame(width: 50, height: 50)
                                    Circle()
                                        .frame(width: 30, height: 30)
                                        .foregroundColor(vibrateOnRing ? .green : .pink)
                                    
                                }
                            }
                            .cornerRadius(20)
                            .frame(width: 140, height: 80, alignment: vibrateOnRing ? .trailing :.leading)
                            
                            
                        }
                        .offset(x: vibrateOnRing ? 150 : 0, y: vibrateOnRing ? -380 : 0)
                        
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
//                    .background()
                }
                .animation(.spring())
            }
        }
    }
}

struct HangOutView_Previews: PreviewProvider {
    static var previews: some View {
        HangOutView()
    }
}

