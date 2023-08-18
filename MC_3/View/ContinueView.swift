//
//  ContinueView.swift
//  MC_3
//
//  Created by Sayed Zulfikar on 22/07/23.
//

import SwiftUI

struct ContinueView: View {
    var body: some View {
        VStack {
            Text("Continue Hangout?")
            Button(action: {
                // Action for the first button
                print("First Button Tapped")
            }) {
                Text("Continue")
                    .foregroundColor(.white)
                    .padding()
                    .background(Color.blue)
                    .cornerRadius(8)
            }
            Button(action: {
                // Action for the second button
                print("Second Button Tapped")
            }) {
                Text("Stop")
                    .foregroundColor(.white)
                    .padding()
                    .background(Color.red)
                    .cornerRadius(8)
            }
        }
    }
}

struct ContinueView_Previews: PreviewProvider {
    static var previews: some View {
        ContinueView()
    }
}
