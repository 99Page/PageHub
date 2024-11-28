//
//  SheetToolbarFeature.swift
//  PageHub
//
//  Created by 노우영 on 11/28/24.
//  Copyright © 2024 Page. All rights reserved.
//

import ComposableArchitecture

@Reducer
struct SheetToolbarFeature {
    @ObservableState
    struct State: Equatable {
        @Presents var symbol: SymbolFeature.State?
        
        var featureToolbar = FeatureToolbarReducer.State(featureName: "sheetToolbar")
        
        var toolbarConfig = ToolbarConfig(
            presentationDedents: [.medium, .fraction(0.9)],
            selection: .medium,
            backgroundInteraction: .enabled,
            alignment: .trailing,
            toolbarHiddenPresentationDedents: [.fraction(0.9)]
        )
    }
    
    enum Action: BindableAction, Equatable {
        case symbol(PresentationAction<SymbolFeature.Action>)
        case featureToolbar(FeatureToolbarReducer.Action)
        case showSheetButtonTapped
        case binding(BindingAction<State>)
        case plusToolbarTapped
        case minusToolbarTapped
    }
    
    @Dependency(\.symbolGenerator) var symbolGeneator
    @Dependency(\.uuid) var uuid
    
    var body: some ReducerOf<Self> {
        BindingReducer()
        
        Scope(state: \.featureToolbar, action: \.featureToolbar) {
            FeatureToolbarReducer()
        }
        
        Reduce { state, action in
            switch action {
            case .symbol(_):
                return .none
            case .showSheetButtonTapped:
                state.symbol = SymbolFeature.State()
                return .none
            case .binding(_):
                return .none
            case .plusToolbarTapped:
                if state.symbol == nil {
                    state.symbol = SymbolFeature.State()
                }
                
                let newSymbol = symbolGeneator.createSymbol(uuid())
                state.symbol?.symbolStyles.append(newSymbol)
                
                return .none
            case .minusToolbarTapped:
                if state.symbol == nil {
                    state.symbol = SymbolFeature.State()
                }
                
                state.symbol?.removeLast()
                return .none
            case .featureToolbar(_):
                return .none
            }
        }
        .ifLet(\.$symbol, action: \.symbol) {
            SymbolFeature()
        }
    }
}
