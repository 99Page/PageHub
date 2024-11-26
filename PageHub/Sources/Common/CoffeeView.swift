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
struct SymbolFeature {
    
    @ObservableState
    struct State: Equatable {
        var symbolStyles: [SymbolStyle] = []
        
        mutating func addSymbol() {
            symbolStyles.append(.randomStyle)
        }
        
        mutating func removeLast() {
            guard !symbolStyles.isEmpty else { return }
            symbolStyles.removeLast()
        }
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

struct SymbolView: View {
    
    let store: StoreOf<SymbolFeature>
    
    let columns: [GridItem] = [
        GridItem(.flexible()),
        GridItem(.flexible()),
        GridItem(.flexible())
    ]
    
    var body: some View {
        ScrollView {
            LazyVGrid(columns: columns, spacing: 20) {
                ForEach(store.symbolStyles) { symbolStyle in
                    AnimatedView(effect: symbolStyle.animationEffect) {
                        Image(systemName: symbolStyle.symbol.rawValue)
                            .resizable()
                            .frame(width: 45, height: 45)
                            .foregroundStyle(symbolStyle.color)
                    }
                }
            }
            .safeAreaPadding(.top, 30)
        }
    }
}

#Preview {
    SymbolView(store: Store(initialState: SymbolFeature.State()) {
        SymbolFeature()
    })
}
