//
//  AskedView.swift
//  MC_3
//
//  Created by Sayed Zulfikar on 19/07/23.
// Ini orang yang ditanya

import SwiftUI

struct AskedView: View {
    var body: some View {
        NavigationView {
            VStack {
                Spacer()
                Text("Player")
                Text("ADHI")
                Image(systemName: "person.circle.fill")
                Text("Waiting for Judges to Vote")
                Spacer()
                Text("Question")
                Text("Lorem Ipsum Dolor")
                Text("1/3")
                NavigationLink(
                    destination: AskedView()
                )
                {
                    Label("\u{200B}", systemImage: "gobackward")
                }
                .buttonStyle(MultipeerButtonStyle())
                .onTapGesture {
                    
                }
            }
        }
    }
}

struct AskedView_Previews: PreviewProvider {
    static var previews: some View {
        AskedView()
    }
}
