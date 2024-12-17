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
        let symbolName = "ellipsis"
        let feature: Feature
        
        var featureVersion: FeatureVersionReducer.State
        
        init(feature: Feature) {
            self.featureVersion = FeatureVersionReducer.State(feature: feature)
            self.feature = feature
        }
    }
    
    enum Action: BindableAction, Equatable {
        case onAppear
        case setSnippetVersion(SnippetVersion)
        case alert(PresentationAction<Alert>)
        case fetchVersionTapped
        case binding(BindingAction<State>)
        case snippetCode(FeatureVersionReducer.Action)
        
        enum Alert {
            case snippetFetchError
        }
    }
    
    @Dependency(\.snippetService) var snippetService
    
    var body: some ReducerOf<Self> {
        BindingReducer()
        
        Scope(state: \.featureVersion, action: \.snippetCode) {
            FeatureVersionReducer()
        }
        
        Reduce { state, action in
            switch action {
            case .onAppear:
                let feature = state.feature
                
                return .run { send in
                    let versionResponse = try await snippetService.fetchSnippet(feature)
                    let snippetVersion = SnippetVersion(snippetResponse: versionResponse)
                    await send(.setSnippetVersion(snippetVersion))
                } catch: { _ , send in
                    
                }
            case let .setSnippetVersion(snippetVersion):
                state.featureVersion.snippetVersion = snippetVersion
                return .none
            case .alert(_):
                return .none
            case .fetchVersionTapped:
                state.featureVersion.isPresented = true
                return .none
            case .binding(_):
                return .none
            case .snippetCode(_):
                return .none
            }
        }

    }
}

struct FeatureToolbarView: View {
    
    @Bindable var store: StoreOf<FeatureToolbarReducer>
    
    var body: some View {
        Menu {
            Button("코드 가져오기") {
                store.send(.fetchVersionTapped)
            }
        } label: {
            Image(systemName: store.symbolName)
        }
        .onAppear {
            store.send(.onAppear)
        }
        .sheet(isPresented: $store.featureVersion.isPresented) {
            FeatureVersionView(store: store.scope(state: \.featureVersion, action: \.snippetCode))
                .presentationDetents([.medium])
        }
        
    }
}

#Preview {
    FeatureToolbarView(store: Store(initialState: FeatureToolbarReducer.State(feature: .sheetToolbar)) {
        FeatureToolbarReducer()
            ._printChanges()
    })
}
