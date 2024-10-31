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
struct ColorFeature {
    
    @ObservableState
    struct State: Equatable {
        var colors: [Color] = [.red]
        
        mutating func addColor() {
            let colorCandidates: [Color] = [.red, .blue, .orange, .purple, .pink, .brown, .cyan]
            let newColor = colorCandidates.randomElement() ?? .blue
            
            colors.append(newColor)
        }
        
        mutating func decreaseCoffee() {
            colors.removeLast()
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
    
    let store: StoreOf<ColorFeature>
    
    let columns: [GridItem] = [
        GridItem(.flexible()),
        GridItem(.flexible()),
        GridItem(.flexible())
    ]
    
    var body: some View {
        ScrollView {
            LazyVGrid(columns: columns, spacing: 20) {
                ForEach(0..<store.colors.count, id: \.self) { index in
                    Circle()
                        .fill(store.colors[index])
                        .frame(width: 30, height: 30)
                }
            }
        }
    }
}

#Preview {
    CoffeeView(store: Store(initialState: ColorFeature.State()) {
        ColorFeature()
    })
}
