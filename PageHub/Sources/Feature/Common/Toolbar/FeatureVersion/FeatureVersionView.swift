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

struct FeatureVersionView: View {
    @Bindable var store: StoreOf<FeatureVersionReducer>
    
    var body: some View {
        if let snippetVersion = store.snippetVersion {
            List {
                versionSectionView(snippetVersion)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .fullScreenCover(item: $store.showCode, content: buildCodeText)
            .alert($store.scope(state: \.alert, action: \.alert))
        } else {
            ProgressView()
        }
    }
    
    private func versionSectionView(_ snippetVersion: SnippetVersion) -> some View {
        Section("MIN iOS VERSION") {
            ForEach(snippetVersion.versions.indices, id: \.self) { index in
                Button(snippetVersion.versions[index]) {
                    let version = snippetVersion.versions[index]
                    store.send(.versionTapped(version: version))
                }
                .foregroundStyle(Color.black)
            }
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
        .onAppear {
            store.send(.codeTextViewAppear)
        }
//        .durationPopupView(config: $store.durationConfig)
    }
}

#Preview("After fetch") {
    
    let snippetVersion = SnippetVersion(versions: ["18.0", "18.1"])
    
    let state = FeatureVersionReducer.State(feature: .sheetToolbar, snippetVersion: snippetVersion)
    
    FeatureVersionView(store: Store(initialState: state) {
        FeatureVersionReducer()
            ._printChanges()
    })
}

#Preview("Before fetch") {
    FeatureVersionView(store: Store(initialState: FeatureVersionReducer.State(feature: .sheetToolbar)) {
        FeatureVersionReducer()
            ._printChanges()
    })
}

#Preview("Fail to fetch") {
    let version = SnippetVersion(versions: ["18.0"])
    
    return FeatureVersionView(store: Store(initialState: FeatureVersionReducer.State(feature: .sheetToolbar, snippetVersion: version)) {
        FeatureVersionReducer()
            ._printChanges()
    } withDependencies: {
        $0.snippetService = .failValue
    })
}
