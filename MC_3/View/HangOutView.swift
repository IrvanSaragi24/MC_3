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
                    .animation(.easeOut(duration: 0.5), value: vibrateOnRing)
                    .opacity(vibrateOnRing ? 0 : 1)
                    
                    VStack{
                        Text(vibrateOnRing ? "HangOut Mode" : "HangOut\nMode")
                            .multilineTextAlignment(.center)
                            .foregroundColor(Color("Second"))
                            .font(.system(size: vibrateOnRing ? 30 : 50))
                            .fontWeight(.bold)
                            .offset(x: vibrateOnRing ? -70 : 0, y: vibrateOnRing ? -300 : 0)
                            .animation(.linear, value: vibrateOnRing)
                        ZStack{
                            RoundedRectangle(cornerRadius: 50)
                                .stroke(Color("Main"), lineWidth: 8)
                                .frame(width: vibrateOnRing ? 80 : 160, height: vibrateOnRing ? 45 : 80)
                                .foregroundColor(Color("Second"))
                            
                            Button {
                                vibrateOnRing.toggle()
                                showRoles.toggle()
                            } label: {
                                ZStack{
                                    
                                    Circle()
                                    //                                        .frame(width: 50, height: 50)
                                        .frame(width: vibrateOnRing ? 30 : 50, height: vibrateOnRing ? 30 : 50)
                                    Circle()
                                    //                                        .frame(width: 30, height: 30)
                                        .frame(width: vibrateOnRing ? 20 : 30, height: vibrateOnRing ? 20 : 30)
                                        .foregroundColor(vibrateOnRing ? .green : .pink)
                                    
                                }
                            }// Label Button
                            .cornerRadius(20)
                            .frame(width: vibrateOnRing ? 65 : 140, height: vibrateOnRing ? 60 : 80, alignment: vibrateOnRing ? .trailing : .leading)
                            
                            
                        } // ZStack button
                        .offset(x: vibrateOnRing ? 120 : 0, y: vibrateOnRing ? -365 : 0)
                        
                       
                        
                    } // VStack
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    if showRoles {
                        Roles()
                    }
                }// ZStack
                .animation(.spring(), value: vibrateOnRing)
            }
        }
    }
}

struct HangOutView_Previews: PreviewProvider {
    static var previews: some View {
        HangOutView()
    }
}

struct Roles : View {
    var body: some View{
        VStack(spacing : 60){
            Button {
                print("nextViewHost")
            } label: {
                ZStack{
                    Circle()
                        .stroke(Color.white, lineWidth: 6)
                        .shadow(color: .white, radius: 5)
                    Circle()
                    VStack{
                        Image(systemName: "crown.fill")
                            .resizable()
                            .frame(width: 25, height: 25)
                        Image(systemName: "person.fill")
                            .resizable()
                            .frame(width: 55, height: 55)
                        Text("HOST")
                            .font(.title)
                            .fontWeight(.bold)
                            
                    }
                    .foregroundColor(Color("User"))
                }
                .frame(width: 230)
                
            }// Button Host
            
            Button {
                print("nextViewGuest")
            } label: {
                ZStack{
                    Circle()
                        .stroke(Color.white, lineWidth: 6)
                        .shadow(color: .white, radius: 5)
                    Circle()
                    
                    VStack{
                        Image(systemName: "person.fill")
                            .resizable()
                            .frame(width: 55, height: 55)
                        Text("GUEST")
                            .font(.title)
                            .fontWeight(.bold)
                            
                    }
                    
                    .foregroundColor(Color("User"))
                }
                .frame(width: 230)
               
            }//Button Guest

        }
        .foregroundColor(Color("ColorText"))
    }
}
