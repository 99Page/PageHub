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
        
        @Presents var alert: AlertState<Action.Alert>?
        let symbolName = "ellipsis"
        let feature: Feature
        
        var isFailedToFetch = false
        
        var featureVersion: FeatureVersionReducer.State
        
        init(feature: Feature) {
            self.featureVersion = FeatureVersionReducer.State(feature: feature)
            self.feature = feature
        }
    }
    
    enum Action: BindableAction, Equatable {
        case alert(PresentationAction<Alert>)
        case onAppear
        case setSnippetVersion(SnippetVersion)
        case fetchVersionTapped
        case binding(BindingAction<State>)
        case featureVersion(FeatureVersionReducer.Action)
        case snippetFetchFail
        
        @CasePathable
        enum Alert {
            case ok
        }
    }
    
    @Dependency(\.snippetService) var snippetService
    

    var body: some ReducerOf<Self> {
        BindingReducer()
        
        Scope(state: \.featureVersion, action: \.featureVersion) {
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
                    await send(.snippetFetchFail)
                }
            case let .setSnippetVersion(snippetVersion):
                state.featureVersion.snippetVersion = snippetVersion
                return .none
            case .alert(_):
                return .none
            case .fetchVersionTapped:
                if state.isFailedToFetch {
                    state.alert = AlertState {
                        TextState("코드를 불러오지 못했습니다.")
                    } actions: {
                        ButtonState(action: .ok) {
                            TextState("확인")
                        }
                    } message: {
                        TextState("개발자가 실수가 있습니다ㅠㅠ")
                    }
                } else {
                    state.featureVersion.isPresented = true
                }
                return .none
            case .binding(_):
                return .none
            case .featureVersion(_):
                return .none
            case .snippetFetchFail:
                state.isFailedToFetch = true
                return .none
            }
        }
        .ifLet(\.alert, action: \.alert)

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
            FeatureVersionView(store: store.scope(state: \.featureVersion, action: \.featureVersion))
                .presentationDetents([.medium])
        }
        .alert($store.scope(state: \.alert, action: \.alert))
        
    }
}


#Preview {
    FeatureToolbarView(store: Store(initialState: FeatureToolbarReducer.State(feature: .sheetToolbar)) {
        FeatureToolbarReducer()
            ._printChanges()
    })
}

#Preview("Fetch fail") {
    FeatureToolbarView(store: Store(initialState: FeatureToolbarReducer.State(feature: .sheetToolbar)) {
        FeatureToolbarReducer()
            ._printChanges()
    } withDependencies: {
        $0.snippetService = .failValue
    })
}
