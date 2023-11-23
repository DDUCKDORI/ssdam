import SwiftUI

public struct ContentView: View {
    @State var page: Int = 0
    public var body: some View {
        VStack {
            LoginView()
//            PageViewController(pages: [AnyView(UserTypeView(page: $page)), AnyView(NicknameView())], currentPage: $page)
        }
        
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
