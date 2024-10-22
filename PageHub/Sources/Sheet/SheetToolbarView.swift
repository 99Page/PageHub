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
        @Presents var coffee: CoffeeFeature.State?
        var presentationSelection: PresentationDetent = .medium
        var coffeeViewSize: CGSize = .zero
        let presentationCandidates: Set<PresentationDetent> = [.fraction(0.1), .medium, .fraction(0.8)]
        
        /// 포켓몬 리스트 뷰가 나타날 때 버튼의 오프셋
        var bottomButtonOffset: CGFloat {
            let buttonToSheetBottomOffset: CGFloat = 10
            guard isCoffeeSheetPresented else { return 0 }
            
            return -coffeeViewSize.height - buttonToSheetBottomOffset
            
        }
        
        var isCoffeeSheetPresented: Bool {
            coffee != nil
        }
    }
    
    enum Action: BindableAction {
        case coffee(PresentationAction<CoffeeFeature.Action>)
        case showSheetButtonTapped
        case binding(BindingAction<State>)
        case coffeeViewSizeCaculated(CGSize)
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
                state.coffee = CoffeeFeature.State()
                return .none
            case .binding(_):
                return .none
            case let .coffeeViewSizeCaculated(size):
                state.coffeeViewSize = size
                return .none
            case .plusToolbarTapped:
                state.coffee?.coffeeCount += 1
                return .none
            case .minusToolbarTapped:
                state.coffee?.decreaseCoffee()
                return .none
            }
        }
        .ifLet(\.$coffee, action: \.coffee) {
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
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .sheet(item: $store.scope(state: \.coffee, action: \.coffee)) { coffeeStore in
            CoffeeView(store: coffeeStore)
                .presentationDetents(store.presentationCandidates, selection: $store.presentationSelection)
                .trackSize { size in
                    store.send(.coffeeViewSizeCaculated(size))
                }
                .presentationBackgroundInteraction(.enabled)
        }
        .overlay(alignment: .bottomTrailing) {
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
            .offset(y: store.bottomButtonOffset)
            .padding(.trailing, 10)
        }
    }
}

#Preview {
    SheetToolbarView(store: Store(initialState: SheetToolbarFeature.State()) {
        SheetToolbarFeature()
            ._printChanges()
    })
}
