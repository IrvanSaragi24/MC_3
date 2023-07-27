import SwiftUI

struct Try: View {
    @State private var dots = ""
    private let dotCount = 3
    private let dotDelay = 0.5 // Adjust the delay between dots
    
    var body: some View {
        Text("Hello WorlT")

            .font(.system(size: 50, design: .rounded))
            .fontWeight(.bold)

    }
}

struct Try_Previews: PreviewProvider {
    static var previews: some View {
        Try()
    }
}
