//
//  SnippetCodeView.swift
//  PageHub
//
//  Created by 노우영 on 12/9/24.
//  Copyright © 2024 Page. All rights reserved.
//

import SwiftUI
import ComposableArchitecture

@Reducer
struct SnippetCodeReducer {
    @ObservableState
    struct State: Equatable {
        @Presents var alert: AlertState<Action.Alert>?
        let feature: Feature
        var isVersionFetchEnded: Bool = false
        var snippetVersion: SnippetVersion?
    }
    
    @Dependency(\.snippetService) var snippetService
    
    enum Action: Equatable {
        case onAppear
        case setSnippetVersion(snippetVersion: SnippetVersion)
        case alert(PresentationAction<Alert>)
        
        enum Alert {
            case snippetFetchError
        }
    }
    
    var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case .onAppear:
                return .none
            case let .setSnippetVersion(snippetVersion):
                return .none
            case .alert(_):
                return .none
            }
        }
        .ifLet(\.$alert, action: \.alert)
    }
}

struct SnippetCodeView: View {
    let store: StoreOf<SnippetCodeReducer>
    
    var body: some View {
        if let snippetVersion = store.snippetVersion {
            Text("Version fetched")
        } else {
            ProgressView()
                .onAppear {
                    store.send(.onAppear)
                }
        }
    }
}

#Preview {
    SnippetCodeView(store: Store(initialState: SnippetCodeReducer.State(feature: .sheetToolbar)) {
        SnippetCodeReducer()
    })
}
