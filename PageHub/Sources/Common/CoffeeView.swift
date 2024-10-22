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
    
    @ObservableState
    struct State: Equatable {
        var coffeeCount = 4
        
        mutating func decreaseCoffee() {
            coffeeCount = max(coffeeCount - 1, 0)
        }
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
        ScrollView {
            VStack {
                ForEach(0..<store.coffeeCount, id: \.self) { _ in
                    Image(systemName: "cup.and.saucer.fill")
                        .foregroundStyle(.brown)
                }
            }
        }
    }
}

#Preview {
    CoffeeView(store: Store(initialState: CoffeeFeature.State()) {
        CoffeeFeature()
    })
}
