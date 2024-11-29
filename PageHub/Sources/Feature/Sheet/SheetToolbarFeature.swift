//
//  SheetToolbarFeature.swift
//  PageHub
//
//  Created by 노우영 on 11/28/24.
//  Copyright © 2024 Page. All rights reserved.
//

import ComposableArchitecture
import FirebaseFirestore

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
        case onAppear
        case setVersion(versions: [String])
    }
    
    @Dependency(\.symbolGenerator) var symbolGeneator
    @Dependency(\.uuid) var uuid
    @Dependency(\.featureCollectionService) var featureCollectionService
    
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
            case .onAppear:
                return .run { send in
                    let versions = try await featureCollectionService.fetchCollection(.sheetToolbar)
                    await send(.setVersion(versions: versions))
                }
            case let .setVersion(versions):
                state.featureToolbar.codeVersions = Set(versions)
                return .none
            }
        }
        .ifLet(\.$symbol, action: \.symbol) {
            SymbolFeature()
        }
    }
}
