//
//  SheetToolbarView.swift
//  PageHub
//
//  Created by 노우영 on 10/22/24.
//  Copyright © 2024 Page. All rights reserved.
//

import ComposableArchitecture
import SwiftUI

struct SheetToolbarView: View {
    
    @Bindable var store: StoreOf<SheetToolbarReducer>
    
    var body: some View {
        VStack {
            Button {
                store.send(.showSheetButtonTapped)
            } label: {
                Text("Show sheet")
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .navigationBarBackButtonHidden(store.symbol != nil)
        .sheet(
            config: $store.toolbarConfig,
            item: $store.scope(state: \.symbol, action: \.symbol),
            content: sheetView,
            toolbar: toolbarView
        )
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                FeatureToolbarView(store: store.scope(state: \.featureToolbar, action: \.featureToolbar))
            }
        }
    }
    
    @ViewBuilder
    private func sheetView(symbolStore: StoreOf<SymbolFeature>) -> some View {
        if store.symbol?.symbolStyles.count ?? 0 > 0 {
            SymbolView(store: symbolStore)
        } else {
            Text("+ 버튼을 눌러 Symbol을 추가하세요. ")
        }
    }
    
    private func toolbarView() -> some View {
        HStack(spacing: 10) {  
            Button {
                store.send(.plusToolbarTapped)
            } label: {
                Image(systemName: "plus.circle")
                    .resizable(resizingMode: .tile)
                    .aspectRatio(contentMode: .fit)
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

#Preview {
    SheetToolbarView(store: Store(initialState: SheetToolbarReducer.State()) {
        SheetToolbarReducer()
            ._printChanges()
    })
}
