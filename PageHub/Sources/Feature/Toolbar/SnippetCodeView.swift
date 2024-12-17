//
//  SnippetCodeView.swift
//  PageHub
//
//  Created by 노우영 on 12/9/24.
//  Copyright © 2024 Page. All rights reserved.
//

import SwiftUI
import ComposableArchitecture
import HighlightSwift

@Reducer
struct SnippetCodeReducer {
    @ObservableState
    struct State: Equatable {
        let feature: Feature
        var snippetVersion: SnippetVersion?
        var isPresented: Bool = false
        
        var showCode: FeatureCode?
    }
    
    @Dependency(\.snippetService) var snippetService
    @Dependency(\.clipboardManager) var clipBoardManager
    
    enum Action: BindableAction, Equatable {
        case fetchCodeTapped(version: String)
        case setCode(code: FeatureCode)
        case binding(BindingAction<State>)
        case xButtonTapped
    }
    
    var body: some ReducerOf<Self> {
        BindingReducer()
        
        Reduce { state, action in
            switch action {
            case let .fetchCodeTapped(version):
                let feature = state.feature
                return .run { send in
                    do {
                        var visited: Set<String> = []
                        visited.insert(feature.rawValue)
                        let codeResponse = try await snippetService.fetchCode(feature.rawValue, version, &visited)
                        let code = FeatureCode(codeResponse)
                        await send(.setCode(code: code))
                    } catch {
                        debugPrint("error: \(error)")
                    }
                }
            case let .setCode(code):
                state.showCode = code
                clipBoardManager.copyToClipboard(code.code)
                return .none
            case .binding(_):
                return .none
            case .xButtonTapped:
                state.isPresented = false
                return .none
            }
        }
    }
}

struct SnippetCodeView: View {
    @Bindable var store: StoreOf<SnippetCodeReducer>
    
    var body: some View {
        if let snippetVersion = store.snippetVersion {
            List(snippetVersion.versions.indices, id: \.self) { index in
                Button(snippetVersion.versions[index]) {
                    let version = snippetVersion.versions[index]
                    store.send(.fetchCodeTapped(version: version))
                }
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .fullScreenCover(item: $store.showCode, content: buildCodeText)
        } else {
            ProgressView()
        }
    }
    
    private func buildCodeText(featureCode: FeatureCode) -> some View {
        ScrollView([.horizontal, .vertical]) {
            CodeText(featureCode.code)
                .highlightLanguage(.swift)
                .fixedSize(horizontal: true, vertical: false)
                .layoutPriority(1)
                .font(.caption)
                .frame(maxWidth: .infinity)
        }
        .contentMargins([.horizontal, .top], 10, for: .scrollContent)
        .overlay(alignment: .topTrailing) {
            Button {
                store.send(.xButtonTapped)
            } label: {
                Image(systemName: "xmark.circle")
            }
        }
    }
}

#Preview("After fetch") {
    
    let snippetVersion = SnippetVersion(versions: ["18.0", "18.1"])
    
    let state = SnippetCodeReducer.State(feature: .sheetToolbar, snippetVersion: snippetVersion)
    
    SnippetCodeView(store: Store(initialState: state) {
        SnippetCodeReducer()
            ._printChanges()
    })
}

#Preview("Before fetch") {
    SnippetCodeView(store: Store(initialState: SnippetCodeReducer.State(feature: .sheetToolbar)) {
        SnippetCodeReducer()
            ._printChanges()
    })
}

