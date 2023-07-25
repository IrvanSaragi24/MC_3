//
//  ResultView.swift
//  MC_3
//
//  Created by Sayed Zulfikar on 22/07/23.
//

import SwiftUI

struct ResultView: View {
    var isWin: Bool
    var body: some View {
        if isWin {
            WinView()
        }
        else {
            LooseView()
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
