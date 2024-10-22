import ComposableArchitecture
import SwiftUI

struct ContentView: View {
    var body: some View {
        SheetToolbarView(store: Store(initialState: SheetToolbarFeature.State()) {
            SheetToolbarFeature()
        })
    }
}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
