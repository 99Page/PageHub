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
        @Presents var coffee: ColorFeature.State?
        
        var toolbarConfig = ToolbarConfig(
            presentationDedents: [.medium, .fraction(0.9)],
            selection: .medium,
            backgroundInteraction: .enabled
        )
    }
    
    enum Action: BindableAction {
        case coffee(PresentationAction<ColorFeature.Action>)
        case showSheetButtonTapped
        case binding(BindingAction<State>)
        case plusToolbarTapped
        case minusToolbarTapped
        
    }
    
    var body: some ReducerOf<Self> {
        BindingReducer()
        
        Reduce { state, action in
            switch action {
            case .coffee(_):
                return .none
            case .showSheetButtonTapped:
                state.coffee = ColorFeature.State()
                return .none
            case .binding(_):
                return .none
            case .plusToolbarTapped:
                if state.coffee == nil {
                    state.coffee = ColorFeature.State()
                }
                
                state.coffee?.addColor()
                return .none
            case .minusToolbarTapped:
                if state.coffee == nil {
                    state.coffee = ColorFeature.State()
                }
                
                state.coffee?.decreaseCoffee()
                return .none
            }
        }
        .ifLet(\.$coffee, action: \.coffee) {
            ColorFeature()
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
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .sheet(config: $store.toolbarConfig, item: $store.scope(state: \.coffee, action: \.coffee)) { coffeeStore in
            CoffeeView(store: coffeeStore.wrappedValue)
        } toolbar: {
            SheetToolbarGroup(alignment: .trailing) {
                HStack(spacing: 10) {
                    Button {
                        store.send(.plusToolbarTapped)
                    } label: {
                        Image(systemName: "plus.circle")
                            .resizable()
                            .frame(width: 30, height: 30)
                    }
                    
                    Button {
                        store.send(.minusToolbarTapped)
                    } label: {
                        Image(systemName: "minus.circle")
                            .resizable()
                            .frame(width: 30, height: 30)
                    }
                }
                .padding(.trailing, 10)
                .padding(.bottom, 10)
            }
        }
    }
}

#Preview {
    SheetToolbarView(store: Store(initialState: SheetToolbarFeature.State()) {
        SheetToolbarFeature()
            ._printChanges()
    })
}
