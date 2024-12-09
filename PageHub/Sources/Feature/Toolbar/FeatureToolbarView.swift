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
        
        var showSnippetCode = false
        var snippetCode: SnippetCodeReducer.State
        
        init(feature: Feature) {
            self.snippetCode = SnippetCodeReducer.State(feature: feature)
        }
    }
    
    enum Action: BindableAction, Equatable {
        case onAppear
        case setSnippetVersion(SnippetVersion)
        case alert(PresentationAction<Alert>)
        case fetchVersionTapped
        case setFetchState(to: Bool)
        case binding(BindingAction<State>)
        case snippetCode(SnippetCodeReducer.Action)
        
        enum Alert {
            case snippetFetchError
        }
    }
    
    var body: some ReducerOf<Self> {
        BindingReducer()
        
        Scope(state: \.snippetCode, action: \.snippetCode) {
            SnippetCodeReducer()
        }
        
        Reduce { state, action in
            switch action {
            case .onAppear:
                return .none
//                return .run { send in
//                    let versionResponse = try await snippetService.fetchSnippet(.sheetToolbar)
//                    let snippetVersion = SnippetVersion(snippetResponse: versionResponse)
//                    await send(.setSnippetVersion(snippetVersion))
//                    //                    await send(.setFetchState(to: true))
//                } catch: { _ , send in
//                    //                    await send(.setFetchState(to: true))
//                }
            case let .setSnippetVersion(snippetVersion):
                return .none
            case .alert(_):
                return .none
            case .fetchVersionTapped:
                debugPrint("fetch version tapped")
                
                return .none
            case let .setFetchState(newValue):
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
            Button {
                
            } label: {
                HStack {
                    Text("코드 가져오기")
                }
            }
        } label: {
            Image(systemName: store.symbolName)
        }
        .onAppear {
            store.send(.onAppear)
        }
        .sheet(isPresented: $store.showSnippetCode) {
            SnippetCodeView(store: store.scope(state: \.showSnippetCode, action: \.showSnippetCode))
        }
        
    }
}

#Preview {
    FeatureToolbarView(store: Store(initialState: FeatureToolbarReducer.State(feature: .sheetToolbar)) {
        FeatureToolbarReducer()
    })
}
