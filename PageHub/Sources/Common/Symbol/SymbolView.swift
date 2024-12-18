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
        var symbolStyles: IdentifiedArrayOf<SymbolStyle>
        
        mutating func removeLast() {
            guard !symbolStyles.isEmpty else { return }
            symbolStyles.removeLast()
        }
    }
    
    enum Action: Equatable {
        case onAppear(symbol: SymbolStyle)
    }
    
    var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case let .onAppear(symbol):
                state.symbolStyles[id: symbol.id]?.effectValue += 1
                return .none
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
                    Image(systemName: symbolStyle.symbol.rawValue)
                        .resizable()
                        .frame(width: 45, height: 45)
                        .foregroundStyle(symbolStyle.color)
                        .symbolEffect(.wiggle.clockwise, value: symbolStyle.effectValue)
                        .onAppear {
                            store.send(.onAppear(symbol: symbolStyle))
                        }
                }
            }
            .safeAreaPadding(.top, 30)
        }
    }
}

#Preview {
    SymbolView(store: Store(initialState: SymbolFeature.State(symbolStyles: [])) {
        SymbolFeature()
    })
}
