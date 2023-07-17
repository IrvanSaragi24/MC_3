import SwiftUI

struct test: View {
    @State private var isZoomedOut = false

    var body: some View {
        VStack {
            Button("Zoom Out") {
                withAnimation(.easeInOut(duration: 0.5)) {
                    isZoomedOut.toggle()
                }
            }
            .padding()

            Circle()
                .foregroundColor(.blue)
                .frame(width: isZoomedOut ? 200 : 100, height: isZoomedOut ? 200 : 100)
                .animation(.easeInOut(duration: 0.5))
        }
    }
}

struct test_Previews: PreviewProvider {
    static var previews: some View {
        test()
    }
}








