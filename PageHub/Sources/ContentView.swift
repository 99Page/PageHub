import ComposableArchitecture
import SwiftUI

@Reducer
struct ContentFeature {
    
    @ObservableState
    struct State: Equatable {
        var path = StackState<Path.State>()
        var featureGrid = FeatureGridFeature.State()
    }
    
    enum Action: Equatable {
        case path(StackAction<Path.State, Path.Action>)
        case featureGrid(FeatureGridFeature.Action)
    }
    
    @Reducer
    struct Path {
        @ObservableState
        enum State: Equatable {
            case sheetToolbar(SheetToolbarFeature.State)
        }
        
        enum Action: Equatable {
            case sheetToolbar(SheetToolbarFeature.Action)
        }
        
        var body: some ReducerOf<Self> {
            Scope(state: \.sheetToolbar, action: \.sheetToolbar) {
                SheetToolbarFeature()
            }
        }
    }
    
    var body: some ReducerOf<Self> {
        Scope(state: \.featureGrid, action: \.featureGrid) {
            FeatureGridFeature()
        }
        
        Reduce { state, action in
            switch action {
            case .path(_):
                return .none
            }
        }
        .forEach(\.path, action: \.path) {
            Path()
        }
    }
}

struct ContentView: View {
    @Bindable var store: StoreOf<ContentFeature>
    
    var body: some View {
        NavigationStack(path: $store.scope(state: \.path, action: \.path)) {
            FetureGridView(store: store.scope(state: \.featureGrid, action: \.featureGrid))
        } destination: { store in
            switch store.state {
            case .sheetToolbar:
                if let store = store.scope(state: \.sheetToolbar, action: \.sheetToolbar) {
                    SheetToolbarView(store: store)
                }
            }
        }
    }
}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView(store: Store(initialState: ContentFeature.State(), reducer: {
            ContentFeature()
        }))
    }
}
