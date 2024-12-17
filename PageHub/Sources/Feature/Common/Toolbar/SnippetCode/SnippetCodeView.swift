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

