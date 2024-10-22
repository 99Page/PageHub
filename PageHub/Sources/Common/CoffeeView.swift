//
//  CoffeeView.swift
//  PageHub
//
//  Created by 노우영 on 10/22/24.
//  Copyright © 2024 Page. All rights reserved.
//

import ComposableArchitecture
import SwiftUI

@Reducer
struct CoffeeFeature {
    struct State: Equatable {
        
    }
    
    enum Action {
        
    }
    
    var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
                
            }
        }
    }
}

struct CoffeeView: View {
    
    let store: StoreOf<CoffeeFeature>
    
    var body: some View {
        WithViewStore(store, observe: { $0 }) { viewStore in
            VStack {
                Text("coffee view")
            }
        }
    }
}

#Preview {
    CoffeeView(store: Store(initialState: CoffeeFeature.State()) {
        CoffeeFeature()
    })
}
