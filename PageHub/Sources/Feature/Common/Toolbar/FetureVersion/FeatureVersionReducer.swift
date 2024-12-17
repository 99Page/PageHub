//
//  SnippetCodeReducer.swift
//  PageHub
//
//  Created by 노우영 on 12/17/24.
//  Copyright © 2024 Page. All rights reserved.
//

import ComposableArchitecture

@Reducer
struct FeatureVersionReducer {
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
