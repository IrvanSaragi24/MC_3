//
//  Gifimage.swift
//  MC_3
//
//  Created by Irvan P. Saragi on 27/07/23.
//

import SwiftUI
import WebKit

struct GifImage: UIViewRepresentable {
    private let name: String

    init(_ name: String) {
        self.name = name

    }

    func makeUIView(context: Context) -> WKWebView {
        let webView = WKWebView()
        webView.isOpaque = false
        webView.backgroundColor = UIColor.clear
        let url = Bundle.main.url(forResource: name, withExtension: "gif")!
        let data = try! Data(contentsOf: url)
        webView.load(
            data,
            mimeType: "image/gif",
            characterEncodingName: "UTF-8",
            baseURL: url.deletingLastPathComponent()
            
        )
        return webView
    }

    func updateUIView(_ uiView: WKWebView, context: Context) {
        // No need to reload the view for a smooth loop animation
    }
}

struct GifImage_Previews: PreviewProvider {
    static var previews: some View {
        GifImage("LOL3")
//            .background(.red)
            .frame(width: 100, height: 100)
    }
}

