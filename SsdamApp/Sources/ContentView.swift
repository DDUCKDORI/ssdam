import SwiftUI

public struct ContentView: View {
    public init() {}

    public var body: some View {
        VStack {
            Text("Hello, World!")
                .font(.custom("Pretendard-Regular", size: 50))
                .padding()
            Text("Hello, World!")
                .font(.custom("Pretendard-Medium", size: 50))
                .padding()
            Text("Hello, World!")
                .font(.custom("Pretendard-SemiBold", size: 50))
                .foregroundStyle(Colors.gray10)
                .padding()
        }
        .onAppear {
            for family in UIFont.familyNames {
                let sName: String = family as String
                print("family: \(sName)")

                for name in UIFont.fontNames(forFamilyName: sName) {
                    print("name: \(name as String)")
                }
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
