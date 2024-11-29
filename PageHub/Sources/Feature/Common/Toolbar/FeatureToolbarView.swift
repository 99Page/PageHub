//
//  FeatureToolbarView.swift
//  PageHub
//
//  Created by 노우영 on 11/28/24.
//  Copyright © 2024 Page. All rights reserved.
//

import ComposableArchitecture
import SwiftUI

@Reducer
struct FeatureToolbarReducer {
    @ObservableState
    struct State: Equatable {
        let featureName: String
        let symbolName = "ellipsis"
        
        var codeVersions: Set<String> = []
    }
    
    enum Action: Equatable {
        case fetchCodeTapped(version: String)
    }
    
    var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case .fetchCodeTapped:
                return .none
            }
        }
    }
}

struct FeatureToolbarView: View {
    
    let store: StoreOf<FeatureToolbarReducer>
    
    var body: some View {
        Menu {
            Menu {
                Text("18.0")
                Text("18.1")
            } label: {
                Text("코드 가져오기")
            }

        } label: {
            Image(systemName: store.symbolName)
        }

    }
}

#Preview {
    FeatureToolbarView(store: Store(initialState: FeatureToolbarReducer.State(featureName: "feature")) {
        FeatureToolbarReducer()
    })
}
