import SwiftUI
import ComposableArchitecture

struct MainReducer: Reducer {
    struct State: Equatable {
//        var signup: SignupReducer.State = .init()
    }
    
    enum Action: Equatable {
//        case signup(SignupReducer.Action)
    }
    
    var body: some ReducerOf<Self> {
        //        Scope(state: \.signup, action: /Action.signup) {
        //            SignupReducer()
        //        }
        Reduce { state, action in
            return .none
        }
    }
}

public struct ContentView: View {
    let store: StoreOf<MainReducer>
    public var body: some View {
        WithViewStore(self.store, observe: { $0 }) { viewStore in
            VStack {
                LoginView()
                //                SignupView(store: self.store.scope(state: \.signup, action: MainReducer.Action.signup))
            }
        }
        
    }
}

//struct ContentView_Previews: PreviewProvider {
//    static var previews: some View {
//        ContentView()
//    }
//}
