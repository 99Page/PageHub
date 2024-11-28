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
        .sheet(config: $store.toolbarConfig, item: $store.scope(state: \.symbol, action: \.symbol)) { symbolStore in
            SymbolView(store: symbolStore)
        } toolbar: {
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

#Preview {
    SheetToolbarView(store: Store(initialState: SheetToolbarFeature.State()) {
        SheetToolbarFeature()
            ._printChanges()
    })
}
