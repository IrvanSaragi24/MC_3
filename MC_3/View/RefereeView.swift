//
//  RefereeView.swift
//  MC_3
//
//  Created by Sayed Zulfikar on 22/07/23.
//

import SwiftUI

struct RefereeView: View {
    var body: some View {
        VStack {
            Spacer()
            Text("Referee")
            Text("JAVA")
            Image(systemName: "person.circle.fill")
            Spacer()
            Text("Judge the player")
            HStack {
                Button(action: {
                    // Action for the first button
                    print("First Button Tapped")
                }) {
                    Text("YES")
                        .foregroundColor(.white)
                        .padding()
                        .background(Color.blue)
                        .cornerRadius(8)
                }
                
                Button(action: {
                    // Action for the second button
                    print("Second Button Tapped")
                }) {
                    Text("NO")
                        .foregroundColor(.white)
                        .padding()
                        .background(Color.red)
                        .cornerRadius(8)
                }
            }
            .padding(.bottom)
            Spacer()
        }
    }
}

struct RefereeView_Previews: PreviewProvider {
    static var previews: some View {
        RefereeView()
    }
}
