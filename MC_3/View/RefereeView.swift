//
//  QuestionView.swift
//  MC_3
//
//  Created by Irvan P. Saragi on 19/07/23.
//

import SwiftUI

struct QuestionView: View {
    @State var colors: [Color] = [.clear, .clear, Color("Second"), .red]
    @State private var currentQuestionIndex = 0
    
    
    let questions = [
        "Hey, Adhi! Siapa yang tadi ngomongin: 'tadi bukannya dia dapet Ravenclaw ya?'",
        "Ini pertanyaan ke-2.",
        "Ini pertanyaan ke-3."
    ]
    var body: some View {
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
                        Text("Player")
                            .foregroundColor(Color("Second"))
                            .font(.system(size: 9, weight: .bold))
                    }
                    .padding(.bottom, 55)
                Text("Adhi")
                    .font(.system(size: 32, weight: .bold))
            }
            Capsule()
                .stroke(Color("Second"), lineWidth : 2)
                .frame(width: 150, height: 32)
                .overlay{
                    HStack{
                        Image(systemName: "person.3.fill")
                            .padding(.trailing, 6)
                        Text("Vote")
                            .padding(.trailing, 27)
                        Text("4/6")
                    }
                    .font(.system(size: 12, weight: .medium))
                    .foregroundColor(Color("Second"))
                }
            Image("Ilustrasi1")
                .resizable()
                .frame(width: 278, height: 278)
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
                        Text("Qustion")
                            .foregroundColor(Color("Second"))
                            .font(.system(size: 12, weight: .bold))
                    }
                    .padding(.bottom, 160)
                
            }
            Button {
                currentQuestionIndex = (currentQuestionIndex + 1) % questions.count
                updateColor()
            } label: {
                ZStack{
                    RoundedRectangle(cornerRadius: 20)
                        .frame(width: 62, height: 30)
                        .foregroundColor(Color("Main"))
                    Image(systemName: "arrow.clockwise")
                        .resizable()
                        .frame(width: 13, height: 16)
                        .foregroundColor(Color("Second"))
                    
                }
            }
            Text("\(currentQuestionIndex + 1)/ \(questions.count)")
                .font(.system(size: 12, weight: .light))
                .foregroundColor(Color("Second"))
            HStack(spacing: 10) {
                ForEach(0..<questions.count) { index in
                    Capsule()
                        .stroke(Color("Second"), lineWidth : 3)
                        .frame(width: 60, height: 10)
                        .overlay {
                            Capsule()
                                .foregroundColor(colors[index])
                        }
                }
            }
        }
    }
    
    func updateColor (){
        var newColors: [Color] = []
        for index in 0..<questions.count {
            if index == currentQuestionIndex{
                newColors.append(Color("Second"))
            }
            else {
                newColors.append(.clear)
            }
        }
        colors = newColors
    }
}

struct QuestionView_Previews: PreviewProvider {
    static var previews: some View {
        QuestionView()
    }
}
