//
//  SwiftUIView.swift
//  MC_3
//
//  Created by Irvan P. Saragi on 17/07/23.
//

import SwiftUI

struct LobyView: View {
    @State private var ButtonListening = false
    var body: some View {
        ZStack{
            if ButtonListening {
                TimerView()
            } else{
                Color("Background")
                    .ignoresSafeArea()
                Image("CircleHost")
                    .padding(.top, 138)
                VStack(spacing : 40){
                    Text("Lobby")
                        .font(.system(size: 75, weight: .bold))
                        .foregroundColor(Color("Second"))
                    HStack(spacing : 40){
                        ZStack{
                            RoundedRectangle(cornerRadius: 10)
                            HStack{
                                Text("Silent Period")
                                Spacer()
                                Text("5s")
                            }
                            .padding(.leading)
                            .padding(.trailing)
                            .foregroundColor(Color("Background"))
                            .font(.system(size: 15, weight: .light))
                            
                        }
                        .frame(width: 150, height: 40)
                        
                        ZStack{
                            RoundedRectangle(cornerRadius: 10)
                            HStack{
                                Text("Questions")
                                Spacer()
                                Text("3")
                            }
                            .padding(.leading)
                            .padding(.trailing)
                            .foregroundColor(Color("Background"))
                            .font(.system(size: 15, weight: .light))
                            
                        }
                        .frame(width: 150, height: 40)
                    }
                    .foregroundColor(.white)
                    List(0 ..< 5) { item in
                        ZStack{
                            RoundedRectangle(cornerRadius: 20)
                                .frame(width: 315, height: 100)
                                .foregroundColor(Color("Second"))
                            HStack(spacing : 30){
                                ZStack{
                                    Circle()
                                        .stroke(Color("Main"), lineWidth : 4)
                                        .frame(width: 22)
                                    Circle()
                                        .frame(width: 17)
                                        .foregroundColor(Color.green)
                                }
                                Capsule()
                                    .frame(width: 2, height: 50)
                                    .foregroundColor(.gray)
                                
                                Text("Adhi")
                                    .font(.system(size: 24))
                                    .fontWeight(.semibold)
                                    .foregroundColor(Color("Background"))
                                Spacer()
                                Image(systemName: "crown.fill")
                                    .resizable()
                                    .frame(width: 30, height: 30)
                                    .foregroundColor(Color("Main"))
                                
                                
                            }
                            .padding(20)
                        }.listRowBackground(Color.clear)
                    }
                    .scrollContentBackground(.hidden)
                    
                    Button {
                        ButtonListening = true
                    } label: {
                        ZStack{
                            RoundedRectangle(cornerRadius: 20)
                            
                                .frame(width: 358, height: 48)
                                .foregroundColor(Color("Main"))
                                .overlay(
                                    RoundedRectangle(cornerRadius: 20)
                                        .stroke(Color("Second"), lineWidth: 4)
                                )
                            
                            Text("Start!")
                                .font(.system(size: 28, weight: .heavy))
                                .foregroundColor(Color("Second"))
                        }
                        .padding(.bottom, 43)
                    }
                }
                .padding(.top, 20)

            }
        }
    }
}

struct LobyView_Previews: PreviewProvider {
    static var previews: some View {
        LobyView()
    }
}


