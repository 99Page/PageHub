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
        
        /// nil if the data has not yet been fetched from the server or if the fetch operation failed.
        var snippetVersion: SnippetVersion?
        
        init(featureName: String, snippetVersion: SnippetVersion? = nil) {
            self.featureName = featureName
            self.snippetVersion = snippetVersion
        }
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
                if let snippetVersion = store.snippetVersion {
                    ForEach(snippetVersion.versions.indices, id: \.self) { index in
                        Button {
                            
                        } label: {
                            Text(snippetVersion.versions[index])
                        }

                    }
                }
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
