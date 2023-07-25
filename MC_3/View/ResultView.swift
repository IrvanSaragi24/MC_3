//
//  QuestionView.swift
//  MC_3
//
//  Created by Irvan P. Saragi on 19/07/23.
//

import SwiftUI

struct ResultView: View {
    @State var colors: [Color] = [.clear, .clear, Color("Second"), .red]
    @State private var currentQuestionIndex = 0
    
    
    let questions = [
        "Hey, teman kamu mendengarkan dengan baik, ayo traktir dia kopi susu gula aren",
        "Ini pertanyaan ke-2.",
        "Ini pertanyaan ke-3."
    ]
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
                Image("Anjayy")
                    .resizable()
                    .frame(width: 278, height: 278)
                Text("Sayed’s Here \nSayed Hears")
                    .font(.system(size: 32, weight: .bold))
                    .foregroundColor(Color("Second"))
                    .multilineTextAlignment(.center)
                ZStack{
                    RoundedRectangle(cornerRadius: 12)
                        .frame(width: 290, height: 168)
                        .foregroundColor(Color("Second"))
                        .overlay {
                            Text(questions[currentQuestionIndex])
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
                            Text("\(currentQuestionIndex + 1)/ \(questions.count)")
                                .font(.system(size: 16, weight: .semibold))
                                .foregroundColor(Color("Second"))
                            
                        }
                        .padding(.top, 170)
                    
                }
                
                
                Button {
                    print("Repeat Sound")
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
}

struct WinView: View {
    var body: some View {
        VStack {
            Spacer()
            Image(systemName: "hand.thumbsup.fill")
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

    static let isWin = false
    static var previews: some View {
        ResultView(isWin: isWin)
    }
}
