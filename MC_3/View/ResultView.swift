//
//  ResultView.swift
//  MC_3
//
//  Created by Sayed Zulfikar on 22/07/23.
//

import SwiftUI



struct ResultView: View {
    @State private var AnswerNo : Bool = false
    
    var body: some View {
        ZStack{
            BubbleView()
            VStack(spacing : 20) {
                ZStack{
                    RoundedRectangle(cornerRadius: 12)
                        .frame(width: 170, height: 60)
                        .foregroundColor(Color("Second"))
                    Capsule()
                        .stroke(Color("Second"), lineWidth: 3)
                        .frame(width: 58, height: 14)
                        .overlay {
                            Capsule()
                                .foregroundColor(Color("Background"))
                            Text("Referee")
                                .foregroundColor(Color("Second"))
                                .font(.system(size: 9, weight: .bold))
                        }
                        .padding(.bottom, 55)
                    Text("Adhi")
                        .font(.system(size: 32, weight: .bold))
                }
                Image(AnswerNo ? "Noob" : "Anjayy")
                    .resizable()
                    .frame(width: 278, height: 278)
                Text(AnswerNo ? "Find a New \nFriend" : "Sayed’s Here \nSayed Hears")
                    .font(.system(size: 32, weight: .bold))
                    .foregroundColor(Color("Second"))
                    .multilineTextAlignment(.center)
                ZStack{
                    RoundedRectangle(cornerRadius: 12)
                        .frame(width: 290, height: 168)
                        .foregroundColor(Color("Second"))
                        .overlay {
                            Text(AnswerNo ? "Keren banget lo!Beneran perhatiin yak ternyata 😆" : "Hey, teman kamu mendengarkan dengan baik, ayo traktir dia kopi susu gula aren" )
                                .font(.system(size: 17, weight: .medium))
                                .multilineTextAlignment(.center)
                                .padding()
                        }
                    Capsule()
                        .stroke(Color("Second"), lineWidth: 3)
                        .frame(width: 120, height: 28)
                        .overlay {
                            Capsule()
                                .foregroundColor(Color("Background"))
                            Text("Anjay")
                                .foregroundColor(Color("Second"))
                                .font(.system(size: 12, weight: .bold))
                        }
                        .padding(.bottom, 160)
                    Circle()
                        .stroke(Color("Second"), lineWidth : 4)
                        .frame(width: 100)
                        .overlay{
                            Circle()
                                .foregroundColor(Color("Background"))
                            Text("1/3")
                                .font(.system(size: 16, weight: .semibold))
                                .foregroundColor(Color("Second"))
                            
                        }
                        .padding(.top, 170)
                    
                }
                
                
                Button {
                    print("Repeat Sound")
                    AnswerNo = true
                } label: {
                    ZStack{
                        RoundedRectangle(cornerRadius: 20)
                            .frame(width: 76, height: 30)
                            .foregroundColor(Color("Main"))
                        Image(systemName: "speaker.wave.3.fill")
                            .resizable()
                            .frame(width: 22, height: 16)
                            .foregroundColor(Color("Second"))
                        
                    }
                }
                
            }
            Spacer()
        }
    }
}

struct LooseView: View {
    var body: some View {
        VStack {
            Spacer()
            Image(systemName: "hand.thumbsdown.fill")
            Text("Lorem Ipsum Dolor")
            NavigationLink(
                destination: AskedView()
            )
            {
                Label("\u{200B}", systemImage: "arrow.right.to.line")
            }
            .buttonStyle(MultipeerButtonStyle())
            .onTapGesture {
                
            }
            Spacer()
        }
    }
}

struct ResultView_Previews: PreviewProvider {
    static var previews: some View {
        ResultView()
    }
}
