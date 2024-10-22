//
//  SheetToolbarView.swift
//  PageHub
//
//  Created by 노우영 on 10/22/24.
//  Copyright © 2024 Page. All rights reserved.
//

import ComposableArchitecture
import SwiftUI

@Reducer
struct SheetToolbarFeature {
    
    @ObservableState
    struct State: Equatable {
        @Presents var desination: CoffeeFeature.State?
        var presentationSelection: PresentationDetent = .medium
        
    }
    
    enum Action: BindableAction {
        case child(PresentationAction<CoffeeFeature.Action>)
        case showSheetButtonTapped
        case binding(BindingAction<State>)
        
    }
    
    var body: some ReducerOf<Self> {
        BindingReducer()
        
        Reduce { state, action in
            switch action {
            case .child(_):
                return .none
            case .showSheetButtonTapped:
                state.desination = CoffeeFeature.State()
                return .none
            case .binding(_):
                return .none
            }
        }
        .ifLet(\.$desination, action: \.child) {
            CoffeeFeature()
        }
    }
}

struct SheetToolbarView: View {
    
    @Bindable var store: StoreOf<SheetToolbarFeature>
    
    var body: some View {
            VStack {
                Button {
                    store.send(.showSheetButtonTapped)
                } label: {
                    Text("Show sheet")
                }

            }
            .sheet(item: $store.scope(state: \.desination, action: \.child)) { store in
                CoffeeView(store: store)
                    .presentationDetents([.medium, .large], selection: $store.presentationSelection)
            }
    }
}

#Preview {
    SheetToolbarView(store: Store(initialState: SheetToolbarFeature.State(), reducer: {
        SheetToolbarFeature()
    }))
}
