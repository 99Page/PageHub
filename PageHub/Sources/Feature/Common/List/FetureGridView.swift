//
//  FetureGridView.swift
//  PageHub
//
//  Created by 노우영 on 11/26/24.
//  Copyright © 2024 Page. All rights reserved.
//

import ComposableArchitecture
import SwiftUI

@Reducer
struct FeatureGridFeature {
    struct State: Equatable {
        
    }
    
    enum Action: Equatable {
        
    }
    
    var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
                
            }
        }
    }
}

struct FetureGridView: View {
    
    let store: StoreOf<FeatureGridFeature>
    
    var body: some View {
        List {
            NavigationLink(state: ContentFeature.Path.State.sheetToolbar(SheetToolbarReducer.State())) {
                Text("SheetToolbar")
            }
        }
        .navigationTitle("Features")
    }
}

#Preview {
    FetureGridView(store: Store(initialState: FeatureGridFeature.State()) {
        FeatureGridFeature()
    })
}