import SwiftUI

struct Try: View {
    @State private var dots = ""
    private let dotCount = 3
    private let dotDelay = 0.5 // Adjust the delay between dots
    
    var body: some View {
        HStack(spacing: 5) { // Adjust spacing as needed
            Text("Awdawd \(dots)")
//            Spacer() // Keep the dots centered in place
        }
        .onAppear {
            animateDots()
        }
    }
    
    func animateDots() {
        var count = 0
        dots = ""
        
        func addDot() {
            dots += "."
            count += 1
            if count <= dotCount {
                DispatchQueue.main.asyncAfter(deadline: .now() + dotDelay) {
                    addDot()
                }
            } else {
                DispatchQueue.main.asyncAfter(deadline: .now() + dotDelay) {
                    animateDots() // Start the animation again
                }
            }
        }
        
        addDot()
    }
}

struct Try_Previews: PreviewProvider {
    static var previews: some View {
        Try()
    }
}
