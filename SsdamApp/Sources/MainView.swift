import SwiftUI
import ComposableArchitecture

struct MainReducer: Reducer {
    struct State: Equatable {
    }
    
    enum Action: Equatable {
    }
    
    var body: some ReducerOf<Self> {
        Reduce { state, action in
            return .none
        }
    }
}

public struct MainView: View {
    @EnvironmentObject var screenRouter: ScreenRouter
    let store: StoreOf<MainReducer>
    public var body: some View {
        WithViewStore(self.store, observe: { $0 }) { viewStore in
            screenRouter.start()
        }
        
    }
}

//struct ContentView_Previews: PreviewProvider {
//    static var previews: some View {
//        ContentView()
//    }
//}
